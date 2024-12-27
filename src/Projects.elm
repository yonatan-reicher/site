module Projects exposing (Flags, Model, Msg, init, update, view, subscriptions)

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
    { title = "Yonatan Reicher | Projects"
    , body = [ viewProjects ]
    }


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
                , date = "2022"
                }
            , viewProject
                { name = "Wave Function Collapse"
                , description =
                    [ text
                        """
                        A simple demo implementation of the Wave Function
                        Collapse algorithm to generate an interesting looking
                        town!
                        Made in C# with MonoGame.
                        """
                    ]
                , link = "https://github.com/yonatan-reicher/wave-function-collapse/"
                , picturePath = Just "images/wave-function-collapse.png"
                , date = "2023-12-18"
                }
            , viewProject
                { name = "Character Controller Test"
                , description =
                    [ text "A simple character controller to test out phaser.js"
                    ]
                , link = "https://yonatan-reicher.github.io/phaser-character-test/"
                , picturePath = Just "images/phaser-character-test.png"
                , date = "2023-10-27"
                }
            , viewProject
                { name = "GR++ Redesign"
                , description =
                    [ text
                        """
                        Major redesign for the website of the fauclty of
                        computer science in the Technion. Made with love, in
                        about a weekend. A must for every student in the
                        faculty! (Works on both
                        """
                    , a 
                        [ href "https://chrome.google.com/webstore/detail/gr%20%20-redesign/iaagdkjkkpiiollookginpcjapbhjfli" ]
                        [ text "Chrome"
                        ]
                    , text " and "
                    , a 
                        [ href "https://addons.mozilla.org/en-US/firefox/addon/gr-redesign/"
                        ]
                        [ text "Firefox"
                        ]
                    , text ")."
                    ]
                , link = "https://addons.mozilla.org/en-US/firefox/addon/gr-redesign/"
                , picturePath = Just "images/grpp.jpg"
                , date = "2023-02-24"
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
                , link = "https://github.com/yonatan-reicher/AB"
                , picturePath = Just "images/ab.png"
                , date = "2019"
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
                , link = "https://github.com/yonatan-reicher/blobs"
                , picturePath = Just "images/blobs.jpg"
                , date = "2021-01-18"
                }
            , viewProject
                { name = "This Site"
                , description =
                    [ text
                        """
                        Putting stuff on the internet is fun, and also - really
                        embarrassing.
                        """
                    , br [] []
                    , br [] []
                    , text
                        """
                        I made this site to put my projects on display, to
                        practice some code, and to get over a fear of putting
                        my work out there.
                        """
                    ]
                , link = "#"
                , picturePath = Nothing
                , date = "2022-01-28"
                }
            ]
        ]


viewProject :
    { name: String, description: List (Html Msg)
    , link: String, picturePath: Maybe String
    , date: String
    } -> Html Msg
viewProject { name, description, link, picturePath, date } =
    li
        [ class "project"
        ]
        [ a [ href link ]
            [ h3 [ class "project-title" ] [ text name ]
            ]
        , case picturePath of
            Just path ->
                a
                    [ href link
                    , target "blank"
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
        , p
            [ class "project-date"
            ]
            [ text date
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


