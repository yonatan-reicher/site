module Home exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)
import Links exposing (myGithub, myInstagram, myMastodon, myBlog)
import Common exposing (myStylesheet)


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


openInNewTab : Attribute msg
openInNewTab =
    target "_blank"


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
        , a [ href myBlog ]
            [ text "here" ]
        , text "."
        ]
    , span
        []
        [ bold [ text "Check" ]
        , text " out some "
        , a [ href "/projects.html" ] [ text "projects" ]
        , text " I did."
        ]
    , span []
        [ bold [ text "Talk" ]
        , text " to me on "
        , a [ href myInstagram, openInNewTab ] [ text "instagram" ]
        , text "."
        ]
    , span []
        [ bold [ text "How" ]
        , text " do I use  "
        , a [ href myMastodon, openInNewTab ] [ text "mastodon" ]
        , text "."
        ]
    , span []
        [ bold [ text "Contact" ]
        , text " me at "
        , address [ style "display" "inline" ] [ text "yony252525@gmail.com" ]
        , text "." 
        ]
    ]


myBullets : Html Msg
myBullets =
    ul [] (List.map (li [] << List.singleton) items)


textColumn : Html Msg
textColumn =
    div
        [ style "display" "inline-block"
        , style "width" "500px"
        , style "box-sizing" "border-box"
        , style "padding-top" "70px"
        ]
        [ p [] [ text """
            Hello! I'm Jonathan Reicher, or maybe Yonatan Reicher, and this is
            my site. I make compilers, software and sometimes art.
            """ ]
        , myBullets
        , p [] [ text """
            Currently I currently working under Shachar Itzaki at The Technion
            for my MSc in Computer Science on Lean 4 and the humans that use it.
            """ ]
        -- , h2 [] [ text "teaching" ]
        -- , p []
        --     [ text "I am TA-ing "
        --     , em [] [ text "Selected Topics In Formal Proofs " ]
        --     , text "under Yuval Filmus. "
        --     , text "I have previously TA-ed "
        --     , em [] [ text "Programming Languages " ]
        --     , text "and had the pleasure of sharing my excitement for ML and "
        --     , text "the displeasure of helping students understand SML/NJ "
        --     , text "error messages."
        --     ]
        -- , p [] [ text """
        --     In the past I have also taught an advanced software engineering
        --     class for high-schoolers at Ort Guttman School for a year, and have mentored
        --     first-year students in C-programming at a high-school program called
        --     Magshimim.
        --     """ ]
        ]


picture =
    img
        [ src "images/me.png"
        , style "width" "100%"
        ] []


coolColumn : Html Msg
coolColumn =
    div
        [ style "display" "inline-block"
        , style "width" "50%"
        , style "vertical-align" "top"
        ]
        [ div
            [ style "margin" "0 100px"
            ]
            [ h1
                [ style "text-wrap" "nowrap"
                ]
                [ text "Jonathan Reicher"
                ]
            , picture
            ]
        ]


mainContent : Html Msg
mainContent =
    div
        [ style "width" "1000px"
        , style "max-width" "100%"
        , style "margin" "0 auto"
        ]
        [ textColumn
        , coolColumn -- picture and name
        ]


view : Model -> Document Msg
view () =
    { title = "Jonathan Reicher λ"
    , body =
        [ myStylesheet
        , mainContent
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none


main = Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
