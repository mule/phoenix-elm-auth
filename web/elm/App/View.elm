module App.View exposing (..)

import Exts.RemoteData exposing (RemoteData(..), WebData)
import Html exposing (..)
import Html.Attributes exposing (id, class, classList, href, src, style, target)
import Html.App as Html
import Html.Events exposing (onClick)
import App.Update exposing(Model)
import User.Model exposing (..)
import Pages.Login.View exposing (..)
import Pages.PageNotFound.View exposing (..)
import Pages.SignUp.View exposing (..)
import Pages.SignUpForm.View exposing (..)
import Pages.LandingPage.View exposing(..)
import Components.Notificationbar exposing (..)
import App.Common exposing (Msg(..), Page(..))
import Pages.SignUp.Update as SignUp
import Pages.Login.Update as Login

import Components.Navbar as Navbar
import Components.Notificationbar as Notificationbar
import Debug

view : App.Update.Model -> Html Msg

view model =
        div []
            [
                (Navbar.view model),
                div [class "container"]
                [
                    Notificationbar.view model.notifications, 
                    viewMainContent model
                ]
            ]

signUpTranslator : SignUp.Translator App.Common.Msg 
signUpTranslator =
    SignUp.translator { onInternalMessage = PageSignUp, 
                        onUserRegistered = UserRegistered,
                        onNotify = NotificationsReceived
                          } 

loginTranslator : Login.Translator App.Common.Msg
loginTranslator =
    Login.translator { onInternalMessage = PageLogin,
                        onUserLoggedIn = UserLoggedIn,
                        onNotify = NotificationsReceived }


viewHeader model =
    let buttonClasses =
        "waves-effect waves-light btn-large"
    in
        nav [ ]
            [ div [class "nav-wrapper" ]
                [ a [ id "logo", href "#!", class "brand-logo"] [ text "Elm AuthKata" ]
                , ul [class "right" ]
                    [ li [ class buttonClasses, onClick <| SetActivePage SignUp ] [ text "Sign up" ]
                    , li [ class buttonClasses, onClick <| SetActivePage Login ] [ text "Login" ]
                    ]
                ]
            ]



viewPageNotFoundItem : Page -> Html Msg
viewPageNotFoundItem activePage =
    a
        [ classByPage PageNotFound activePage
        , onClick <| SetActivePage PageNotFound
        ]
        [ text "404 page" ]

viewMainContent : Model -> Html Msg

viewMainContent model =
    case Debug.log "view" model.activePage of

        Login ->
            Html.map loginTranslator (Pages.Login.View.view model.pageLogin)

        SignUp ->
            Html.map signUpTranslator (Pages.SignUp.View.view model.pageSignUp)

        Landing ->
            Pages.LandingPage.View.view model.pageLanding

        PageNotFound ->
            -- We don't need to pass any cmds, so we can call the view directly
            Pages.PageNotFound.View.view model



{-| Get menu items classes. This function gets the active page and checks if
it is indeed the page used.
-}
classByPage : Page -> Page -> Attribute a
classByPage page activePage =
    classList
        [ ( "item", True )
        , ( "active", page == activePage )
        ]
