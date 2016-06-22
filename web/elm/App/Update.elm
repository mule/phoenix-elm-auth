module App.Update exposing (init, update, Msg(..), Page(..), Model)

import Exts.RemoteData exposing (RemoteData(..), WebData)
import User.Model exposing (..)
import Pages.Login.Update exposing (Msg)
import Pages.Login.Model
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Debug

type Page
    = AccessDenied
    | Login
    | SignUp
    | MyAccount
    | PageNotFound


type alias Model =
    { activePage : Page
    , user : WebData User
    ,pageLogin : Pages.Login.Model.Model
    , phxSocket : Phoenix.Socket.Socket Msg
    }


emptyModel : Model
emptyModel =
    { activePage = Login
    , pageLogin = Pages.Login.Model.emptyModel
    , user = NotAsked
    , phxSocket = Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
        |> Phoenix.Socket.withDebug
    }

type Msg
    = Logout
    | PageLogin Pages.Login.Update.Msg
    | PageSignUp
    | SetActivePage Page
    | PhoenixMsg (Phoenix.Socket.Msg Msg)


init : ( Model, Cmd Msg )
init =
    emptyModel ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "action" msg of
        Logout ->
            init

        PageLogin msg ->
            let
                ( val, cmds, user ) =
                    Pages.Login.Update.update model.user msg model.pageLogin

                model' =
                    { model
                        | pageLogin = val
                        , user = user
                    }

                model'' =
                    case user of
                        -- If user was successfuly fetched, reditect to my
                        -- account page.
                        Success _ ->
                            update (SetActivePage MyAccount) model'
                                |> fst

                        _ ->
                            model'
            in
                ( model'', Cmd.map PageLogin cmds )
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
            { model | activePage = setActivePageAccess model.user page } ! []


{-| Determine is a page can be accessed by a user (anonymous or authenticated),
and if not return a access denied page.
If the user is authenticated, don't allow them to revisit Login page. Do the
opposite for anonumous user - don't allow them to visit the MyAccount page.
-}
setActivePageAccess : WebData User -> Page -> Page
setActivePageAccess user page =
    case user of
        Success _ ->
            if page == Login then
                AccessDenied
            else
                page

        _ ->
            if page == MyAccount then
                AccessDenied
            else
                page
