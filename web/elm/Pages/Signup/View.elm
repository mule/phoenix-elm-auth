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
import String

view : Model -> Html Msg

view model  =
    
    Layout.view [] [ signUpForm model ] []

signUpForm : Model -> Html Msg 

signUpForm model = 
    let authProviders =
            [ "Google", "Github" ]

        formGroup additionalClasses content = 
            let defaultClasses = 
                    [ ("form-group", True)]
                classes = 
                    List.append defaultClasses additionalClasses
            in
                fieldset [ classList classes ] content

        displayNameField =
            let errors =
                List.filterMap identity model.displayNameErrors
                isValid =
                    List.isEmpty errors

                groupClasses = 
                    [
                        ("has-success", String.length model.displayName > 0 && isValid),
                        ("has-warning", not isValid)
                    ]
            in
                formGroup groupClasses
                    [ 
                        label [ for "display-name" ] [ text "Display Name" ],
                        small [ class "text-help m-l-1" ] [  String.join ", " errors |> text ],
                        input [type' "text", id "display-name", class "form-control", placeholder "JL. Picard", value model.displayName, onInput SetDisplayName ] []
                    ]
    
        emailField =
            let errors = 
                    List.filterMap identity model.emailErrors
                isValid = 
                    List.isEmpty errors

                groupClasses = 
                    [
                        ("has-success", String.length model.email > 0 && isValid),
                        ("has-warning", not isValid)
                    ]
                inputClasses = 
                    classList [
                        ("form-control", True)
                    ]
            in
                formGroup groupClasses
                    [ 
                        label [ for "email" ] [ text "Email" ],
                        small [ class "text-help m-l-1" ] [  String.join ", " errors |> text ],
                        input [type' "email", id "email", inputClasses, placeholder "Enter email", value model.email, onInput SetEmail ] [],
                        small [ class "text-muted" ] [ text "We shall never share your email with anyone else" ]
                    ]

        passwordField =
            let errors =
                List.filterMap identity model.passwordErrors
                isValid =
                    List.isEmpty errors

                groupClasses = 
                    [
                        ("has-success", String.length model.password > 0 && isValid),
                        ("has-warning", not isValid)
                    ]
            in
                formGroup groupClasses
                    [ 
                        label [ for "password" ] [ text "Password" ],
                        small [ class "text-help m-l-1" ] [  String.join ", " errors |> text ],
                        input [type' "password", id "password", class "form-control", placeholder "Enter password", value model.password, onInput SetPassword ] []
                    ]

        confirmPasswordField =
            formGroup []
                [ 
                    input [type' "password", id "passwordConfirm", class "form-control", placeholder "Confirm password", value model.passwordConfirmation, onInput SetPasswordConfirm ] []
                ]

        registerButton disabled =
            let classes = 
                classList [ ("btn", True),
                    ("btn-primary", True),
                    ("m-r-1", True),
                    ("disabled", disabled)
                ]
            in
                button [ classes, onClick Register ] [ text "Register" ]

        providerButtonRow model = 
            formGroup [] <| authProviderButtons model.registrationPending authProviders

        header = 
            h5 [] [ text "Sign up with" ]

        dividerHeader = h5 [] [ text "or" ]
    in
        Html.form [ class "m-t-1" ] [   
                                        header, 
                                        providerButtonRow model,
                                        dividerHeader,
                                        displayNameField,
                                        emailField, 
                                        passwordField, 
                                        confirmPasswordField, 
                                        registerButton ( model.registrationPending || not model.modelValid )
                                    ]

authProviderButtons : Bool ->  List String ->  List (Html Msg)

authProviderButtons disabled providers =

    let classes =
        classList [ ("btn", True),
                    ("btn-primary", True),
                    ("m-r-1", True),
                    ("disabled", disabled)
        ] 

        authProviderBtn content =
        a [ classes ] [ text content ]
    in
        List.map (\provider -> ( authProviderBtn provider )) providers 



