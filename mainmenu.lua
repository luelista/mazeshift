-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

mainmenu = {}



function mainmenu:enter()
   mainmenu.menu = MenuHelper.new()
   mainmenu.menu.menutop = 120
   mainmenu.menu.menuheight = 30   mainmenu.menu.menuthreshold = 10
   mainmenu.menu:add("P L A Y", function() Gamestate.switch(labyrinth, 1)  end)
   mainmenu.menu:add("LEVELS", function() Gamestate.switch(levelmenu)  end)
   mainmenu.menu:add("MUSIC: ON", toggleBackgroundMusic)
   mainmenu.menu:add("FULLSCREEN: OFF", toggleFullscreen)
   mainmenu.menu:add("CREDITS", function() Gamestate.switch(credits)  end)
   mainmenu.menu:add("UIT GAME", function() love.event.quit()  end)

end

function draw_menu_bg()
   love.graphics.draw(imgDefaultBg, imgDefaultBgQuad, 0,0, 0, 1,1)
   love.graphics.setColor(255,0,0,150);
   love.graphics.circle( "fill", canvasWidth/4*1, canvasHeight/5*4, canvasWidth/5, canvasHeight/5)
   
   love.graphics.setColor(255,255,0,150);
   love.graphics.circle( "fill", canvasWidth/1*1, canvasHeight/1*0, canvasWidth/4, canvasHeight/4)
   
   love.graphics.setColor(0,0,255,150);
   love.graphics.circle( "fill", canvasWidth/3*2, canvasHeight/3*2, canvasWidth/8, canvasHeight/8)

   love.graphics.setColor(0,255,0,150);
   love.graphics.circle( "fill", canvasWidth/2, canvasHeight/4*3, canvasWidth/6, canvasHeight/8)

end

function mainmenu:draw()
   draw_menu_bg()

   love.graphics.setColor(255,255,255)
   love.graphics.setFont(fntTitle)
   love.graphics.print("Welcome to MAZE SHIFT !", 100, 50)
   
   love.graphics.setFont(fntDefault)
   
   if blinkyvis then love.graphics.print("Main Menu", 100, 100) end
   mainmenu.menu:draw()
end


blinkytimer = 0   blinkyvis = false   mouselasty = 0
function mainmenu:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   mainmenu.menu:update(dt)
end

function mainmenu:mousereleased(x, y, button)
   mainmenu.menu:mousereleased(x, y, button)
end

function mainmenu:keypressed(key)
   mainmenu.menu:keypressed(key)
   if key == "q" then
      love.event.quit()
   end
end


