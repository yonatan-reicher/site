module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Url
import Url.Parser exposing ((</>))

import Blog
import Home


type alias Flags = ()


type Page
    = Home Home.Model
    | Blog Blog.Model


type alias Model =
    { key: Nav.Key
    , url: Url.Url
    , page: Page
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | HomeMsg Home.Msg
    | BlogMsg Blog.Msg


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
            ({ model | page = Home () }
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
    Model key url (Home ())
    |> changeRoute (urlToRoute url)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model.page) of
        (UrlChanged url, _) ->
            changeRoute (urlToRoute url) model

        (LinkClicked request, _) ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl model.key (Url.toString url))

                Browser.External href ->
                    (model, Nav.load href)

        (HomeMsg homeMsg, Home homeModel) ->
            Home.update homeMsg homeModel
            |> Tuple.mapBoth
                (\newHomeModel -> { model | page = Home newHomeModel })
                (Cmd.map HomeMsg)

        (HomeMsg _, _) -> (model, Cmd.none)

        (BlogMsg blogMsg, Blog blogModel) ->
            Blog.update blogMsg blogModel
            |> Tuple.mapBoth
                (\newBlogModel -> { model | page = Blog newBlogModel })
                (Cmd.map BlogMsg)

        (BlogMsg _, _) -> (model, Cmd.none)

view : Model -> Document Msg
view model =
    case model.page of
        Home homeModel ->
            Home.view homeModel
            |> mapDocument HomeMsg

        Blog blogModel ->
            { title = "Yonatan Reicher | Blog"
            , body =
                [ Blog.view blogModel
                  |> Html.map BlogMsg
                ]
            }


mapDocument : (a -> b) -> Document a -> Document b
mapDocument f { title, body } =
    { title = title
    , body = List.map (Html.map f) body
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Home homeModel ->
            Home.subscriptions homeModel
            |> Sub.map HomeMsg

        Blog _ ->
            Sub.none

