module App.Router exposing (delta2url, location2messages)

import App.Update exposing (..)
import App.Common exposing (Msg(..), Page(..))
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import Debug


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case Debug.log "delta2url" (current.activePage, current.user.authenticated) of
        (Login, True) ->
            Just <| UrlChange NewEntry "/#"
        (Login, False) ->
            Just <| UrlChange NewEntry "/#login"
        (SignUp, True) ->
            Just <| UrlChange NewEntry "/#"
        (SignUp, False) ->
            Just <| UrlChange NewEntry "/#signup"
        (Landing, _) ->
            Just <| UrlChange NewEntry "/#"
        (PageNotFound, _) ->
            Just <| UrlChange NewEntry "/#404"


location2messages : Location -> List Msg
location2messages location =
    case Debug.log "location2messages" location.hash of
        "" ->
            []
        "#login" ->
            [ SetActivePage Login ]

        "#signup" ->
            [ SetActivePage SignUp ]
            
        "#404" ->
            [ SetActivePage PageNotFound ]

        "#" ->
            [SetActivePage Landing]
        _ ->
            [ SetActivePage PageNotFound ]
