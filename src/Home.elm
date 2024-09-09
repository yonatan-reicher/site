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
    { title = "Yonatan Reicher 🎓"
    , body =
        [ navbar
            { direction = Navbar.Vertical 
            -- TODO: Change to mainContent
            , onTopOf = mainContent
            }
        ]
    }


mainContent : Html Msg
mainContent =
    div [ class "dashboard" ]
        [ h1 [] [ text "Yonatan Reicher" ]
        , img [ class "me-img", src "images/me.png" ] []
        , p [] [ text """
            Hello! I'm Yonatan Reicher, and this is my site. I make compilers,
            software and sometimes art.
            """ ]
        , viewDashboard dashboard
        , span
            [ style "position" "fixed"
            , style "bottom" "10"
            , style "max-width" "inherit"
            ]
            [ text """
                Please notice this site is old. Most projects and information
                listed here are not up to date.
                """
            ]
        ]
                    


dashboard : List (Html Msg)
dashboard =
    let bold = span [ style "font-weight" "bold" ] in
    [ span []
        [ bold [ text "Most" ]
        , text " of my code is on "
        , a [ href "https://www.github.com/yonatan-reicher", target "_blank" ]
            [ text "github" ]
        , text "."
        ]
    , span []
        [ bold [ text "Sometimes" ]
        , text " I upload art to "
        , a [ href "https://twitter.com/batman_office", target "_blank" ]
            [ text "twitter" ]
        , text "."
        ]
    , span []
        [ bold [ text "Contact" ]
        , text " me at "
        , address [ style "display" "inline" ] [ text "yony252525@gmail.com" ]
        , text "."
        ]
    ]


viewDashboard : List (Html Msg) -> Html Msg
viewDashboard items =
    ul [] (List.map (li [] << List.singleton) items)


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none

