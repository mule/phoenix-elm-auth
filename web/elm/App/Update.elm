module App.Update exposing (init, update, Model)
import App.Common exposing (..)
import App.Notifications exposing (Notification, NotificationLevel(..))
import Exts.RemoteData exposing (RemoteData(..), WebData)
import User.Model exposing (..)
import Array exposing (..)
import Pages.Login.Update exposing (Msg)
import Pages.Login.Model
import Pages.SignUp.Model
import Pages.SignUp.Update exposing (Msg)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Debug

type alias Model =
    { activePage : Page
    , user : WebData User
    , notifications : Array Notification
    , pageSignUp : Pages.SignUp.Model.Model 
    , pageLogin : Pages.Login.Model.Model
    , phxSocket : Phoenix.Socket.Socket App.Common.Msg
    }


emptyModel : Model
emptyModel =
    { activePage = Login
    , pageLogin = Pages.Login.Model.emptyModel
    , pageSignUp = Pages.SignUp.Model.emptyModel
    , user = NotAsked
    , notifications = Array.empty
    , phxSocket = Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
        |> Phoenix.Socket.withDebug 
        |> Phoenix.Socket.on "new:msg" "commands:lobby" ReceiveCommandMessage
    }

init : ( Model, Cmd App.Common.Msg )
init =
    emptyModel ! []

update : App.Common.Msg -> Model -> ( Model, Cmd App.Common.Msg )
update appMsg model =
    case Debug.log "App action" appMsg of
        Logout ->
            init

        PageLogin msg ->
            model ! []

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) = Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        PageSignUp msg ->
            let 
                ( signUpModel, signUpPageCmd, pageNotifications ) = Pages.SignUp.Update.update msg model.pageSignUp
                appendedNotifications = pageNotifications |> fromList |> Array.append model.notifications
            in
                ( { model | pageSignUp = signUpModel, notifications = appendedNotifications  }
                , Cmd.map PageSignUp signUpPageCmd
                )

        SetActivePage page ->
            { model | activePage = page } ! []
        
        ReceiveCommandMessage raw ->
             model ! [] 
        DismissNotification index ->
            let updatedNotifications = 
                case Array.get index model.notifications of 
                    Just value ->
                        Array.set index { value | dismissed = True } model.notifications
                    Nothing ->
                        model.notifications
            in
                {model | notifications = updatedNotifications } ! []
        Noop -> 
            model ! []  

-- setActivePageAccess : WebData User -> Page -> Page
-- setActivePageAccess user page =
--     case user of
--         Success _ ->
--             if page == Login then
--                 AccessDenied
--             else
--                 page

--         _ ->
--             if page == MyAccount then
--                 AccessDenied
--             else
--                 page
