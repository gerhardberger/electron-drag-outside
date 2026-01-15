# electron-drag-outside

## Description

```js
$ npm i electron-drag-outside
```

This Native Node Module allows you to change the behavior of Electron/Chromium
handles dragging of mouse events outside a BrowserWindow. Normally only left
mouse clicks are tracked but with this addon also right and other (like middle)
mouse buttons are firing events while dragging outside.

## Usage

``` typescript
const { app, BrowserWindow } = require('electron');
const electronDragOutside = require('electron-drag-outside');

electronDragOutside();

app.on('ready', () => {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    frame: false,
  });

  win.loadFile('./index.html');
});
```
