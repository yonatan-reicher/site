module Projects exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)
import Common exposing (myStylesheet)


type alias Flags = ()


type alias Model = ()


type alias Msg = ()


init : Flags -> ( Model, Cmd Msg )
init () =
    ( ()
    , Cmd.none
    )


update msg model = ( model, Cmd.none )


type alias Project =
    { title: String
    , description: List (Html Msg)
    , date: String
    , githubLink: Maybe String
    , picturePath: Maybe String
    }


viewProjectLink : Project -> Html Msg
viewProjectLink p =
    case p.githubLink of
        Nothing -> text ""
        Just l -> a [ href l ] [ text "GitHub" ]


viewProjectPicture : Project -> Html Msg
viewProjectPicture p =
    case p.picturePath of
        Nothing -> text ""
        Just path ->
            a
                [ href path ]
                [ img
                    [ src path
                    , style "width" "100%"
                    ]
                    []
                ]


viewProject : Project -> Html Msg
viewProject proj =
    div 
        [ class "project"
        ]
        [ div
            [ style "display" "inline-block"
            , style "width" "70%"
            , style "vertical-align" "top"
            ]
            [ h3 [ style "margin-top" "0" ] [ text proj.title ]
            , span
                [ style "display" "flex"
                , style "flex-direction" "row"
                , style "gap" "10px"
                ]
                [ span [] [ text proj.date ]
                , viewProjectLink proj
                ]
            , p [] proj.description
            ]
        , div
            [ style "display" "inline-block"
            , style "width" "30%"
            ]
            [ viewProjectPicture proj
            ]
        ]


satellai : Project
satellai =
    { title = "SatellAI Project"
    , description = [ text """
        SatellAI is the name of a team I was briefly appended to for a summer
        project. The project was about using classical machine learning
        techniques on time-series data. Unfortunately I cannot say more.
    """ ]
    , date = "2024"
    , githubLink = Nothing
    , picturePath = Nothing
    }


tekclinic : Project
tekclinic =
    { title = "TekClinic"
    , description = [ text """
        A final-year group project full stack application.
    """ ]
    , date = "2024-2025"
    , githubLink = Just "https://www.github.com/tekclinic"
    , picturePath = Nothing
    }


affogato : Project
affogato =
    { title = "Affogato"
    , description = [ text """
        A machine learning library for python, made with my friend """, a [ href
        "https://github.com/galord123" ] [ text "Gal" ], text """.
        It implements FC layers, Convolution layers, various activation
        functions, SGD, Adam, Softmax, custom training loops and more.
        Everything is modular
    """ ]
    , date = "2021-2022"
    , githubLink = Just "https://gitlab.com/affogato/affogato"
    , picturePath = Just "images/affogato.png"
    }


waveFunctionCollapse : Project
waveFunctionCollapse =
    { title = "Wave Function Collapse"
    , description = [ text """
        Demo implementation of the Wave Function Collapse algorithm to generate
        interesting looking procedural environments. The demo shows off a cute
        townscape.
        Made in C# with MonoGame.
    """ ]
    , date = "2023"
    , githubLink = Just "https://github.com/yonatan-reicher/wave-function-collapse/"
    , picturePath = Just "images/wave-function-collapse.png"
    }


grRedesign : Project
grRedesign =
    { title = "GR++ Redesign"
    , description =
        [ text """
            A redesign of the website of the Technion's Computer Science
            faculty. Made in about a weekend, but got improved over time.
            (Works on both
        """
        , a 
            [ href "https://chrome.google.com/webstore/detail/gr%20%20-redesign/iaagdkjkkpiiollookginpcjapbhjfli" ]
            [ text "Chrome" ]
        , text " and "
        , a 
            [ href "https://addons.mozilla.org/en-US/firefox/addon/gr-redesign/" ]
            [ text "Firefox" ]
        , text ")."
        ]
    , date = "2023"
    , githubLink = Just "https://github.com/yonatan-reicher/gr-redesign"
    , picturePath = Just "images/grpp.jpg"
    }


ab : Project
ab =
    { title = "Compiler"
    , description = [ text """
        A compiler for a C-style language. Makes runnable x86 assembly source
        code to be used with TASM.
    """ ]
    , githubLink = Just "https://github.com/yonatan-reicher/AB"
    , picturePath = Just "images/ab.png"
    , date = "2019"
    }


blobs : Project
blobs =
    { title = "Blobs"
    , description =
        [ text """
            A 2D simulation of blob creatures. They move, they fight and eat
            each other, and they have color-based sight.
        """
        , ul []
            [ li [] [ text "Implemented in Rust using RayLib" ]
            , li [] [ text """
                Collision detection implemented by me using sweep and prune.
            """ ]
            ]
        ]
    , date = "2021"
    , githubLink = Just "https://github.com/yonatan-reicher/blobs"
    , picturePath = Just "images/blobs.jpg"
    }


viewContent : Html Msg
viewContent =
    div
        [ style "max-width" "1000px"
        , style "margin" "0 auto"
        ]
        [ h1 [] [ text "Projects" ]
        , viewProject satellai
        , viewProject tekclinic
        , viewProject affogato
        , viewProject waveFunctionCollapse
        , viewProject grRedesign
        , viewProject ab
        , viewProject blobs
        ]


view : Model -> Document Msg
view () =
    { title = "Jonathan Reicher | Projects"
    , body =
        [ myStylesheet
        , viewContent
        ]
    }


subscriptions model = Sub.none


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
