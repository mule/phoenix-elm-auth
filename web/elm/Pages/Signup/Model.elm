module Pages.SignUp.Model exposing (..)

type alias Model =
    { displayName : String
    , displayNameValid : Bool
    , displayNameErrors : List String
    , email : String
    , emailValid : Bool
    , emailErrors : List String
    , password : String
    , passwordConfirmation : String
    , passwordValid : Bool
    , passwordErrors : List String
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
