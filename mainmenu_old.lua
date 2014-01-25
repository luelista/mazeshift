-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

mainmenu = {}

function mainmenu:draw()
   love.graphics.setFont(fntDefault);
    -- draw text "Hello world!" at left: 100, top: 200
   love.graphics.print("Welcome to the Multi View Labyrinth!", 100, 50)
   love.graphics.setFont(fntTitle);
   love.graphics.print("Main Menu", 100, 100)
   if blinkyvis then love.graphics.print("Press SPACE to start", 100, 500) end
   
end

blinkytimer = 0   blinkyvis = false
function mainmenu:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
end

function mainmenu:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth, 1)
   elseif key == "escape" then
      love.event.quit()
   end
end


