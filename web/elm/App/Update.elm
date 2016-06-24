module App.Update exposing (init, update, Model)
import App.Common exposing (..)
import Exts.RemoteData exposing (RemoteData(..), WebData)
import User.Model exposing (..)
import Pages.Login.Update exposing (Msg)
import Pages.Login.Model
import Pages.SignUp.Model
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Debug

type alias Model =
    { activePage : Page
    , user : WebData User
    , pageLogin : Pages.Login.Model.Model
    , pageSignUp: Pages.SignUp.Model.Model
    , phxSocket : Phoenix.Socket.Socket App.Common.Msg
    }


emptyModel : Model
emptyModel =
    { activePage = Login
    , pageLogin = Pages.Login.Model.emptyModel
    , pageSignUp = Pages.SignUp.Model.init
    , user = NotAsked
    , phxSocket = Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
        |> Phoenix.Socket.withDebug
    }




init : ( Model, Cmd App.Common.Msg )
init =
    emptyModel ! []


update : App.Common.Msg -> Model -> ( Model, Cmd App.Common.Msg )
update msg model =
    case Debug.log "action" msg of
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

        PageSignUp ->
            model ! []

        SetActivePage page ->
            { model | activePage = page } ! []
        
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
