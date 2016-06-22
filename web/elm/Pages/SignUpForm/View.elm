module Pages.SignUpForm.View exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.LayoutTemplates.Master as Master

view : Html a

view =
    Master.view [] [signUpForm] []

signUpForm : Html a 

signUpForm = 
    div [] [text "signup form"]