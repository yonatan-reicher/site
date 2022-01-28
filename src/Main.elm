module Main exposing (..)

import Html exposing (..)
import Browser


type alias Flags = ()


type Model = Model


type Msg = Msg


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Flags -> (Model, Cmd Msg)
init () = (Model, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update Msg model = (model, Cmd.none)


view : Model -> Browser.Document Msg
view model =
    { title = "Hello World"
    , body = []
    }


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

