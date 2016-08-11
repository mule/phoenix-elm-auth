module App.Common exposing (Msg(..), Page(..))
import Pages.Login.Update exposing (Msg(..))
import Pages.SignUp.Update exposing (InternalMsg)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Dict
import App.Notifications exposing(..)
import User.Model exposing(User)
import HttpBuilder

type Page
    = Login
    | SignUp
    | Landing
    | PageNotFound

type Msg
    = Logout
    | PageLogin Pages.Login.Update.Msg
    | PageSignUp Pages.SignUp.Update.InternalMsg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveCommandMessage JE.Value
    | DismissNotification Int
    | LogoutSucceed (HttpBuilder.Response Bool)
    | LogoutFailed  (HttpBuilder.Error String)
    | UserRegistered
    | UserFetchFailed (HttpBuilder.Error String)
    | UserFetchSuccesfull (HttpBuilder.Response User)
    | SetActivePage Page
    | Noop