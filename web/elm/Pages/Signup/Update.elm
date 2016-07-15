module Pages.SignUp.Update exposing (update, Msg(..))
import Pages.SignUp.Model exposing (..)
import Http
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import Task exposing (Task)
import Json.Decode exposing (Decoder, bool, (:=))
import Json.Encode exposing (encode, object, string)
import String
import Update.Extra exposing (andThen)
import Debug

type Msg
 = SetEmail String
 | SetDisplayName String
 | SetPassword String
 | SetPasswordConfirm String
 | Register
 | RegisterSucceed (HttpBuilder.Response Bool)
 | RegisterFail (HttpBuilder.Error String)
 | ValidateModel


init : ( Model, Cmd Msg )
init =
    emptyModel ! []

update : Msg -> Model -> (Model, Cmd Msg)

update  msg model =
    case Debug.log "Signup action" msg of
        SetEmail emailStr ->
            ( {model | email = emailStr }, Cmd.none )
            |> andThen update ValidateModel

        SetDisplayName nameStr ->
            ( { model | displayName = nameStr }, Cmd.none )
            |> andThen update ValidateModel
    
        SetPassword passwordStr ->
            ( { model | password = passwordStr }, Cmd.none ) 
            |> andThen update ValidateModel
            
        SetPasswordConfirm passwordConfirmStr ->
            ( { model | passwordConfirmation = passwordConfirmStr }, Cmd.none )
            |> andThen update ValidateModel

        ValidateModel ->
            let validatedModel =
                validateModel model
            in
                ( validatedModel, Cmd.none )

        Register ->
            ( { model | registrationPending = True }, registerUser model )
        RegisterSucceed _ -> 
            ( { model | registrationPending = False }, Cmd.none )
            
        RegisterFail  error ->
            case  error of
                HttpBuilder.BadResponse response ->
                    case Debug.log "Register response status" response.status of
                        422 -> 
                            ( { model | registrationPending = False }, Cmd.none )
                        _ ->
                            ( { model | registrationPending = False }, Cmd.none )
                _ ->
                    ( { model | registrationPending = False }, Cmd.none )


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
                        ("email", (string model.email))
                    ]
                )
            ]

        postRequest =
            HttpBuilder.post url
            |> withHeader "Content-type" "application/json"
            |> withJsonBody user
            |> send (jsonReader decodeRegisterResponse) stringReader
    in
        --Task.perform RegisterFail RegisterSucceed (Http.post decodeRegisterResponse url  <| Http.string  <| encode 0 user)
        Task.perform RegisterFail RegisterSucceed postRequest 

decodeRegisterResponse : Decoder Bool
decodeRegisterResponse = 
        "ok" := bool

validateRequired : String -> String -> String

validateRequired fieldContent fieldName =
            case String.isEmpty fieldContent of 
                True -> String.join " " [ fieldName, "required" ]
                False ->  ""

validateEmail : String -> List String

validateEmail email =
    let requiredResult = 
            validateRequired email "Email"
        validationResults =
            [requiredResult]
    in
        case List.all String.isEmpty validationResults of 
            True -> [] 
            False -> List.filter (\error -> String.length error > 0) validationResults

validateModel : Model -> Model
validateModel model =
    let emailResult =
            validateEmail model.email
        errors =
            [emailResult]
        modelValid = List.all List.isEmpty errors
    in
        { model | 
            emailErrors = emailResult,
            modelValid = modelValid
        }



