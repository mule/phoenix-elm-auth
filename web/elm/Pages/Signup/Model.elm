module Pages.SignUp.Model exposing (..)

type alias Model =
    { email : String
    , emailValid : Bool
    , emailValidationPending : Bool }

-- type Msg
--     = FetchProfileFail Http.Error
--     | FetchProfileSucceed User
--     | SetEmail String
--     | TrySignup


init :  Model
init =
    { email = ""
    , emailValid = False
    , emailValidationPending = False }
