module User.Model exposing (..)

type alias User =
    { avatarUrl : Maybe String
    , name : Maybe String
    , id : Maybe Int
    , authenticated : Bool 
    }


emptyModel : User 
emptyModel = 
    { avatarUrl = Nothing
    , name = Nothing
    , id = Nothing
    , authenticated = False
    }