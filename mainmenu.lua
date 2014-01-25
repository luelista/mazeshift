
mainmenu = {}

function drawLabelCentered(str,height)
  local font=love.graphics.getFont()
  local w=font:getWidth("Main Menu");
  love.graphics.print("Main Menu", (canvasWidth-w)/2, 100)
end

function mainmenu:draw()
  

  drawLabelCentered("Main Menu",0)

  drawLabelCentered("Start",20)
  drawLabelCentered("Level",40)
  drawLabelCentered("Exit" ,60)

end


function mainmenu:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth)
   elseif key == "escape" then
      love.event.quit()
   end
end
