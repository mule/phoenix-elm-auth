module Pages.Login.View exposing (view)

import Exts.RemoteData exposing (RemoteData(..), WebData)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import User.Model exposing (..)
import Pages.Login.Model exposing (..)
import Pages.Login.Update exposing (..)


view : WebData User -> Model -> Html Msg
-- view user model =
--     let
--         spinner =
--             i [ class "notched circle loading icon" ] []
--
--         isLoading =
--             case user of
--                 Loading ->
--                     True
--
--                 _ ->
--                     False
--     in
--         Html.form
--             [ onSubmit TryLogin
--             , action "javascript:void(0);"
--             , class "ui form"
--             ]
--             [ div [ class "field" ]
--                 [ label [] [ text "GitHub Name" ]
--                 , input
--                     [ type' "text"
--                     , placeholder "Name"
--                     , onInput SetName
--                     , value model.name
--                     ]
--                     []
--                 ]
--               -- Submit button
--             , button
--                 [ onClick TryLogin
--                 , disabled isLoading
--                 , class "ui primary button"
--                 ]
--                 [ span [ hidden <| not isLoading ] [ spinner ]
--                 , span [ hidden isLoading ] [ text "Login" ]
--                 ]
--             ]

view user model =

    div [ class "row" ]
            [ div [ class "col s4" ]
                [ loginOptionsCard model ]
        ]

loginOptionsCard : Model -> Html Msg

loginOptionsCard model =
    let loginOptions =
        [ "Google", "Github", "AuthKata"]
    in
        div [class "card"]
            [ div [ class "card-content" ]
                [ span [ class "card-title" ] [ text "Login with:"]
                , ul [ class "collection"]
                    (loginOptionItems loginOptions)
                ]
            ]

loginOptionItems : List String -> List (Html Msg)
loginOptionItems items =
    List.map (\provider ->  (
        li [ class "collection-item "]
            [
                a [href "#!", class "waves-effect waves-light btn"] [text provider]
            ]
        )) items
