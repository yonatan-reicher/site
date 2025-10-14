module Home exposing (Flags, Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)
import Links exposing (myGithub, myInstagram)


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
    { title = "Jonathan Reicher λ"
    , body = [ mainContent ]
    }


mainContent : Html Msg
mainContent =
    div [ class "home" ]
        [ h1 [] [ text "Jonathan Reicher" ]
        , img [ class "me-img", src "images/me.png" ] []
        , p [] [ text """
            Hello! I'm Jonathan Reicher, or maybe Yonatan Reicher, and this is
            my site. I make compilers, software and sometimes art.
            """ ]
        , myBullets
        , span
            [ style "position" "fixed"
            , style "bottom" "10"
            , style "max-width" "inherit"
            ]
            [ text """
                This site is old.
                Most things here are not up to date.
                """
            ]
        ]


myBullets : Html Msg
myBullets =
    ul [] (List.map (li [] << List.singleton) items)


items : List (Html Msg)
items =
    let bold = span [ style "font-weight" "bold" ] in
    [ span []
        [ bold [ text "Most" ]
        , text " of my code is on "
        , a [ href myGithub, openInNewTab ]
            [ text "github" ]
        , text "."
        ]
    , span []
        [ bold [ text "Sometimes" ]
        , text " I write and put it "
        , a [ href "#/blog" ]
            [ text "here" ]
        , text "."
        ]
    , span []
        [ bold [ text "Talk" ]
        , text " to me on instagram "
        , a [ href myInstagram, openInNewTab ] [ text "@yonatan.reicher" ]
        , text "."
        ]
    , span []
        [ bold [ text "Contact" ]
        , text " me at "
        , address [ style "display" "inline" ] [ text "yony252525@gmail.com" ]
        , text "." 
        ]
    ]


openInNewTab : Attribute msg
openInNewTab =
    target "_blank"


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none

