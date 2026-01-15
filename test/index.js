const { app, BrowserWindow } = require('electron');
const electronDragOutside = require('../index');

electronDragOutside();

app.on('ready', () => {
  const win = new BrowserWindow({
    width: 600,
    height: 600,
  });

  win.loadFile('./index.html');
});
