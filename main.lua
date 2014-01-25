-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-
Gamestate = require "hump.gamestate"

fontFilename = "fonts/PrintChar21.ttf"
backgroundMusic = true

require "labyrinth"
require "mainmenu"
require "pause"

function love.load()
   io.stdout:setvbuf("no")
   
   love.keyboard.setKeyRepeat(true)
   
   canvasWidth = 1024   canvasHeight = 600
   love.window.setMode(canvasWidth, canvasHeight, {fullscreen=false})
   
   fntDefault = love.graphics.newFont(fontFilename, 12)
   fntTitle = love.graphics.newFont(fontFilename, 20)
   
   sndBackgroundmusic = love.audio.newSource("sound/Silly Fun.mp3")
   sndBackgroundmusic:play()
   sndBackgroundmusic:setVolume(0.15)

   Gamestate.registerEvents()
   Gamestate.switch(mainmenu)
end

function love.update(dt)
   if love.audio.getSourceCount() == 1 and sndBackgroundmusic:isPaused() and backgroundMusic then sndBackgroundmusic:resume() end
end

