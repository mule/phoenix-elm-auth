module Pages.SignUp.Model exposing (Model)

type alias Model =
    { email : String }

-- type Msg
--     = FetchProfileFail Http.Error
--     | FetchProfileSucceed User
--     | SetEmail String
--     | TrySignup


init :  Model
init =
    { email = "" }
