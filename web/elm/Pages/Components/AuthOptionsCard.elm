module Pages.Components.AuthOptionsCard exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

view : String -> List (String, Attribute msg) -> Html msg

view title providers =
            div [class "card"]
                [ div [ class "card-content" ]
                    [ span [ class "card-title" ] [ text title]
                    , ul [ class "collection"]
                        (providerItems providers)
                    ]
                ]

providerItems :  List (String, Attribute msg) -> List (Html msg)
providerItems items =
    List.map (\provider ->  (
        li [ class "collection-item "]
            [
                a [href "#!", class "waves-effect waves-light btn", snd provider ] [ text  <| fst provider ]
            ]
        )) items
