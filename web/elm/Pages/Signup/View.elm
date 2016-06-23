module Pages.SignUp.View exposing (view)
import Pages.Components.AuthOptionsCard as AuthOptionsCard
--import Pages.SignUp.Model exposing (..)
import App.Update exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import App.Common exposing (Msg(..), Page(..))

view : Model -> Html App.Common.Msg


view model =
    let signupOptions =
        [
            ("Google", href "#!" ), 
            ("Github", href "#!" ), 
            ("AuthKata", href "#signupform" )
        ]
    in
        div [ class "row" ]
                [ div [ class "col s4" ]
                    [ AuthOptionsCard.view "Signup with:" signupOptions ]
                ]
