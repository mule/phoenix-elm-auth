module Pages.SignUp.View exposing (view)
import Components.AuthOptionsCard as AuthOptionsCard
import Pages.SignUp.Model exposing (..)
--import App.Update exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
--import App.Common exposing (Msg(..), Page(..))
import Pages.SignUp.Update exposing (Msg(..)) 
import LayoutTemplates.Master as Layout

view : Model -> Html Msg

view model  =
    
    Layout.view [] [ signUpForm model ] []

signUpForm : Model -> Html Msg 

signUpForm model = 
    let authProviders =
            [ "Google", "Github" ]

        formGroup content = 
            fieldset [ class "form-group" ] content

        displayNameField =
            formGroup
                [ 
                    label [ for "display-name" ] [ text "Display Name" ],
                    input [type' "text", id "display-name", class "form-control", placeholder "JL. Picard", value model.displayName, onInput SetDisplayName ] []
                ]
    
        emailField =
            formGroup
                [ 
                    label [ for "email" ] [ text "Email" ],
                    input [type' "email", id "email", class "form-control", placeholder "Enter email", value model.email, onInput SetEmail ] [],
                    small [ class "text-muted" ] [ text "We shall never share your email with anyone else" ]
                ]

        passwordField =
            formGroup 
                [ 
                    label [ for "password" ] [ text "Password" ],
                    input [type' "password", id "password", class "form-control", placeholder "Enter password" ] []
                ]

        confirmPasswordField =
            formGroup 
                [ 
                    input [type' "password", id "passwordConfirm", class "form-control", placeholder "Confirm password" ] []
                ]

        registerButton = 
            button [ type' "submit", class "btn btn-primary" ] [ text "Register" ]

        providerButtonRow = 
            formGroup  <| authProviderButtons authProviders

        header = 
            h5 [] [ text "Sign in with" ]

        dividerHeader = h5 [] [ text "or" ]
    in
        Html.form [ class "m-t-1" ] [ header, providerButtonRow, dividerHeader, displayNameField, emailField, passwordField, confirmPasswordField, registerButton ]

authProviderButtons : List String ->  List (Html Msg)

authProviderButtons providers =

    let authProviderBtn content =
        a [ class "btn btn-primary m-r-1" ] [ text content ]
    in
        List.map (\provider -> ( authProviderBtn provider )) providers 
    