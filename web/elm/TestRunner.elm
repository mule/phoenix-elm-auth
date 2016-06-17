module Main exposing (..)

import ElmTest exposing (..)
import App.Test as AppTest exposing (..)
import Pages.Login.Test as PagesLogin exposing (..)


allTests : Test
allTests =
    suite "All tests"
        [
          AppTest.all
        , PagesLogin.all
        ]


main : Program Never
main =
    runSuiteHtml allTests
