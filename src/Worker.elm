port module Worker exposing (main)

import Json.Decode as D
import Json.Encode as E


type Command
    = Ping


type alias Model =
    Int


type Msg
    = Execute Command


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Platform.worker
        { init = \_ -> ( 0, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    if model < 10 then
        let
            outCmd =
                sendResult <| E.object [ ( "type", E.string "Pong" ) ]
        in
        ( model + 1, outCmd )

    else
        ( model, Cmd.none )


command : D.Decoder Command
command =
    D.succeed Ping


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveCommand (D.decodeValue command >> Result.withDefault Ping >> Execute)


port receiveCommand : (D.Value -> msg) -> Sub msg


port sendResult : E.Value -> Cmd msg
