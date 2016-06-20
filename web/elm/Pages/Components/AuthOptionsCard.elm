module Pages.Components.AuthOptionsCard exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)

view : String -> List String -> Html a

view title providers =
            div [class "card"]
                [ div [ class "card-content" ]
                    [ span [ class "card-title" ] [ text title]
                    , ul [ class "collection"]
                        (providerItems providers)
                    ]
                ]

providerItems : List String -> List (Html a)
providerItems items =
    List.map (\provider ->  (
        li [ class "collection-item "]
            [
                a [href "#!", class "waves-effect waves-light btn"] [text provider]
            ]
        )) items
