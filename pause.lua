-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

pause = {}

function pause:enter()
   pause.menuitems = {"CONTINUE LEVEL","RESTART LEVEL","CHEAT: SHOW MAP","BACK TO MAIN MENU","QUIT GAME"}
   pause.curmenuitem = 1
   pause.menutop = 120
   pause.menuheight = 20
end

function pause:draw()
   love.graphics.setFont(fntDefault);
    -- draw text "Hello world!" at left: 100, top: 200
   
   if blinkyvis then love.graphics.print("Take a break...", 100, 50) end
   
   local top = pause.menutop local left = 100
   for i = 1,#pause.menuitems do
      top = top + pause.menuheight
      love.graphics.print(pause.menuitems[i], 100, top)
      if i == pause.curmenuitem then love.graphics.print("", 80, top) end
   end
end

function onMenuItem(item)
   if item == "CONTINUE LEVEL" then
      Gamestate.switch(labyrinth, nil)
   elseif item == "RESTART LEVEL" then
      Gamestate.switch(labyrinth, labyrinth.current_level)
   elseif item == "CHEAT CODES" then
      labyrinth.show_map = true
   elseif item == "BACK TO MAIN MENU" then
      Gamestate.switch(mainmenu)
   elseif item == "QUIT GAME" then
      love.event.quit()
   end
end

blinkytimer = 0   blinkyvis = false   mouselasty = 0
function pause:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   local mousey = love.mouse.getY()
   if mousey ~= mouselasty then   mouselasty = mousey
      local menuitem = getMenuByYPos(mousey)
      if menuitem ~= 0 then  pause.curmenuitem = menuitem end
   end
end

function getMenuByYPos(ypos)
   local menuitem = (ypos - pause.menutop) / pause.menuheight
   if menuitem >= 1 and menuitem < #pause.menuitems+1 then
      return math.floor(menuitem)
   end
   return 0
end

function pause:mousepressed(x, y, button)
   if button == "l" then
      local menuitem = getMenuByYPos(y)
      if menuitem ~= 0 then onMenuItem(pause.menuitems[menuitem]) end
   end
end

function pause:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth)
   elseif key == "up" then
      pause.curmenuitem = pause.curmenuitem - 1
      if pause.curmenuitem < 1 then pause.curmenuitem = #pause.menuitems end
   elseif key == "down" then
      pause.curmenuitem = pause.curmenuitem + 1
      if pause.curmenuitem > #pause.menuitems then pause.curmenuitem = 1 end
   elseif key == "return" then
      onMenuItem(pause.menuitems[pause.curmenuitem])
   elseif key == "q" then
      onMenuItem("QUIT GAME")
   end
end


