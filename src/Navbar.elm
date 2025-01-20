module Navbar exposing (NavbarDir(..), navbar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Links exposing (myGithub)


type NavbarDir
    = Horizontal
    | Vertical


directionAttr : NavbarDir -> Attribute x
directionAttr direction =
    case direction of
        Horizontal ->
            attribute "horizontal" ""

        Vertical ->
            attribute "vertical" ""


type alias Item =
    { name : String, link : String, iconPath : String }


items : List Item
items =
    [ { name = "Home"
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
      , link = myGithub
      , iconPath = "images/icons/github.svg"
      }
    ]


navbar : { direction : NavbarDir, onTopOf : List (Html msg) } -> Html msg
navbar { direction, onTopOf } =
    div
        [ class "navbar"
        , directionAttr direction
        ]
        [ row
        , div [ class "on-top-of" ] onTopOf
        ]


row : Html msg
row =
    div [ class "items" ] (List.map viewItem items)


viewItem : Item -> Html msg
viewItem { name, link, iconPath } =
    a [ class "item", href link ]
        -- TODO: Switch to using Lucide icons
        [ img [ class "icon", src iconPath ] []
        , text name
        ]
