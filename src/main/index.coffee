import { Menu, Tray, app, BrowserWindow } from 'electron'
path = require 'path'
TITLE = require './const/slogan.coffee'

# Set `__static` path to static files in production
# https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-static-assets.html

global.__data = app.getPath('userData')
if process.env.NODE_ENV == 'development'
    winURL = "http://localhost:9080"
else
    global.__static = path.join(__dirname, '/static').replace(/\\/g, '\\\\')
    winURL = "file://#{__dirname}/index.html"


if process.platform == 'win32'
    platform = 'win'
else
    platform = 'mac'


iconPath = path.join(__static, 'ico', platform)+"/"

mainWindow = null

createWindow = ->
    if mainWindow
        mainWindow.focus()
        return

    app.dock.show()
    mainWindow = new BrowserWindow({
      title:TITLE
      height: 800
      show:false
      useContentSize: true
      width: 450
      webPreferences:{
          defaultEncoding:"UTF-8"
      }
      frame: false
      alwaysOnTop:true
    })
    mainWindow.webContents.once('dom-ready', =>
        mainWindow.show()
        mainWindow.focus()
    )

    mainWindow.loadURL(winURL)
    mainWindow.on('closed', =>
        mainWindow = null
        app.dock.hide()
    )


app.dock.hide()
app.on('ready', ->
    appTray = new Tray(iconPath+"tray.png")
    contextMenu = Menu.buildFromTemplate([
        {
            label:'打开 GitBox 极客宝盒'
            type:'normal'
            click:(menuItem, browserWindow)=>
                createWindow()
        }
        {
            type: 'separator'
        }
        { label: 'xxe23.png 上传中\t32.32%', type: 'normal' , enabled:false},
        { label: '32 个文件等待上传\t3.22GB', type: 'normal', enabled:false },
        {
            type: 'separator'
        }
        {
            label:'注销 Tom Koo'
            type:'normal'
        }
        {
            label:'退出'
            type:'normal'
            click:=>
                app.quit()
        }
    ])
    appTray.setToolTip(TITLE)
    appTray.setContextMenu(contextMenu)
    require("./fastify.coffee")()
)
#app.on('before-quit', =>
#    mainWindow.hide()
#)

app.on('window-all-closed', =>
  if process.platform != 'darwin'
    app.quit()
)

app.on('activate', =>
  if mainWindow == null
    createWindow()
)

# * Auto Updater
# *
# * Uncomment the following code below and install `electron-updater` to
# * support auto updating. Code Signing with a valid certificate is required.
# * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-electron-builder.html#auto-updating

###
import { autoUpdater } from 'electron-updater'

autoUpdater.on('update-downloaded', () => {
  autoUpdater.quitAndInstall()
})

app.on('ready', () => {
  if (process.env.NODE_ENV === 'production') autoUpdater.checkForUpdates()
})
###

