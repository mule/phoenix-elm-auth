module App.Model exposing (emptyModel, Model, Page(..))

import Exts.RemoteData exposing (RemoteData(..), WebData)

import User.Model exposing (..)
import Pages.Login.Model exposing (emptyModel, Model)
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


type alias Model =
    { activePage : Page
    , pageLogin : Pages.Login.Model.Model
    , user : WebData User
    , phxSocket : Phoenix.Socket.Socket Msg
    }


emptyModel : Model
emptyModel =
    { activePage = Login
    , pageLogin = Pages.Login.Model.emptyModel
    , user = NotAsked
    }
