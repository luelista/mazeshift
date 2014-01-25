-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

mainmenu_old = {}



function mainmenu_old:enter()
   mainmenu_old.menu = MenuHelper.new()
   mainmenu_old.menu.menutop = 120
   mainmenu_old.menu.menuheight = 30
   mainmenu_old.menu:add("P L A Y", function() Gamestate.switch(labyrinth, 1)  end)
   mainmenu_old.menu:add("LEVELS", function() Gamestate.switch(mainmenu)  end)
   mainmenu_old.menu:add("MUSIC: ON", function(self)
                            if (backgroundMusic) then
                               sndBackgroundmusic:pause()    self.tx="MUSIC: OFF"
                            else
                               sndBackgroundmusic:resume()   self.tx="MUSIC: ON"
                            end
                            backgroundMusic=not backgroundMusic
   end)
   mainmenu_old.menu:add("FULLSCREEN: OFF", function(self) 
                            local fs=love.window.getFullscreen()
                            if (fs) then  self.tx="FULLSCREEN: OFF"  else  self.tx="FULLSCREEN: ON" end
                            love.window.setFullscreen(false==fs)  
   end)
   mainmenu_old.menu:add("CREDITS", function() Gamestate.switch(credits)  end)
   mainmenu_old.menu:add("UIT GAME", function() love.event.quit()  end)

end

function mainmenu_old:draw()
   love.graphics.setFont(fntTitle)
   love.graphics.print("Welcome to MAZE SHIFT !", 100, 50)
   
   love.graphics.setFont(fntDefault)
   
   if blinkyvis then love.graphics.print("Main Menu", 100, 100) end
   mainmenu_old.menu:draw()
end


blinkytimer = 0   blinkyvis = false   mouselasty = 0
function mainmenu_old:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   mainmenu_old.menu:update(dt)
end

function mainmenu_old:mousepressed(x, y, button)
   mainmenu_old.menu:mousepressed(x, y, button)
end

function mainmenu_old:keypressed(key)
   mainmenu_old.menu:keypressed(key)
   if key == "q" then
      mainmenu_old:onMenuItem("UIT GAME")
   end
end


