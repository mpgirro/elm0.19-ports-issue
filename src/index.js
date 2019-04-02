import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import dataHandler from './dataHandler';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

registerServiceWorker();

app.ports.modelToJs.subscribe(dataHandler);