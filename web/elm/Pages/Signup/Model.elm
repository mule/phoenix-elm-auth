module Pages.SignUp.Model exposing (Model)

type alias Model =
    { email : String }

type Msg
    = FetchProfileFail Http.Error
    | FetchProfileSucceed User
    | SetEmail String
    | TrySignup


init : ( Model, Cmd Msg )
init =
    emptyModel ! []
