module Pages.SignUp.View exposing (view)
import Components.AuthOptionsCard as AuthOptionsCard
import Pages.SignUp.Model exposing (..)
--import App.Update exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import App.Common exposing (Msg(..), Page(..))
import LayoutTemplates.Master as Layout

view : Model -> Html App.Common.Msg

view model  =
    Layout.view [] [ signUpForm model ] []

signUpForm : Model -> Html Msg 

signUpForm model = 
    let emailField =
            fieldset [ class "form-group" ] 
            [ 
                label [ for "email" ] [ text "Email" ],
                input [type' "email", id "email", class "form-control", placeholder "Enter email" ] [],
                small [ class "text-muted" ] [ text "We shall never share your email with anyone else" ]
            ]

        passwordField =
            fieldset [ class "form-group" ] 
            [ 
                label [ for "password" ] [ text "Password" ],
                input [type' "password", id "password", class "form-control", placeholder "Enter password" ] []
            ]

        confirmPasswordField =
            fieldset [ class "form-group" ] 
            [ 
                input [type' "password", id "passwordConfirm", class "form-control", placeholder "Confirm password" ] []
            ]

        registerButton = 
            button [ type' "submit", class "btn btn-primary" ] [ text "Register" ]
    in
        Html.form [] [ emailField, passwordField, confirmPasswordField, registerButton ]