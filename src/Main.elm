port module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Json.Encode exposing (encode, string, list, object)


---- MODEL ----


type alias Model =
    { foo : Maybe String
    , bar : Maybe String
    }

emptyModel : Model
emptyModel =
    { foo = Just "some foo"
    , bar = Just "some bar"
    }


init : ( Model, Cmd Msg )
init =
    (update SendToJs emptyModel)


---- OUTBOUND PORTS ----


port modelToJs : Json.Encode.Value -> Cmd msg


sendModel : Model -> Cmd msg
sendModel model =
    let
        json : Json.Encode.Value
        json = encodeModel model
    in
    modelToJs json


---- UPDATE ----


type Msg
    = NoOp
    | SendToJs


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        SendToJs ->
            ( model, sendModel model )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


--- JSON ---


encodeModel : Model -> Json.Encode.Value
encodeModel model =
  object
    [ ("foo", encodeMaybeString model.foo)
    , ("bar", encodeMaybeString model.bar)
    ]

encodeMaybeString : Maybe String -> Json.Encode.Value
encodeMaybeString maybeString =
    case maybeString of
        Just s ->
            string s
        Nothing ->
            Json.Encode.null
