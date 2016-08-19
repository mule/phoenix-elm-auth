
module Pages.Login.Update exposing (update, Msg(..), TranslationDictionary, Translator, InternalMsg(..),translator)
import Exts.RemoteData exposing (RemoteData(..), WebData)
import Http
import Regex exposing (regex, replace, HowMany(All))
import String exposing (isEmpty)
import Task
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import User.Model exposing (..)
import Array exposing (..)
import Pages.Login.Model  exposing (..)
import Json.Decode exposing (Decoder, bool, object4, object2, array, string, maybe, int, (:=))
import Json.Encode exposing (encode, object, string)
import App.Notifications exposing (Notification, NotificationLevel)


type InternalMsg
    = LoginFail (HttpBuilder.Error (Bool, (Array String)))
    | LoginSucceed (HttpBuilder.Response User)
    | SetEmail String
    | SetPassword String
    | TryLocalLogin


type OutMsg
    = UserLoggedIn User
    | Notify (Array Notification)

type Msg 
    = ForSelf InternalMsg
    | ForParent OutMsg

type alias TranslationDictionary msg =
    { onInternalMessage: InternalMsg -> msg
    , onUserLoggedIn: User -> msg
    , onNotify: (Array Notification) -> msg
    }

type alias Translator msg =
    Msg -> msg

translator : TranslationDictionary msg -> Translator msg
translator { onInternalMessage, onUserLoggedIn, onNotify } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal
        ForParent (UserLoggedIn user) ->
            onUserLoggedIn user
        ForParent (Notify notifications) ->
            onNotify notifications

never : Never -> a
never n =
    never n

generateParentMessage : OutMsg -> Cmd Msg
generateParentMessage outMsg =
    Task.perform never ForParent (Task.succeed outMsg )

init : ( Model, Cmd Msg )
init =
    Pages.Login.Model.emptyModel ! []

update : InternalMsg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        LoginSucceed loginResponse ->
            model ! [generateParentMessage (UserLoggedIn loginResponse.data) ]
        LoginFail (HttpBuilder.BadResponse response) ->
            let notifications = 
                snd response.data |> Array.map (\error -> Notification App.Notifications.Error error False)
            in
                model ! [generateParentMessage <| Notify notifications]
        LoginFail (HttpBuilder.UnexpectedPayload error) ->
            let notifications = 
                    Array.fromList [Notification App.Notifications.Error error False]
            in
                model ! [Notify notifications |> generateParentMessage]
        LoginFail _ ->
            let notificationMsg = 
                "No connection or server not available"
                notifications =
                    Array.fromList [Notification App.Notifications.Error notificationMsg False]
                in
                    model ! [Notify notifications |> generateParentMessage]

        SetEmail emailTxt ->
            ({ model | email = emailTxt }, Cmd.none)
        SetPassword passwordTxt ->
            {model | password = passwordTxt } ! [ Cmd.none ]
        TryLocalLogin ->
            (model, localLogin model)

localLogin: Model -> Cmd Msg
localLogin model =
    let url =
            "api/sessions"
        user =
            object 
            [
                ("email", Json.Encode.string model.email ),
                ("password", Json.Encode.string model.password)
            ]
        createSessionRequest =
            HttpBuilder.post url
            |> withHeader "Content-type" "application/json"
            |> withJsonBody user
            |> send (jsonReader decodeUserResponse) (jsonReader decodeErrorResponse)
        in
            Cmd.map ForSelf ( Task.perform  LoginFail LoginSucceed createSessionRequest ) 



decodeUserResponse : Decoder User
decodeUserResponse =
    object4 User
        (maybe ("avatarUrl" := Json.Decode.string))
        (maybe ("name" := Json.Decode.string))
        (maybe ("userId" := int))
        ("authenticated" := bool)


decodeErrorResponse : Decoder (Bool, Array String)
decodeErrorResponse =
        object2 (,)
            ("ok" := bool)
            ("errors" := array Json.Decode.string)
