module Pages.SignUp.Update exposing (update, Msg(..))
import Pages.SignUp.Model exposing (..)
import Http
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import Task exposing (Task)
import Json.Decode exposing (Decoder, bool, (:=))
import Json.Encode exposing (encode, object, string)
import Debug

type Msg
 = SetEmail String
 | SetDisplayName String
 | ValidateEmail String
 | Register
 | RegisterSucceed (HttpBuilder.Response Bool)
 | RegisterFail (HttpBuilder.Error String)


init : ( Model, Cmd Msg )
init =
    emptyModel ! []

update : Msg -> Model -> (Model, Cmd Msg)

update  msg model =
    case Debug.log "Signup action" msg of
        SetEmail emailStr ->
            ( {model | email = emailStr }, Cmd.none )
        SetDisplayName nameStr ->
            ( {model | displayName = nameStr }, Cmd.none )
        ValidateEmail emailStr ->
            ( model, Cmd.none )
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


