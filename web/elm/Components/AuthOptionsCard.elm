module Components.AuthOptionsCard exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

view : String -> List (String, Attribute msg) -> Html msg

view title providers =

    let listItem headingText content =
            li [ class "list-group-item" ] [ h5 [ class "text-xs-center m-b-1" ] [ text headingText ], content]

        formInput inputType labelText id'  =
            div [ class "form-group m-l-1" ] [ 
                label [ for id' ] [ text labelText ],
                input [ type' inputType, class "form-control m-l-1", id id'  ] []
            ]

        submitBtn = 
            button [ type' "submit", class "btn btn-primary m-l-1" ] [ text "Login" ]

        loginForm = 
            Html.form [ class "form-inline center-block" ] [ formInput "email" "Email" "email", formInput "password" "Password" "password", submitBtn ]
        
        in
            
            div [class "card m-t-1  "]
                [ div [ class "card-block" ]
                    [ span [ class "card-title" ] [ text title]
                    , ul [ class "list-group list-group-flush"]
                        <| List.append (providerItems providers) [ listItem "or"  loginForm ] 
                    ]
                ]

providerItems :  List (String, Attribute msg) -> List (Html msg)
providerItems items =
    List.map (\provider ->  (
        li [ class "list-group-item"]
            [
                a [ class "btn btn-primary btn-lg btn-block", snd provider ] [ text  <| fst provider ]
            ]
        )) items





