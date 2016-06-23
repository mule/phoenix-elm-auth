module Components.AuthOptionsCard exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

view : String -> List (String, Attribute msg) -> Html msg

view title providers =
            div [class "card"]
                [ div [ class "card-block" ]
                    [ span [ class "card-title" ] [ text title]
                    , ul [ class "ist-group list-group-flush"]
                        (providerItems providers)
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
