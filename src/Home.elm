module Home exposing (Flags, Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)


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
    { title = "Yonatan Reicher | Programing & Computer Science"
    , body =
        [ viewHeadings
        , viewProjects
        , viewAbout
        , viewContact
        ]
    }


viewHeadings : Html Msg
viewHeadings =
    div
        [ class "headings"
        ]
        [ h1
            [ class "title"
            ]
            [ text "Hello, I'm "
            , span [ class "name" ] [ text "Yonatan" ]
            , text "."
            , br [] []
            , text "And I'm a "
            , span
                [ class "highlight"
                ]
                [ text "software engineer"
                ]
            , text "."
            ]
        ]


viewProjects : Html Msg
viewProjects =
    div
        [ class "section"
        , class "projects"
        ]
        [ h2
            [ class "section-title"
            ]
            [ text "Projects"
            ]
        , ul
            [ class "projects-list"
            ]
            [ li
                [ class "project"
                ]
                [ a [ href "#/blog" ] [ text "Articles (work in progress!)" ]
                ]
            , li
                [ class "project"
                ]
                [ a
                    [ href "https://gitlab.com/affogato/affogato"
                    ]
                    [ text "Affogato"
                    ]
                ]
            , li
                [ class "project"
                ]
                [ a
                    [ href "https://github.com/officeBatman/blobs"
                    ]
                    [ text "Blobs - 2d simulation with raylib"
                    ]
                ]
            ]
        ]


viewAbout : Html Msg
viewAbout =
    div
        [ class "section"
        , class "about"
        ]
        [ h2
            [ class "section-title"
            ]
            [ text "About"
            ]
        , p
            [ class "about-text"
            ]
            [ text
                """
                Hi, I'm Yonatan Reicher.
                I'm studying to become a software engineer.
                Currently, I am earning credit for a degree in Computer Scienece,
                and in my last year of Magshimim.
                I'm also 17 years old.
                Right now I am working on a project called affogato
                with my friend Gal.
                I am currently in an application process for the IDF.
                """
            ]
        ]


viewContact : Html Msg
viewContact =
    div
        [ class "section"
        , class "contact"
        ]
        [ h2
            [ class "section-title"
            ]
            [ text "Contact"
            ]
        , p
            [ class "contact-text"
            ]
            [ text
                """
                You can contact me by email at yony252525@gmail.com or by phone
                at 972-58-425-6935.
                """
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none

