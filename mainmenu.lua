
mainmenu = {}

function mainmenu:draw()
   love.graphics.print("Main Menu", 100, 100)
   love.graphics.print("SPACE to start", 200, 100)
end


function mainmenu:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth)
   elseif key == "escape" then
      love.event.quit()
   end
end


