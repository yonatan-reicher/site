module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser exposing ((</>))
import Blog


type alias Flags = ()


type Page
    = Home { field: Field }
    | Blog Blog.Model


type alias Model =
    { key: Nav.Key
    , url: Url.Url
    , page: Page
    }


type Field
    = Software
    | Web
    | MachineLearning


type Msg
    = SetField Field
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | BlogMsg Blog.Msg


fieldToString : Field -> String
fieldToString field =
    case field of
        Software -> "software"
        Web -> "web"
        MachineLearning -> "machine learning"


type Route
    = HomeRoute
    | BlogRoute (Maybe String)


routeParser : Url.Parser.Parser (Route -> a) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.top |> Url.Parser.map HomeRoute
        , Url.Parser.s "blog"
          </> Url.Parser.oneOf
            [ Url.Parser.map Nothing Url.Parser.top
            , Url.Parser.map Just (Url.Parser.s "posts" </> Url.Parser.string)
            ]
          |> Url.Parser.map BlogRoute
        ]


urlToRoute : Url.Url -> Maybe Route
urlToRoute url = 
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    -- Copied from elm-spa
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    |> Url.Parser.parse routeParser


changeRoute : Maybe Route -> Model -> (Model, Cmd Msg)
changeRoute route model =
    case route of
        Nothing -> (model, Cmd.none)

        Just HomeRoute ->
            ({ model | page = Home { field = Software } }
            , Cmd.none
            )

        Just (BlogRoute maybeFileName) ->
            Blog.init maybeFileName
            |> Tuple.mapFirst (\blogModel ->
                { model | page = Blog blogModel }
            )
            |> Tuple.mapSecond (Cmd.map BlogMsg)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Flags -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init () url key =
    Model key url (Home { field = Software })
    |> changeRoute (urlToRoute url)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetField field ->
            ({ model | page = Home { field = field } }, Cmd.none) 

        UrlChanged url ->
            changeRoute (urlToRoute url) model

        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl model.key (Url.toString url))

                Browser.External href ->
                    (model, Nav.load href)

        BlogMsg blogMsg ->
            case model.page of
                Blog blogModel ->
                    Blog.update blogMsg blogModel
                    |> Tuple.mapFirst (\newBlogModel ->
                        { model | page = Blog newBlogModel }
                    )
                    |> Tuple.mapSecond (Cmd.map BlogMsg)

                _ -> (model, Cmd.none)

view : Model -> Browser.Document Msg
view model =
    { title = "Yonatan Reicher | Math & Computer Science"
    , body =
        case model.page of
            Home { field } -> 
                [ viewHeadings field
                , viewProjects
                ]

            Blog blogModel ->
                [ Blog.view blogModel
                  |> Html.map BlogMsg
                ]
    }


viewHeadings : Field -> Html Msg
viewHeadings field =
    div [ class "headings" ]
        [ h1 []
            [ text "Hello, I'm "
            , span [ class "name" ] [ text "Yonatan" ]
            , text "."
            ]
        , h1 []
            [ span [] [ text "I'm a " ]
            , div [ class "field" ]
                [ span [ class "highlight" ] [ text (fieldToString field) ]
                , div [ class "field-options-panel" ]
                    [ div
                        [ class "field-option"
                        , onClick (SetField Software) ]
                        [ text (fieldToString Software) ]
                    , div
                        [ class "field-option"
                        , onClick (SetField Web) ]
                        [ text (fieldToString Web) ]
                    , div
                        [ class "field-option"
                        , onClick (SetField MachineLearning) ]
                        [ text (fieldToString MachineLearning) ]
                    ]
                ]
            , span [] [ text " engineer." ]
            ]
        ]


viewProjects : Html Msg
viewProjects =
    div [ class "projects" ]
        [ h1 [] [ text "Projects" ]
        , ul []
            [ li []
                [ a [ href "#/blog" ]
                    [ text "Articles" ]
                ]
            , li []
                [ a [ href "https://gitlab.com/affogato/affogato" ]
                    [ text "Affogato" ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

