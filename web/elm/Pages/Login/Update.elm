
module Pages.Login.Update exposing (update, Msg(..), TranslationDictionary, Translator, InternalMsg, translator)

import Exts.RemoteData exposing (RemoteData(..), WebData)
import Http
import Regex exposing (regex, replace, HowMany(All))
import String exposing (isEmpty)
import Task
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import User.Model exposing (..)
import Pages.Login.Model as Login exposing (..)


type InternalMsg
    = FetchFail Http.Error
    | FetchSucceed User
    | SetName String
    | TryLogin

type OutMsg
    = UserLoggedIn User

type Msg 
    = ForSelf InternalMsg
    | ForParent OutMsg

type alias TranslationDictionary msg =
    { onInternalMessage: InternalMsg -> msg
    , onUserLoggedIn: User -> msg
    }

type alias Translator msg =
    Msg -> msg

translator : TranslationDictionary msg -> Translator msg
translator { onInternalMessage, onUserLoggedIn } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal
        ForParent (UserLoggedIn user) ->
            onUserLoggedIn user

never : Never -> a
never n =
    never n

generateParentMessage : OutMsg -> Cmd Msg
generateParentMessage outMsg =
    Task.perform never ForParent (Task.succeed outMsg )


init : ( Model, Cmd Msg )
init =
    Login.emptyModel ! []


update : InternalMsg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        FetchSucceed newUserData ->
            model ! [generateParentMessage (UserLoggedIn newUserData) ]
        FetchFail err ->
            ( model, Cmd.none )

        SetName name ->
            ({ model | name = name }, Cmd.none)

        TryLogin ->
            (model, Cmd.none)

login: model -> Cmd Msg
login model =
    let url =
        "api/sessions"
        







