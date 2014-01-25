-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-
Gamestate = require "hump.gamestate"

require "labyrinth"
require "mainmenu"

function love.load()
   io.stdout:setvbuf("no")
   
   love.keyboard.setKeyRepeat(true)
   love.window.setMode(1024, 600, {})
   
   fntDefault = love.graphics.newFont("fonts/PrintChar21.ttf", 12)
   
   sndBackgroundmusic = love.audio.newSource("sound/Silly Fun.mp3")
   sndBackgroundmusic:play()
   sndBackgroundmusic:setVolume(0.5)

   Gamestate.registerEvents()
   Gamestate.switch(mainmenu)
end
