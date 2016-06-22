module Pages.LayoutTemplates.Master exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
view : List (Html a) -> List (Html a)  -> List (Html a) -> Html a  

view left center right =
     div [ class "row" ]
                [ div [ class "col s2" ] left
                , div [ class "col s8" ] center
                , div [ class "col s2" ] right
                ]


