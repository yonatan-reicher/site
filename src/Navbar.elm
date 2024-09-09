module Navbar exposing (navbar, NavbarDir(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type NavbarDir
    = Horizontal
    | Vertical
    | Auto


navbar : { direction: NavbarDir, onTopOf: Html msg } -> Html msg
navbar { direction, onTopOf } =
    container (navbarElement direction) onTopOf


container : Html msg -> Html msg -> Html msg
container nav onTopOf =
    div
        [ class "navbar-container"
        ]
        [ nav
        , onTopOf
        ]


navbarElement : NavbarDir -> Html msg
navbarElement direction =
    ul
        [ class "navbar"
        , case direction of
                Horizontal -> class "navbar-horizontal"
                Vertical -> class "navbar-vertical"
                Auto -> class "navbar-auto"
        ]
        ( [ { name = "Home"
            , link = "#"
            , iconPath = "images/icons/home.svg"
            }
          , { name = "Projects"
            , link = "#/projects"
            , iconPath = "images/icons/projects.svg"
            }
          , { name = "Blog"
            , link = "#/blog"
            , iconPath = "images/icons/blog.svg"
            }
          , { name = "Github"
            , link = "https://github.com/yonatan-reicher"
            , iconPath = "images/icons/github.svg"
            }
          ]
          |> List.map navbarItem
        )


navbarItem : { name: String, link: String, iconPath: String } -> Html msg
navbarItem { name, link, iconPath } =
    li []
        [ a
            [ href link
            ]
            [ img
                [ class "navbar-icon"
                , src iconPath
                ]
                []
            , span
                [ class "navbar-link-text"
                ]
                [ text name
                ]
            ]
        ]

