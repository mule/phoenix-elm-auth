module App.Notifications exposing (Notification, NotificationLevel, NotificationLevel(..))

type  NotificationLevel = Error | Warning | Info | Success
type alias Notification = { level : NotificationLevel, content : String, dismissed : Bool }