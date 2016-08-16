module Pages.Login.Model exposing (emptyModel, Model)


type alias Model =
    { email: String
    , password: String
    }


emptyModel : Model
emptyModel =
    { email = ""
    , password = ""
    }
