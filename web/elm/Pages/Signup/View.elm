module Pages.SignUp.View exposing (view)
import Pages.Components.AuthOptionsCard as AuthOptionsCard
import Html exposing (..)
import Html.Attributes exposing (..)

view : Html a


view  =
    let signupOptions =
        [ "Google", "Github", "AuthKata"]
    in
        div [ class "row" ]
                [ div [ class "col s4" ]
                    [ AuthOptionsCard.view "Signup with:" signupOptions ]
                ]
