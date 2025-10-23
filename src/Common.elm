module Common exposing (..)


import Html exposing (..)
import Html.Attributes exposing (..)


myStylesheet : Html x
myStylesheet =
    node "link" [ rel "stylesheet", type_ "text/css", href "src/style.css" ] []
