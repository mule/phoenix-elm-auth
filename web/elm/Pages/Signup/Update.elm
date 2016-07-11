module Pages.SignUp.Update exposing (update, Msg(..))
import Pages.SignUp.Model exposing (..)
import Http
import Task exposing (Task)
import Json.Decode exposing (succeed)
import Debug

type Msg
 = SetEmail String
 | SetDisplayName String
 | ValidateEmail String
     

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
            ( { model | registrationPending = false, Cmd..none })



