module Pages.PageNotFound.View exposing (view)

import Html exposing (a, div, h2, text, Html)
import Html.Attributes exposing (class, href)
import App.Common exposing (Msg(..), Page(..))
import App.Update exposing (Model)


-- VIEW


view : Model -> Html App.Common.Msg
view model =
    div [ class "ui segment center aligned" ]
        [ h2 [] [ text "This is a 404 page!" ]
        ]
