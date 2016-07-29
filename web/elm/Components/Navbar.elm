module Components.Navbar exposing (..)
import Html exposing (..)
import Html.Attributes exposing (id, class, classList, href, src, style, target)
import Html.Events exposing (onClick)
import App.Common exposing (..)
import App.Update exposing (Model)
import String
import User.Model exposing (User)


view : Model -> Html Msg
view model =
    let btnClasses = 
        "btn btn-primary active m-l-1"

        brand = 
            a [ class "navbar-brand"  ] [ text "AuthKata" ]

    in
        nav [ class "navbar navbar-light bg-faded" ] 
            [
                brand,
                navbarButtons model,
                userData model.user
            ]

navbarButtons : Model -> Html Msg
navbarButtons model =
    let btnClasses = 
        "btn btn-primary active m-l-1"

        buttonFormContent =
            case model.user.authenticated of 
                False ->
                        [ a [ href "#signup", class btnClasses ] [ text "Signup" ]
                        , a [ href "#login", class btnClasses ] [ text "Login" ]
                        ]
                True ->
                    [  button [ class btnClasses, onClick Logout ] [ text "Logout" ]]
        
    in
        form [ class "form-inline pull-xs-right" ] buttonFormContent

userData : User -> Html Msg
userData user =
    case user.authenticated of
        True ->
            span [ class "navbar-text pull-xs-right m-l-1" ] [ text <| String.join " " [ "Signed in as", user.name ] ]
        False ->
            span [] []



