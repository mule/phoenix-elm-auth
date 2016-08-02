module Pages.LandingPage.View exposing (..)

import LayoutTemplates.Master as Layout
import Pages.LandingPage.Model exposing (..)
import Html exposing (..)
import App.Common exposing (..)

view : Model -> Html App.Common.Msg
view model =
    let content =
        div [] [ text "Welcome to authkata landing page" ]
    in
        Layout.view [] [content] [] 
