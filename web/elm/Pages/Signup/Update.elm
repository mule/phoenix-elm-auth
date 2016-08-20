module Pages.SignUp.Update exposing (update, Msg(..), TranslationDictionary, Translator, translator, InternalMsg(..))
import Pages.SignUp.Model exposing (..)
import Http
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import Task exposing (Task)
import Array exposing (..)
import App.Notifications exposing (..)
import Json.Decode exposing (Decoder, bool, object2, array, (:=))
import Json.Encode exposing (encode, object, string)
import String
import Update.Extra exposing (andThen)
import Debug



type InternalMsg
    = SetEmail String
    | SetDisplayName String
    | SetPassword String
    | SetPasswordConfirm String
    | Register
    | RegisterSucceed (HttpBuilder.Response Bool)
    | RegisterFail (HttpBuilder.Error (Bool, Array String))
    | ValidateModel
    | Noop

type OutMsg 
    = UserRegistered
    | Notify (Array Notification)

type Msg 
    = ForSelf InternalMsg
    | ForParent OutMsg

type alias TranslationDictionary msg =
    { onInternalMessage: InternalMsg -> msg
    , onUserRegistered: msg
    , onNotify: (Array Notification) -> msg
    }

type alias Translator msg =
    Msg -> msg

translator : TranslationDictionary msg -> Translator msg
translator { onInternalMessage, onUserRegistered, onNotify } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal
        ForParent UserRegistered ->
            onUserRegistered
        ForParent (Notify notifications) ->
            onNotify notifications

never : Never -> a
never n =
    never n

generateParentMessage : OutMsg -> Cmd Msg
generateParentMessage outMsg =
    Task.perform never ForParent (Task.succeed outMsg )

init : ( Model )
init =
    ( emptyModel )

update : InternalMsg -> Model -> (Model, Cmd Msg)

update  msg model =
    case Debug.log "Signup action" msg of
        SetEmail emailStr ->
            let model' =
                {model | email = emailStr }
            in
                 update ValidateModel model'

        SetDisplayName nameStr ->
            let model' = 
                { model | displayName = nameStr }
            in
                update ValidateModel model'
    
        SetPassword passwordStr ->
            let model' =
                { model | password = passwordStr }
            in
                update ValidateModel model'
            
        SetPasswordConfirm passwordConfirmStr ->
        let model' = 
            { model | passwordConfirmation = passwordConfirmStr }
        in 
            update ValidateModel model'

        ValidateModel ->
            let validatedModel =
                    validateModel model
                test = Debug.log "validated model" validatedModel
            in
                ( validatedModel, Cmd.none )

        Register ->
            ( { model | registrationPending = True }, registerUser model)
                 
        RegisterSucceed _ -> 
            ( { model | registrationPending = False }, (generateParentMessage UserRegistered) )
             
        RegisterFail  error ->
            let notifications =
                createNotifications error
            in
                model ! [Notify notifications |> generateParentMessage]
        Noop ->
            (model, Cmd.none)


registerUser : Model -> Cmd Msg
registerUser model =
    let url = 
            "/api/users"

        user =
            object [
                ("user",
                    object
                    [
                        ("display_name", (string model.displayName)),
                        ("email", (string model.email)),
                        ("password", (string model.password)),
                        ("passwordConfirmation", (string model.passwordConfirmation))
                    ]
                )
            ]

        postRequest =
            HttpBuilder.post url
            |> withHeader "Content-type" "application/json"
            |> withJsonBody user
            |> send (jsonReader decodeRegisterResponse) (jsonReader decodeErrorResponse)
    in
        Cmd.map ForSelf ( Task.perform  RegisterFail RegisterSucceed postRequest ) 

decodeRegisterResponse : Decoder Bool
decodeRegisterResponse = 
        "ok" := bool

decodeErrorResponse : Decoder (Bool, Array String)
decodeErrorResponse =
        object2 (,)
            ("ok" := bool)
            ("errors" := array Json.Decode.string)

validateRequired : String -> String -> Maybe String

validateRequired fieldContent fieldName =
            case String.isEmpty fieldContent of 
                True -> Just <| String.join " " [ fieldName, "required" ]
                False ->  Nothing

validateEmail : String -> List (Maybe String)

validateEmail email =
    let requiredResult = 
            validateRequired email "Email"
    in
        [requiredResult]

validatePassword : String -> String -> List (Maybe String) 
validatePassword password passwordConf =
    let requiredResult =
             validateRequired password "Password"
        confirmResult =
            case password == passwordConf of
                True -> Nothing
                False ->  Just "Password confirmation does not match"
    in
        [ requiredResult, confirmResult ] 

validateModel : Model -> Model
validateModel model =
    let emailResult =
            validateEmail model.email
        displayNameResult =
            validateRequired model.displayName "Displayname" :: []
        passwordResult =
            validatePassword model.password model.passwordConfirmation
        errors =
            List.concat [emailResult,  displayNameResult, passwordResult ] |> List.filterMap identity
        modelValid = List.isEmpty errors
    in
        { model | 
            emailErrors = emailResult,
            displayNameErrors = displayNameResult,
            passwordErrors = passwordResult,
            modelValid = modelValid
        }




