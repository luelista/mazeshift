-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

credits = {}

function credits:enter()
   credits.menu = MenuHelper:new()
   credits.menu.menutop = 500
   credits.menu:add("BACK", function() Gamestate.switch(mainmenu_old) end)
   credits.text = love.filesystem.read("CREDITS.txt")
end

function credits:draw()
   love.graphics.setFont(fntDefault);
   love.graphics.setColor(255, 255, 255)
    -- draw text "Hello world!" at left: 100, top: 200
   
   if blinkyvis then love.graphics.print("C R E D I T S", 100, 50) end
   
   love.graphics.print(credits.text, 100, 80)
   
   credits.menu:draw()
end


blinkytimer = 0   blinkyvis = false
function credits:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   credits.menu:update(dt)
end

function credits:mousepressed(x, y, button)
   credits.menu:mousepressed(x, y, button)
end

function credits:keypressed(key)
   if key == "escape" then
      Gamestate.switch(mainmenu_old)
   end
   credits.menu:keypressed(key)
end


