module Blog exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Parser
import Html.Parser.Util
import Time exposing (Posix)
import Http
import Json.Decode as D
import Json.Decode.Extra as DE
import Ports exposing (highlightAll)


type Model
    = Index
        { posts : Maybe (List Post)
        , error: Maybe String
        }
    | LoadingPost String
    | PostPage
        { content : List (Html Msg)
        }


type alias Post =
    { title : String
    , date : Posix
    , fileName: String
    }


type Msg
    = LoadPosts (List Post)
    | LoadPostsError Http.Error
    | PostLoaded (Result PostLoadedError (List (Html Msg)))


type PostLoadedError
    = PostGetError Http.Error
    | PostParseError


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.BadStatus status ->
            "Bad status: " ++ (String.fromInt status)

        Http.BadBody body ->
            "Bad body: \n" ++ body

        Http.Timeout ->
            "Request timed out"

        Http.NetworkError ->
            "Network error"


init : Maybe String -> (Model, Cmd Msg)
init maybeFileName =
    case maybeFileName of
        Nothing ->
            ( Index
                { posts = Nothing
                , error = Nothing
                }
            , fetchPosts
            )

        Just fileName ->
            ( LoadingPost fileName
            , Http.get
                { url = "blog/posts/" ++ fileName ++ ".html"
                , expect = Http.expectString
                    ( Result.mapError PostGetError
                      >> Result.andThen (\htmlText ->
                          case Html.Parser.run htmlText of
                              Err deadEnds ->
                                  Debug.log "Dead ends" deadEnds
                                  |> \_ -> Err PostParseError

                              Ok node ->
                                  Ok (Html.Parser.Util.toVirtualDom node))
                      >> PostLoaded
                    )
                }
            )

fetchPosts : Cmd Msg
fetchPosts =
    Http.get
        { url = "./blog/posts.json"
        , expect =
            Http.expectJson
                (\result ->
                    case result of
                        Ok posts ->
                            LoadPosts posts
                        Err error ->
                            LoadPostsError error
                )
                postsDecoder
        }


postsDecoder : D.Decoder (List Post)
postsDecoder =
    D.list
        ( D.map3 Post
            (D.field "title" D.string)
            (D.field "date" DE.datetime)
            (D.field "fileName" D.string)
        )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LoadPosts posts ->
            ( Index
                { posts = Just posts
                , error = Nothing
                }
            , Cmd.none
            )

        LoadPostsError error ->
            let message =
                    httpErrorToString error
            in
                ( Index
                    { posts = Nothing
                    , error = Just message
                    }
                , Cmd.none
                )

        PostLoaded (Ok content) ->
            ( PostPage
                { content = content
                }
            , highlightAll()
            )

        PostLoaded (Err error) ->
            let message =
                   case error of
                       PostGetError httpError -> httpErrorToString httpError
                       PostParseError -> "File is not a post"
            in
                ( Index
                    { posts = Nothing
                    , error = Just message
                    }
                , Cmd.none
                )

view : Model -> Html Msg
view model =
    case model of
        Index { posts, error } ->
            viewIndex posts error

        LoadingPost fileName ->
            viewLoadingPost fileName

        PostPage { content } ->
            div
                [ class "blog"
                , id "blog"
                ]
                content


viewIndex : Maybe (List Post) -> Maybe String -> Html Msg
viewIndex maybePosts maybeError =
    div []
        [ h1 [] [ text "Articles" ]
        , div []
            ( case maybeError of
                Just error -> [ text error ]
                Nothing -> []
            )
        , case maybePosts of
            Just posts ->
                viewPosts posts

            Nothing ->
                viewLoading
        ]


viewLoading : Html Msg
viewLoading =
    div []
        [ h2 [] [ text "Loading..." ]
        ]


viewLoadingPost : String -> Html Msg
viewLoadingPost fileName =
    div []
        [ h2 [] [ text <| "Loading " ++ fileName ++ "..." ]
        ]


viewPosts : List Post -> Html Msg
viewPosts posts =
    ul []
        (List.map viewPost posts)


viewPost : Post -> Html Msg
viewPost post =
    li []
        [ a
            [ href ("#/blog/posts/" ++ post.fileName)
            ]
            [ text (post.title)
            ]
        , text " - "
        , span [] [ text (posixToYearMonthDay post.date) ]
        ]


posixToYearMonthDay : Posix -> String
posixToYearMonthDay posix =
    [ Time.toYear
    , posixToMonthInt
    , Time.toDay
    ]
    |> List.map (\f -> f Time.utc posix)
    |> List.map String.fromInt
    |> String.join "-"


posixToMonthInt : Time.Zone -> Posix -> Int
posixToMonthInt zone posix =
    case Time.toMonth zone posix of
        Time.Jan -> 1
        Time.Feb -> 2
        Time.Mar -> 3
        Time.Apr -> 4
        Time.May -> 5
        Time.Jun -> 6
        Time.Jul -> 7
        Time.Aug -> 8
        Time.Sep -> 9
        Time.Oct -> 10
        Time.Nov -> 11
        Time.Dec -> 12

