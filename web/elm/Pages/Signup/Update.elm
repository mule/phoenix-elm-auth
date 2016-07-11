module Pages.SignUp.Update exposing (update, Msg(..))
import Pages.SignUp.Model exposing (..)
import Http
import Task exposing (Task)
import Json.Decode exposing (Decoder, bool, (:=))
import Json.Encode exposing (encode, object, string)
import Debug

type Msg
 = SetEmail String
 | SetDisplayName String
 | ValidateEmail String
 | Register
 | RegisterSucceed Bool
 | RegisterFail Http.Error
     

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
        RegisterFail _ ->
            ( { model | registrationPending = False }, Cmd.none )

registerUser : Model -> Cmd Msg
registerUser model =
    let url = 
            "/api/users"
        user =
            object
            [ ("user",  object [
                ("email", string model.email)
            ])]


    in
        Task.perform RegisterFail RegisterSucceed (Http.post decodeRegisterResponse url  <| Http.string  <| encode 4 user)


decodeRegisterResponse : Decoder Bool

decodeRegisterResponse = 
        "ok" := bool


