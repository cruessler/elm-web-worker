port module Main exposing (main)

import Browser
import Html exposing (Html)
import Json.Decode as D
import Json.Encode as E


type alias Model =
    Int


type Msg
    = Pong


main : Program () Model Msg
main =
    let
        initialCommand =
            sendCommand <| E.object [ ( "type", E.string "Ping" ) ]
    in
    Browser.element
        { init = \_ -> ( 0, initialCommand )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


payload : D.Decoder Msg
payload =
    D.succeed Pong


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveResult (D.decodeValue payload >> Result.withDefault Pong)


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    if model < 10 then
        let
            outCmd =
                sendCommand <| E.object [ ( "type", E.string "Ping" ) ]
        in
        ( model + 1, outCmd )

    else
        ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.text (String.fromInt model)


port sendCommand : E.Value -> Cmd msg


port receiveResult : (D.Value -> msg) -> Sub msg
