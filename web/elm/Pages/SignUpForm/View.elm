module Pages.SignUpForm.View exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.LayoutTemplates.Master as Master
import App.Common exposing (Msg(..), Page(..))
import App.Update exposing (Model)

view : Model ->  Html App.Common.Msg

view model =
    Master.view [] [signUpForm] []

signUpForm : Html a 

signUpForm = 
    div [] [text "signup form"]