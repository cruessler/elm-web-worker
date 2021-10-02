import { Elm } from "./src/Main.elm";

const app = Elm.Main.init({ node: document.getElementById("root") });

const worker = new Worker(new URL("./worker.js", import.meta.url), {
  type: "module",
});

app.ports.sendCommand.subscribe(function (command) {
  worker.postMessage(command);
});

worker.onmessage = function (event) {
  app.ports.receiveResult.send(event.data);
};
