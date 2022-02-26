module Navbar exposing (navbar, NavbarDir(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type NavbarDir
    = Horizontal
    | Vertical
    | Auto


navbar : { direction: NavbarDir } -> Html msg
navbar { direction } =
    ul
        [ class "navbar"
        , case direction of
                Horizontal -> class "navbar-horizontal"
                Vertical -> class "navbar-vertical"
                Auto -> class "navbar-auto"
        ]
        ( [ { name = "Home", link = "#", iconPath = "icons/home.svg" }
          , { name = "Articles", link = "#/blog", iconPath = "icons/blog.svg" }
          , { name = "About", link = "#", iconPath = "icons/about.svg" }
          , { name = "Github", link = "https://github.com/officebatman", iconPath = "icons/github.svg" }
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

