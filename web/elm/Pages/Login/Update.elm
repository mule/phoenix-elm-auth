
module Pages.Login.Update exposing (update, Msg(..), TranslationDictionary, Translator, InternalMsg, translator)

import Exts.RemoteData exposing (RemoteData(..), WebData)
import Http
import Regex exposing (regex, replace, HowMany(All))
import String exposing (isEmpty)
import Task
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import User.Model exposing (..)
import Pages.Login.Model as Login exposing (..)
import Json.Decode exposing (Decoder, bool, (:=))
import Json.Encode exposing (encode, object, string)


type InternalMsg
    = LoginFail Http.Error
    | LoginSucceed User
    | SetEmail String
    | SetPassword String
    | TryLocalLogin
    | TryOAuthLogin

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
        LoginSucceed newUserData ->
            model ! [generateParentMessage (UserLoggedIn newUserData) ]
        LoginFail err ->
            ( model, Cmd.none )
        SetEmail emailTxt ->
            ({ model | email = emailTxt }, Cmd.none)
        SetPassword passwordTxt ->
            {model | password = passwordTxt } ! [ Cmd.none ]
        TryLocalLogin ->
            (model, login model)

localLogin: model -> Cmd Msg
localLogin model =
    let url =
            "api/sessions"
        user =
            object 
            [
                ("email", model.email ),
                ("password", model.password)
            ]
        createSessionRequest =
            HttpBuilder.create url
            |> withHeader "Content-type" "application/json"
            |> withJsonBody user
            |> send (jsonReader decodeLoginResponse) stringReader
        in
            Cmd.map ForSelf ( Task.perform  LoginFail LoginSucceed createSessionRequest ) 









