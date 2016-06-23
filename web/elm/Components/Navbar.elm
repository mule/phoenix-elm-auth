module Components.Navbar exposing (..)
import Html exposing (..)
import Html.Attributes exposing (id, class, classList, href, src, style, target)
import App.Common exposing (..)
import App.Update exposing (Model)

view : Model -> Html Msg

view model =
    let btnClasses = 
        "btn btn-primary active m-l-1"

        brand = 
            a [ class "navbar-brand"  ] [ text "AuthKata" ]

        navbarButtons = form [ class "form-inline pull-xs-right" ] 
                        [ a [ href "#signup", class btnClasses ] [ text "Signup" ]
                        , a [ href "#login", class btnClasses ] [ text "Login" ]
                        ]
        
    in
        nav [ class "navbar navbar-light bg-faded" ] 
            [
                brand,
                navbarButtons   
            ]


