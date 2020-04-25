import { Elm } from "./src/Worker.elm";

const worker = Elm.Worker.init();

self.addEventListener("message", function (event) {
  worker.ports.receiveCommand.send(event.data);
});

worker.ports.sendResult.subscribe(function (result) {
  self.postMessage(result);
});
