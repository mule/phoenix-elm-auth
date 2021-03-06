module Pages.Login.View exposing (view)

import Exts.RemoteData exposing (RemoteData(..), WebData)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import User.Model exposing (..)
--import Pages.Login.Model exposing (..)
--import Pages.Login.Update exposing (..)
import Components.AuthOptionsCard as AuthOptionsCard
import Pages.Login.Model exposing (..)
import Pages.Login.Update exposing ( Msg(..), InternalMsg(..) )

import LayoutTemplates.Master as Master

view :  Model -> Html Msg
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

view model =
    let loginOptions =
        [
            ("Google", href "/auth/google"), 
            ("Github", href "/auth/github")
            
        ]

        marginCol =
            []
            
        content = 
            [ AuthOptionsCard.view "Login with:" loginOptions ]
         
    in
        Master.view marginCol content marginCol


