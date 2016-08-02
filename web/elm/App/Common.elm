module App.Common exposing (Msg(..), Page(..))
import Pages.Login.Update exposing (Msg(..))
import Pages.SignUp.Update exposing (Msg(..))
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Dict
import App.Notifications exposing(..)
import App.Navigation as Navigation
import HttpBuilder




type Msg
    = Logout
    | PageLogin Pages.Login.Update.Msg
    | PageSignUp Pages.SignUp.Update.Msg
    | Navigation Navigation.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveCommandMessage JE.Value
    | DismissNotification Int
    | LogoutSucceed (HttpBuilder.Response Bool)
    | LogoutFailed  (HttpBuilder.Error String)
    | Noop