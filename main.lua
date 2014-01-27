-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-
Gamestate = require "hump.gamestate"

fontFilename = "fonts/PrintChar21.ttf"
backgroundMusic = true

require "labyrinth"
require "mainmenu"
require "mainmenu_old"
require "pause"
require "credits"
require "most_epic_win"
MenuHelper = require "menu_helper"

timerlist = {}

function love.load()
   io.stdout:setvbuf("no")
   
   --love.keyboard.setKeyRepeat(true)
   love.window.setTitle("MAZE SHIFT")
   love.window.setIcon(love.image.newImageData("images/cherry.png"))
   
   canvasWidth = 1024   canvasHeight = 600
   love.window.setMode(canvasWidth, canvasHeight, {fullscreen=false})
   
   fntDefault = love.graphics.newFont(fontFilename, 12)
   fntTitle = love.graphics.newFont(fontFilename, 20)
   
   imgDefaultBg = love.graphics.newImage("images/irongrip.png")
   imgDefaultBg:setWrap("repeat", "repeat")
   imgDefaultBgQuad = love.graphics.newQuad( 0,0, canvasWidth,canvasHeight, imgDefaultBg:getWidth(),imgDefaultBg:getHeight() )
   
   sndBackgroundmusic = love.audio.newSource("sound/Silly Fun.mp3")
   sndBackgroundmusic:play()
   sndBackgroundmusic:setVolume(0.15)
   sndBackgroundmusic:setLooping(true)
   
   Gamestate.registerEvents()
   Gamestate.switch(mainmenu_old)
end

function love.update(dt)
   if love.audio.getSourceCount() == 1 and sndBackgroundmusic:isPaused() and backgroundMusic then sndBackgroundmusic:resume() end
   for i=#timerlist,1,-1 do
      timerlist[i].t = timerlist[i].t - dt
      if timerlist[i].t <= 0 then local c=timerlist[i].c table.remove(timerlist,i) c() end
   end
end

function setTimeout(callback, time)
   table.insert(timerlist, { c = callback, t = time })
end

function toggleBackgroundMusic(self)
   if (backgroundMusic) then
      sndBackgroundmusic:pause()   if self ~= nil then self.tx="MUSIC: OFF" end
   else
      sndBackgroundmusic:resume()  if self ~= nil then  self.tx="MUSIC: ON" end
   end
   backgroundMusic=not backgroundMusic
end

function toggleFullscreen(self) 
   local fs=love.window.getFullscreen()
   if self ~= nil then 
      if (fs) then self.tx="FULLSCREEN: OFF" else self.tx="FULLSCREEN: ON" end
   end
   love.window.setFullscreen(false==fs)  
end

