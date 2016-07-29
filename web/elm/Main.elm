module Main exposing (..) 
import App.Router exposing (..)
import App.Update exposing (init, update, Model, Flags)
import App.View exposing (view)
import App.Common exposing (Msg(..))
import Html.App as Html
import RouteUrl
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Debug

main : Program Flags
main =
    let test =
        Debug.log "Starting authkata"
    in
        RouteUrl.programWithFlags
            { delta2url = delta2url
            , location2messages = location2messages
            , init = App.Update.init
            , update = App.Update.update
            , view = App.View.view
            , subscriptions = subscriptions
            }



-- SUBSCRIPTIONS


--subscriptions : Model -> Sub Msg
--subscriptions model =
 --   Sub.none

subscriptions : Model -> Sub Msg
subscriptions model =
   Phoenix.Socket.listen model.phxSocket PhoenixMsg
