module Pages.SignUp.Model exposing (..)

type alias Model =
    { displayName : String
    , displayNameValid : String
    , displayNameError : String
    , email : String
    , emailValid : Bool
    , emailError : String
    , password : String
    , passwordConfirmation : String
    , passwordValid : bool
    , passwordError : String
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
    , displayNameValid = False,
    , displayNameError = ""
    , email = ""
    , emailValid = False
    , emailError = ""
    , password = ""
    , passwordConfirmation = ""
    , passwordValid = False
    , formValid = False
    , emailValidationPending = False
    , registrationPending = False }
