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
    { title = "Yonatan Reicher | Programing & Computer Science"
    , body =
        [ viewHeadings
        , navbar { direction = Navbar.Horizontal }
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
                [ text "software engineer."
                ]
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
            [ viewProject
                { name = "My Articles"
                , description =
                    [ text
                        """
                        I always wanted to write dev-blog, so I made one
                        and hosted it on this site (and it's still in progress).
                        """
                    ]
                , link = "#/blog"
                , picturePath = Nothing
                }
            , viewProject
                { name = "Affogato"
                , description =
                    [ text
                        """
                        A simple, yet powerful, machine learning library for
                        python. Made with love, with my friend, 
                        """
                    , a 
                        [ href "https://github.com/galord123" ]
                        [ text "Gal"
                        ]
                    , text
                        """
                        , For the Magshimim project.
                        """
                    ]
                , link = "https://gitlab.com/affogato/affogato"
                , picturePath = Just "images/affogato.png"
                }
            , viewProject
                { name = "AB"
                , description =
                    [ text
                        """
                        A C-Style language that complies to human-readable
                        X86 assembly for TASM
                        """
                    ]
                , link = "https://github.com/officeBatman/AB"
                , picturePath = Just "images/ab.png"
                }
            , viewProject
                { name = "Blobs"
                , description =
                    [ p []
                        [ text
                            """
                            2d simulation of blob creatures. They have
                            color-based sight, and can move, eat, and fight.
                            """
                        ]
                    , p []
                        [ ul []
                            [ li [] [ text
                                """
                                Implemented using Rust and Raylib.
                                """ ]
                            , li [] [ text 
                                """
                                Collision detection implemented by me with the
                                sweep and prune algorithm.
                                """ ]
                            ]
                        ]
                    ]
                , link = "https://github.com/officeBatman/blobs"
                , picturePath = Just "images/blobs.jpg"
                }
            ]
        ]


viewProject :
    { name: String, description: List (Html Msg)
    , link: String, picturePath: Maybe String
    } -> Html Msg
viewProject { name, description, link, picturePath } =
    li
        [ class "project"
        ]
        [ a [ href link ] [ h3 [ class "project-title" ] [ text name ] ]
        , case picturePath of
            Just path ->
                a
                    [ href link
                    ]
                    [ img
                        [ class "project-image"
                        , src path
                        ]
                        []
                    ]
            Nothing -> text ""
        , p
            [ class "project-description"
            ]
            description
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

