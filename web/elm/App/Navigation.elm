module App.Navigation exposing (..)

type Page
    = Login
    | SignUp
    | Landing
    | PageNotFound

type Msg =
    SetActivePage Page