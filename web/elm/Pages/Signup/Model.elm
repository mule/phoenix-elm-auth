module Pages.SignUp.Model exposing (..)

type alias Model =
    { displayName : String
    , displayNameErrors : List String
    , email : String
    , emailErrors : List String
    , password : String
    , passwordConfirmation : String
    , passwordErrors : List String
    , modelValid : Bool
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
    , displayNameErrors = []
    , email = ""
    , emailErrors = []
    , password = ""
    , passwordConfirmation = ""
    , passwordErrors = []
    , modelValid = False
    , emailValidationPending = False
    , registrationPending = False }
