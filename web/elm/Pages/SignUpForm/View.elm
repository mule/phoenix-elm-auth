module Pages.SignUpForm.View exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.LayoutTemplates.Master as Master
import App.Update exposing (Model)
import App.Common exposing (Msg(..))


view : Model -> Html Msg

view model  =
    Master.view [] [ signUpForm model ] []

signUpForm : Model -> Html Msg 

signUpForm model = 
    div [ class "input-field" ] 
        [
            input [ id "email", type' "email", class "validate" ] [],
            label [ for "email"] [ text "Email" ]
        ]