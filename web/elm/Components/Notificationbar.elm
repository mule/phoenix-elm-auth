module Components.Notificationbar exposing (..)
import App.Notifications exposing (..)
import App.Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaLabel, ariaHidden)
import Html.Events exposing (onClick)
import Array exposing (..)

view : Array Notification -> Html Msg

view  model =
    model 
    |> Array.toIndexedList 
    |> List.filter (\pair -> snd pair |> isNotDismissed)
    |> List.map (uncurry notificationItem) 
    |> div [ class "row" ]

notificationItem : Int -> Notification -> Html Msg
notificationItem index notification =
    let classes = 
        case notification.level of
            Error ->
                class "alert alert-danger alert-dismissible"
            Warning ->
                class "alert alert-warning alert-dismissible"
            Info ->
                class "alert alert-info alert-dismissible"
            Success ->
                class "alert alert-info alert-success"
        clickAction =
            DismissNotification index |> onClick

    in
        div [ classes ] 
        [ 
            button [ type' "button", class "close", ariaLabel "Close", clickAction ] [ text "x" ],
            text notification.content
        ]
    
    
isNotDismissed : Notification -> Bool
isNotDismissed notification = not notification.dismissed

