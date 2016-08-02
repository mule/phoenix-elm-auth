
module Pages.Login.Update exposing (update, Msg(..))

import Exts.RemoteData exposing (RemoteData(..), WebData)
import Http
import Regex exposing (regex, replace, HowMany(All))
import String exposing (isEmpty)
import Task
import User.Model exposing (..)
import Pages.Login.Model as Login exposing (..)


type Msg
    = FetchFail Http.Error
    | FetchSucceed User
    | SetName String
    | TryLogin


init : ( Model, Cmd Msg )
init =
    Login.emptyModel ! []


update : Model -> Msg -> User -> ( Model, Cmd Msg, User )
update model msg user =
    case msg of
        FetchSucceed newUserData ->
            ( model, Cmd.none, user )            
        FetchFail err ->
            ( model, Cmd.none, user )

        SetName name ->
            ({ model | name = name }, Cmd.none, user)

        TryLogin ->
            (model, Cmd.none, user) 






