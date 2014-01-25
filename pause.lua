-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

pause = {}

function pause:enter()
   pause.menu = MenuHelper:new()
   pause.menu:add("CONTINUE LEVEL", function() Gamestate.switch(labyrinth, nil) end)
   pause.menu:add("RESTART LEVEL", function() Gamestate.switch(labyrinth, labyrinth.current_level) end)
   pause.menu:add("CHEAT: SHOW MAP", function() labyrinth.show_map = true end)
   pause.menu:add("MUSIC: ON", toggleBackgroundMusic)
   pause.menu:add("FULLSCREEN: OFF", toggleFullscreen)
   pause.menu:add("BACK TO MAIN MENU", function() Gamestate.switch(mainmenu) end)
   pause.menu:add("UIT GAME", function() love.event.quit() end)
end

function pause:draw()
   love.graphics.setFont(fntDefault);
    -- draw text "Hello world!" at left: 100, top: 200
   
   if blinkyvis then love.graphics.print("Take a break...", 100, 50) end
   
   pause.menu:draw()
end


blinkytimer = 0   blinkyvis = false
function pause:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   pause.menu:update(dt)
end

function pause:mousepressed(x, y, button)
   pause.menu:mousepressed(x, y, button)
end

function pause:keypressed(key)
   if key == "q" then
      love.event.quit()
   end
   if key == "escape" then
      Gamestate.switch(labyrinth, nil)
   end
   pause.menu:keypressed(key)
end


