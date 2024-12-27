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
    | LoadingPostBody Post
    | PostPage
        { post: Post
        , content : List (Html Msg)
        }


type alias Post =
    { title : String
    , date : Posix
    , fileName: String
    }


type Msg
    = IndexPostsLoaded (Result Http.Error (List Post))
    | PostLoaded (Result PostLoadedError Post)
    | PostBodyLoaded (Result PostBodyLoadedError (Post, List (Html Msg)))


type PostLoadedError
    = PostsGetError Http.Error
    | PostDoesNotExist String

type PostBodyLoadedError
    = PostBodyGetError Http.Error
    | PostBodyParseError


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
            , fetchPosts IndexPostsLoaded
            )

        Just fileName ->
            ( LoadingPost fileName
            , fetchPosts
                ( Result.mapError PostsGetError
                >> Result.andThen
                    (\posts ->
                        List.filter (\post -> post.fileName == fileName) posts
                        |> List.head
                        |> Result.fromMaybe (PostDoesNotExist fileName)
                    )
                >> PostLoaded
                )
            )

fetchPosts : (Result Http.Error (List Post) -> Msg) -> Cmd Msg
fetchPosts msg =
    Http.get
        { url = "./blog/posts.json"
        , expect = Http.expectJson msg postsDecoder
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
        IndexPostsLoaded (Result.Ok posts) ->
            ( Index
                { posts = Just posts
                , error = Nothing
                }
            , Cmd.none
            )

        IndexPostsLoaded (Result.Err error) ->
            ( Index
                { posts = Nothing
                , error = Just (httpErrorToString error)
                }
            , Cmd.none
            )

        PostLoaded (Result.Ok post) ->
            ( PostPage
                { post = post
                , content = []
                }
            , Http.get
                { url = "blog/posts/" ++ post.fileName ++ ".html"
                , expect =
                    Http.expectString
                        ( Result.mapError PostBodyGetError
                          >> Result.andThen (\htmlText ->
                              case Html.Parser.run htmlText of
                                  Err deadEnds ->
                                      Debug.log "Dead ends" deadEnds
                                      |> \_ -> Err PostBodyParseError

                                  Ok node ->
                                      Ok (Html.Parser.Util.toVirtualDom node))
                          >> Result.map (\body -> (post, body))
                          >> PostBodyLoaded
                        )
                }
            )

        PostLoaded (Result.Err (PostsGetError error)) ->
            ( Index
                { posts = Nothing
                , error = Just (httpErrorToString error)
                }
            , Cmd.none
            )

        PostLoaded (Result.Err (PostDoesNotExist fileName)) ->
            ( Index
                { posts = Nothing
                , error = Just ("Post does not exist: " ++ fileName)
                }
            , Cmd.none
            )

        PostBodyLoaded (Ok (post, content)) ->
            ( PostPage
                { post = post
                , content = content
                }
            , highlightAll()
            )

        PostBodyLoaded (Err error) ->
            let message =
                   case error of
                       PostBodyGetError httpError -> httpErrorToString httpError
                       PostBodyParseError -> "File is not a post"
            in
                ( Index
                    { posts = Nothing
                    , error = Just message
                    }
                , Cmd.none
                )


view : Model -> Html Msg
view model =
    main_ [ id "blog" ] [ viewContent model ]


viewContent : Model -> Html Msg
viewContent model =
    case model of
        Index { posts, error } ->
            viewIndex posts error

        LoadingPost fileName ->
            viewLoadingPost fileName

        LoadingPostBody post ->
            viewLoadingPost post.fileName

        PostPage post ->
            viewPostPage post


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
                viewIndexPosts posts

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


viewIndexPosts : List Post -> Html Msg
viewIndexPosts posts =
    ul []
        ( posts
        |> List.sortBy (.date >> Time.posixToMillis)
        |> List.reverse
        |> List.map viewIndexPost
        )


viewIndexPost : Post -> Html Msg
viewIndexPost post =
    li []
        [ a
            [ href ("#/blog/posts/" ++ post.fileName)
            ]
            [ text (post.title)
            ]
        , text " - "
        , span [] [ text (posixToYearMonthDay post.date) ]
        ]


viewPostPage : { post: Post
           , content : List (Html Msg)
           } -> Html Msg
viewPostPage { post, content } =
    div
        [ id "post"
        ]
        (viewPostHeader post :: content ++ [viewPostFooter post])


viewPostHeader : Post -> Html Msg
viewPostHeader post =
    header []
        [ h1 []
            [ a 
                [ href ("#/blog/posts/" ++ post.fileName)
                ]
                [ span [] [ text (post.title) ] ]
            ]
        , p 
            [ class "subtitle"
            ]
            [ text "Posted on "
            , time
                [ datetime (posixToYearMonthDay post.date)
                ]
                [ text (posixToMonthNameDayYear Time.utc post.date)
                ]
            ]
        ]


viewPostFooter : Post -> Html Msg
viewPostFooter post =
    footer []
        [ a
            [ href "#/blog"
            , class "back"
            ]
            [ text "Back to blog"
            ]
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


posixToMonthNameDayYear : Time.Zone -> Posix -> String
posixToMonthNameDayYear zone posix =
    ( posixToMonthString zone posix |> String.left 3 )
    ++ " "
    ++ String.fromInt (Time.toDay zone posix)
    ++ ", "
    ++ String.fromInt (Time.toYear zone posix)


posixToMonthString : Time.Zone -> Posix -> String
posixToMonthString zone posix =
    case Time.toMonth zone posix of
        Time.Jan -> "January"
        Time.Feb -> "February"
        Time.Mar -> "March"
        Time.Apr -> "April"
        Time.May -> "May"
        Time.Jun -> "June"
        Time.Jul -> "July"
        Time.Aug -> "August"
        Time.Sep -> "September"
        Time.Oct -> "October"
        Time.Nov -> "November"
        Time.Dec -> "December"

