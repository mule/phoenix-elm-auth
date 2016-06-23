module LayoutTemplates.Master exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
view : List (Html a) -> List (Html a)  -> List (Html a) -> Html a  

view left center right =
     div [ class "row" ]
                [ div [ class "col-xs-1" ] left
                , div [ class "col-xs-10" ] center
                , div [ class "co-xs-1" ] right
                ]


