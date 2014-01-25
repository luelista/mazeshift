-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

mainmenu_old = {}



function mainmenu_old:enter()
   mainmenu_old.menuitems = {"P L A Y","LEVELS","Level 1", "Level 2","TOGGLE MUSIC","FULLSCREEN","CREDITS","UIT GAME"}
   mainmenu_old.curmenuitem = 1
   mainmenu_old.menutop = 120
   mainmenu_old.menuheight = 20
end

function mainmenu_old:draw()
   love.graphics.setFont(fntTitle)
   love.graphics.print("Welcome to MAZE SHIFT !", 100, 50)
   
   love.graphics.setFont(fntDefault)
   
    -- draw text "Hello world!" at left: 100, top: 200
   
   if blinkyvis then love.graphics.print("Main Menu", 100, 100) end
   
   local top = mainmenu_old.menutop local left = 100
   for i = 1,#mainmenu_old.menuitems do
      top = top + mainmenu_old.menuheight
      love.graphics.print(mainmenu_old.menuitems[i], 100, top)
      if i == mainmenu_old.curmenuitem then love.graphics.print("", 80, top) end
   end
end

function mainmenu_old:onMenuItem(item)
   if item == "P L A Y" then
      Gamestate.switch(labyrinth, 1)
   elseif item == "LEVELS" then
      Gamestate.switch(mainmenu)
   elseif item == "Level 1" then
      Gamestate.switch(labyrinth, 1)
   elseif item == "Level 2" then
      Gamestate.switch(labyrinth, 2)
   elseif item == "TOGGLE MUSIC" then
      labyrinth.show_map = true
   elseif item == "FULLSCREEN" then
      Gamestate.switch(mainmenu)
   elseif item == "CREDITS" then
      Gamestate.switch(credits)
   elseif item == "UIT GAME" then
      love.event.quit()
   end
end

blinkytimer = 0   blinkyvis = false   mouselasty = 0
function mainmenu_old:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
   local mousey = love.mouse.getY()
   if mousey ~= mouselasty then   mouselasty = mousey
      local menuitem = mainmenu_old:getMenuByYPos(mousey)
      if menuitem ~= 0 then  mainmenu_old.curmenuitem = menuitem end
   end
end

function mainmenu_old:getMenuByYPos(ypos)
   local menuitem = (ypos - mainmenu_old.menutop) / mainmenu_old.menuheight
   if menuitem >= 1 and menuitem < #mainmenu_old.menuitems+1 then
      return math.floor(menuitem)
   end
   return 0
end

function mainmenu_old:mousepressed(x, y, button)
   if button == "l" then
      local menuitem = mainmenu_old:getMenuByYPos(y)
      if menuitem ~= 0 then mainmenu_old:onMenuItem(mainmenu_old.menuitems[menuitem]) end
   end
end

function mainmenu_old:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth)
   elseif key == "up" then
      mainmenu_old.curmenuitem = mainmenu_old.curmenuitem - 1
      if mainmenu_old.curmenuitem < 1 then mainmenu_old.curmenuitem = #mainmenu_old.menuitems end
   elseif key == "down" then
      mainmenu_old.curmenuitem = mainmenu_old.curmenuitem + 1
      if mainmenu_old.curmenuitem > #mainmenu_old.menuitems then mainmenu_old.curmenuitem = 1 end
   elseif key == "return" then
      mainmenu_old:onMenuItem(mainmenu_old.menuitems[mainmenu_old.curmenuitem])
   elseif key == "q" then
      mainmenu_old:onMenuItem("UIT GAME")
   end
end


