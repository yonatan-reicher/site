module Home exposing (Flags, Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)
import Navbar exposing (navbar)


type alias Flags = ()


type alias Model = ()


type alias Msg = ()


init : Flags -> (Model, Cmd Msg)
init () =
    ( ()
    , Cmd.none
    )


update : Msg -> Model -> (Model, Cmd Msg)
update () () =
    ( ()
    , Cmd.none
    )


view : Model -> Document Msg
view () =
    { title = "Yonatan Reicher"
    , body =
        [ navbar { direction = Navbar.Horizontal }
        , viewDashboard dashboard
        ]
    }


dashboard : List (Html Msg)
dashboard =
    [ a [ href "https://www.github.com/yonatan-reicher", target "_blank" ]
        [ text "Code" ]
    , a [ href "#/projects", target "_blank" ]
        [ text "Projects" ]
    , span []
        [ a [ href "#/blog", target "_blank" ]
            [ text "Blog" ]
        , text " (Embarassing!)"
        ]
    , a [ href "https://twitter.com/batman_office", target "_blank" ]
        [ text "Art twitter" ]
    , address [] [ text "email: yony252525@gmail.com" ]
    ]


viewDashboard : List (Html Msg) -> Html Msg
viewDashboard items =
    div [ class "dashboard" ]
        [ h1
            [
            ]
            [ text "Yonatan Reicher"
            ]
        , ul [] (List.map (li [] << List.singleton) items)
        ]


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none

