module App.Router exposing (delta2url, location2messages)

import App.Update exposing (..)
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import Debug


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case Debug.log "action" current.activePage of
        AccessDenied ->
            Nothing

        Login ->
            Just <| UrlChange NewEntry "/#login"

        SignUp ->
            Just <| UrlChange NewEntry "/#signup"

        MyAccount ->
            Just <| UrlChange NewEntry "/#my-account"

        PageNotFound ->
            Just <| UrlChange NewEntry "/#404"


location2messages : Location -> List Msg
location2messages location =
    case Debug.log "action" location.hash of
        "" ->
            []

        "#login" ->
            [ SetActivePage Login ]

        "#signup" ->
            [ SetActivePage SignUp ]

        "#my-account" ->
            [ SetActivePage MyAccount ]

        "#404" ->
            [ SetActivePage PageNotFound ]

        _ ->
            [ SetActivePage PageNotFound ]
