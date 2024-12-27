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
import Projects
import Navbar exposing (navbar)


type alias Flags = { userAgent: String }


type Page
    = Home Home.Model
    | Blog Blog.Model
    | Projects Projects.Model


type alias Model =
    { key: Nav.Key
    , url: Url.Url
    , page: Page
    , isPhone: Bool
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | HomeMsg Home.Msg
    | BlogMsg Blog.Msg
    | ProjectsMsg Projects.Msg


type Route
    = HomeRoute
    | BlogRoute (Maybe String)
    | ProjectsRoute


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
        , Url.Parser.s "projects" |> Url.Parser.map ProjectsRoute
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


        Just ProjectsRoute ->
            ({ model | page = Projects () }
            , Cmd.none
            )


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


phoneUserAgents : List String
phoneUserAgents =
    [ "Android"
    , "webOS"
    , "iPhone"
    , "iPad"
    , "iPod"
    , "BlackBerry"
    , "IEMobile"
    , "Opera Mini"
    , "windows phone"
    ]


isPhone : String -> Bool
isPhone userAgent =
    List.any (String.toLower >> (==) (String.toLower userAgent)) phoneUserAgents


init : Flags -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init { userAgent } url key =
    Model key url (Home ()) (isPhone userAgent)
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

        (ProjectsMsg projectsMsg, Projects projectsModel) ->
            Projects.update projectsMsg projectsModel
            |> Tuple.mapBoth
                (\newProjectsModel -> { model | page = Projects newProjectsModel })
                (Cmd.map ProjectsMsg)

        (ProjectsMsg _, _) -> (model, Cmd.none)


view : Model -> Document Msg
view model =
    model
    |> viewContent
    |> mapDocumentBody (\content ->
        [ navbar
            { direction = getNavbarDir model
            , onTopOf = content
            }
        ]
    )


getNavbarDir : Model -> Navbar.NavbarDir
getNavbarDir model =
    if model.isPhone then Navbar.Horizontal else Navbar.Vertical


mapDocumentBody : (List (Html a) -> List (Html b)) -> Document a -> Document b
mapDocumentBody f { title, body } =
    { title = title
    , body = f body
    }


viewContent : Model -> Document Msg
viewContent model =
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

        Projects projectsModel ->
            Projects.view projectsModel
            |> mapDocument ProjectsMsg


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

        Projects projectsModel ->
            Projects.subscriptions projectsModel
            |> Sub.map ProjectsMsg

