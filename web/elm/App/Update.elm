module App.Update exposing (init, update, Model)
import App.Common exposing (..)
import App.Notifications exposing (Notification, NotificationLevel(..))
import Exts.RemoteData exposing (RemoteData(..), WebData)
import User.Model exposing (..)
import Array exposing (..)
import Pages.Login.Update exposing (Msg)
import Pages.Login.Model
import Pages.SignUp.Model
import Pages.SignUp.Update as SignUp
import Pages.LandingPage.Model
import Update.Extra exposing (andThen)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Http
import HttpBuilder exposing (withHeader, withJsonBody, stringReader, jsonReader, send)
import Json.Decode exposing (Decoder, bool, object4, string, maybe, int, (:=))
import Task exposing (Task)
import Debug

type alias Model =
    { activePage : Page
    , user :  User
    , notifications : Array Notification
    , pageSignUp : Pages.SignUp.Model.Model 
    , pageLogin : Pages.Login.Model.Model
    , pageLanding : Pages.LandingPage.Model.Model
    , phxSocket : Phoenix.Socket.Socket App.Common.Msg
    }



emptyModel : Model
emptyModel =
    { activePage = Landing
    , pageLogin = Pages.Login.Model.emptyModel
    , pageSignUp = Pages.SignUp.Model.emptyModel
    , user = User.Model.emptyModel
    , notifications = Array.empty 
    , pageLanding = Pages.LandingPage.Model.emptyModel
    , phxSocket = Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
        |> Phoenix.Socket.withDebug 
        |> Phoenix.Socket.on "new:msg" "commands:lobby" ReceiveCommandMessage
    }

init : ( Model, Cmd App.Common.Msg )
init =   
    emptyModel ! [fetchCurrentUser]

signUpTranslator : SignUp.Translator App.Common.Msg 
signUpTranslator =
    SignUp.translator { onInternalMessage = PageSignUp , onUserRegistered = UserRegistered  } 

 
update : App.Common.Msg -> Model -> ( Model, Cmd App.Common.Msg )
update appMsg model =
    case Debug.log "App action" appMsg of
        Logout ->
            (model, logoutUser)
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
            let ( signUpModel, signUpCmd ) =
                SignUp.update msg model.pageSignUp
            in
                { model | pageSignUp = signUpModel } ! [ Cmd.map signUpTranslator signUpCmd ]

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
        LogoutSucceed _ ->
            emptyModel ! []
        LogoutFailed _ ->
            model ! []
        UserRegistered ->
            model ! [fetchCurrentUser]
            |> andThen update (SetActivePage Landing)
        UserFetchSuccesfull userResponse ->
            {model | user = userResponse.data} ! []
        UserFetchFailed error ->
            model ! []
        Noop -> 
            model ! []  


logoutUser : Cmd App.Common.Msg
logoutUser = 
    let url =
            "/api/sessions/1" 
        logoutRequest = 
            HttpBuilder.delete url
            |> send (jsonReader decodeLogoutResponse) stringReader
    in
        Task.perform LogoutFailed LogoutSucceed logoutRequest
            
fetchCurrentUser : Cmd App.Common.Msg
fetchCurrentUser = 
    let url = 
            "api/sessions/"
        currentUserRequest =
            HttpBuilder.get url
            |> send (jsonReader decodeUserResponse) stringReader
    in
        Task.perform UserFetchFailed UserFetchSuccesfull currentUserRequest

decodeUserResponse : Decoder User
decodeUserResponse =
    object4 User
        (maybe ("avatarUrl" := string))
        (maybe ("name" := string))
        (maybe ("userId" := int))
        ("authenticated" := bool)
        


decodeLogoutResponse : Decoder Bool
decodeLogoutResponse = 
        "ok" := bool


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
