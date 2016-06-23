module Pages.MyAccount.View exposing (view)

import Exts.RemoteData exposing (RemoteData(..), WebData)

import Html exposing (a, div, h2, i, p, text, Html)
import Html.Attributes exposing (class, href)
import App.Common exposing (Msg(..), Page(..))
import User.Model exposing (..)
import App.Update exposing (Model)


-- VIEW


view : Model -> Html App.Common.Msg
view model =
    let
        name =
            case model.user of
                Success user' ->
                    user'.name

                _ ->
                    ""
    in
        div [ class "ui icon message" ]
            [ i [ class "user icon" ]
                []
            , div [ class "content" ]
                [ text <| "Welcome " ++ name
                , p [] [ text "This is an account page" ]
                ]
            ]
