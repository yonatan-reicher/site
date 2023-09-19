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
        [ viewDashboard
        , navbar { direction = Navbar.Horizontal }
        , viewProjects
        ]
    }


viewDashboard : Html Msg
viewDashboard =
    div
        [ class "dashboard"
        ]
        [ h1
            [
            ]
            [ text "Yonatan Reicher"
            ]
        , ul
            [ 
            ]
            [ li
                []
                [ a
                    [ href "https://www.github.com/yonatan-reicher"
                    ]
                    [ text "code"
                    ]
                ]
            , li
                []
                [ a
                    [ href "#/blog"
                    ]
                    [ text "blog"
                    ]
                , text " "
                , text "(Embarassing!)"
                ]
            , li
                []
                [ a
                    [ href "https://twitter.com/batman_office"
                    ]
                    [ text "art twitter"
                    ]
                ]
            , li
                []
                [ address
                    []
                    [ text "email: yony252525@gmail.com"
                    ]
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
                , link = "https://github.com/yonatan-reicher/AB"
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
                , link = "https://github.com/yonatan-reicher/blobs"
                , picturePath = Just "images/blobs.jpg"
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

