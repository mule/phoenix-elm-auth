module App.Common exposing (Msg(..), Page(..))
import Pages.Login.Update exposing (Msg(..))
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push



type Page
    = AccessDenied
    | Login
    | SignUp
    | SignUpForm
    | MyAccount
    | PageNotFound

type Msg
    = Logout
    | PageLogin Pages.Login.Update.Msg
    | PageSignUp
    | PageSignUpForm
    | SetActivePage Page
    | PhoenixMsg (Phoenix.Socket.Msg Msg)