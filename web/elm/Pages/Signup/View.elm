module Pages.SignUp.View exposing (view)
import Pages.Components.AuthOptionsCard as AuthOptionsCard
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import App.Common exposing (Msg(..), Page(..))

view : Html Msg


view  =
    let signupOptions =
        [
            ("Google", onClick <| SetActivePage PageNotFound), 
            ("Github", onClick <| SetActivePage PageNotFound), 
            ("AuthKata", onClick <|SetActivePage SignUpForm)
        ]
    in
        div [ class "row" ]
                [ div [ class "col s4" ]
                    [ AuthOptionsCard.view "Signup with:" signupOptions ]
                ]
