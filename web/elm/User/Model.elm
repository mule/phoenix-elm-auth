module User.Model exposing (..)

type alias User =
    { avatarUrl : String
    , name : String
    , id : String
    , authenticated : Bool 
    }


emptyModel : User 
emptyModel = 
    { avatarUrl = ""
    , name = ""
    , id = ""
    , authenticated = False
    }