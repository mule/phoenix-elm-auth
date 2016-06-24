module App.Router exposing (delta2url, location2messages)

import App.Update exposing (..)
import App.Common exposing (Msg(..), Page(..))
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import Debug


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case Debug.log "delta2url" current.activePage of

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
    case Debug.log "location2messages" location.hash of
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
