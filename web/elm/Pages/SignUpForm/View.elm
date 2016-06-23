module Pages.SignUpForm.View exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import LayoutTemplates.Master as Master
import App.Update exposing (Model)
import App.Common exposing (Msg(..))

view : Model -> Html Msg

view model  =
    Master.view [] [ signUpForm model ] []

signUpForm : Model -> Html Msg 

signUpForm model = 
    let emailField =
            fieldset [ class "form-group" ] 
            [ 
                label [ for "email" ] [ text "Email" ],
                input [type' "email", id "email", class "form-control", placeholder "Enter email" ] [],
                small [ class "text-muted" ] [ text "We shall never share your email with anyone else" ]
            ]
    in
        Html.form [] [ emailField ]
