module Pages.SignUp.Model exposing (..)

type alias Model =
    { displayName : String
    , email : String
    , emailValid : Bool
    , emailValidationPending : Bool
    , registrationPending : Bool }

-- type Msg
--     = FetchProfileFail Http.Error
--     | FetchProfileSucceed User
--     | SetEmail String
--     | TrySignup


emptyModel :  Model
emptyModel =
    { displayName = ""
    , email = ""
    , emailValid = False
    , emailValidationPending = False
    , registrationPending = False }
