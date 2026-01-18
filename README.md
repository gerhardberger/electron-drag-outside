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

app.commandLine.appendSwitch("blink-settings", "showContextMenuOnMouseUp=true");

app.on('ready', () => {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    frame: false,
  });

  win.loadFile('./index.html');
});
```

## Notes

- As seen on the example above, to enable this behavior, it's necessary to set
  the `showContextMenuOnMouseUp` Chromium Blink switch to `true`, otherwise the
  context menu event handling will kick in blocking the tracking of drag.
- It's not required but advised to call `event.preventDefault()` in the
  `contextmenu` event for the elements where we want this behavior.
