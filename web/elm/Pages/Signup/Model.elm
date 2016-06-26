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


emptyModel :  Model
emptyModel =
    { email = ""
    , emailValid = False
    , emailValidationPending = False }
