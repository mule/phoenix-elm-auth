module App.Notifications exposing (Notification, NotificationLevel, NotificationLevel(..), createNotifications)
import Array exposing (..)
import HttpBuilder

type  NotificationLevel = Error | Warning | Info | Success
type alias Notification = { level : NotificationLevel, content : String, dismissed : Bool }

createNotifications : HttpBuilder.Error (Bool, Array String) -> Array Notification
createNotifications error =
        case error of 
            HttpBuilder.UnexpectedPayload error ->
                Array.fromList [Notification Error error False]
            HttpBuilder.BadResponse response ->
                snd response.data |> Array.map (\error -> Notification Error error False)
            _ ->
                let notificationMsg = 
                    "No connection or server not available"
                in
                    Array.fromList [Notification Error notificationMsg False]
