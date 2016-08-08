module Pages.SignUp.Update exposing (update, Msg(..), TranslationDictionary, Translator, translator, InternalMsg(..))
import Pages.SignUp.Model exposing (..)
import Http
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import Task exposing (Task)
import Json.Decode exposing (Decoder, bool, (:=))
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
    | RegisterFail (HttpBuilder.Error String)
    | ValidateModel
    | Noop

type OutMsg 
    = UserRegistered

type Msg 
    = ForSelf InternalMsg
    | ForParent OutMsg

type alias TranslationDictionary msg =
    { onInternalMessage: InternalMsg -> msg
    , onUserRegistered: msg
    }

type alias Translator msg =
    Msg -> msg


translator : TranslationDictionary msg -> Translator msg
translator { onInternalMessage, onUserRegistered } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal
        ForParent UserRegistered ->
            onUserRegistered 

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
            case  error of
                HttpBuilder.BadResponse response ->
                    case Debug.log "Register response status" response.status of
                        422 -> 
                            ( { model | registrationPending = False }, Cmd.none )
                        _ ->
                            ( { model | registrationPending = False }, Cmd.none )
                _ ->
                    ( { model | registrationPending = False }, Cmd.none)
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
            |> send (jsonReader decodeRegisterResponse) stringReader
    in
        Cmd.map ForSelf ( Task.perform  RegisterFail RegisterSucceed postRequest ) 

decodeRegisterResponse : Decoder Bool
decodeRegisterResponse = 
        "ok" := bool

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




