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
        , p [] [ text """
            Currently I currently working under Shachar Itzaki at The Technion
            for my MSc in Computer Science on Lean 4 and the humans that use it.
            """ ]
        , h2 [] [ text "teaching" ]
        , p []
            [ text "I am TA-ing "
            , em [] [ text "Selected Topics In Formal Proofs " ]
            , text "under Yuval Filmus. "
            , text "I have previously TA-ed "
            , em [] [ text "Programming Languages " ]
            , text "and had the pleasure of sharing my excitement for ML and "
            , text "the displeasure of helping students understand SML/NJ "
            , text "error messages."
            ]
        , p [] [ text """
            In the past I have also taught an advanced software engineering
            class for high-schoolers at Ort Guttman School for a year, and have mentored
            first-year students in C-programming at a high-school program called
            Magshimim.
            """ ]
        , bottomDisclaimer
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


bottomDisclaimer : Html Msg
bottomDisclaimer =
    let fixed = False in
    span
        ( if fixed then
            [ style "position" "fixed"
            , style "bottom" "10"
            , style "max-width" "inherit"
            ]
          else []
        )
        [ text """
            This site is old.
            Most things here are not up to date.
            """
        ]


openInNewTab : Attribute msg
openInNewTab =
    target "_blank"


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none

