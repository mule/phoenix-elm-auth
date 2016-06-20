module Main exposing (..) 
import App.Model exposing (Model)
import App.Router exposing (..)
import App.Update exposing (init, update, Msg)
import App.View exposing (view)
import Html.App as Html
import RouteUrl
import Debug

main : Program Never
main =
    let test =
        Debug.log "Starting authkata"
    in
        RouteUrl.program
            { delta2url = delta2url
            , location2messages = location2messages
            , init = App.Update.init
            , update = App.Update.update
            , view = App.View.view
            , subscriptions = subscriptions
            }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
