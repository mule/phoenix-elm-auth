module App.Common exposing (Msg(..), Page(..))
import Pages.Login.Update exposing (Msg(..))
import Pages.SignUp.Update exposing (Msg(..))
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Dict



type Page
    = Login
    | SignUp
    | MyAccount
    | PageNotFound


type Msg
    = Logout
    | PageLogin Pages.Login.Update.Msg
    | PageSignUp Pages.SignUp.Update.Msg
    | SetActivePage Page
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveCommandMessage JE.Value
    | Noop