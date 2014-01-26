-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

mainmenu = {}
levelsPerLine=4

fntTitle = love.graphics.newFont("fonts/PrintChar21.ttf", 30)

function drawLabel(str,width,height,font)
  love.graphics.setFont(font)
  love.graphics.print(str,width,height)
end

function fromCenter(widthOff)
  return (canvasWidth-widthOff)/2
end

function resetSettings()
  love.graphics.setFont(fntDefault)
  love.graphics.setColor(255,255,255);
end

function mainmenu:enter()
  resetSettings();

  menuElement = {}
  menuElementCt=1;

  local str
  --str="Labyrinth"
  --addMenuElement(str,fromCenter(fntTitle:getWidth(str)),20,fntTitle:getWidth(str),fntTitle:getHeight(str),fntTitle)

  --str="Main Menu"
  --str = "SELECT YOUR LEVEL"
  --addMenuElement(str,fromCenter(fntDefault:getWidth(str)),55,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault)


  local x,ysizeX
    for y=0,2-1,1 do
  for x=0,levelsPerLine-1,1 do
      str=(y*levelsPerLine)+x+1
      addMenuElement(str,
        fromCenter(str)+((x-(levelsPerLine/2))*80)+40,
        180+(y*40),
        fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuLevel,(y*levelsPerLine)+x+1)
    end
  end

  str=" Back"
  addMenuElement(str,canvasWidth-300,canvasHeight-30,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuQuit)

end

menuElement = {}
menuElementCt=1;
menuElementActive=1
function addMenuElement(text,x,y,sx,sy,font,evt,info)
  local o={
    txt=text,
    font=font,
    posX=x,
    posY=y,
    sizeX=sx,
    sizeY=sy,
    event=evt,
    info=info,
    index=menuElementCt
  }

  menuElement[menuElementCt]=o
  menuElementCt=menuElementCt+1;
end

function testHit(posX,posY)
  for x=1,menuElementCt-1,1 do
    local v=menuElement[x]
    
    local off=5;
    if ((posX-v.posX>=-off) and (posX-v.posX<=v.sizeX+off) and (posY-v.posY>=-off) and (posY-v.posY<=v.sizeY+off)) then
      return v
    end
  end
  return nil
end

function renderMenuElement()
  love.graphics.setColor(255,255,255);

  local x
  for x=1,menuElementCt-1,1 do
    local v=menuElement[x]
    if x == menuElementActive then love.graphics.rectangle("line", v.posX-10, v.posY-10, v.sizeX+20, v.sizeY+20) end
    drawLabel(v.txt,v.posX,v.posY,v.font)
  end
end

function mainmenu:draw()
   draw_menu_bg()
   
   renderMenuElement()

   love.graphics.setFont(fntTitle)
   love.graphics.setColor(255,255,255);
   love.graphics.print("SELECT YOUR LEVEL", (canvasWidth-fntTitle:getWidth("SELECT YOUR LEVEL"))/2, 100)
end

mainmenu.lastx = 0   mainmenu.lasty = 0
function mainmenu:update(dt)
   local mousex,mousey = love.mouse.getX(), love.mouse.getY()
   if mousex == self.lastx and mousey == self.lasty then return end
   local hittest = testHit(mousex,mousey)
   if hittest ~= nil then menuElementActive = hittest.index end
   self.lastx = mousex      self.lasty = mousey
end

function mainmenu:onmenuevent(menuitem)
  if (menuitem~=nil) then
    if (menuitem.event~=nil) then
      menuitem.event(menuitem)
      --print(menuitem.txt)
    end
  end
end

function mainmenu:mousereleased()
  local h=testHit(love.mouse.getX(),love.mouse.getY())
  self:onmenuevent(h)
end

function mainmenu:keypressed(key)
   if key == " " or key == "return" then --space
      local h = menuElement[menuElementActive]
      self:onmenuevent(h)
   elseif key == "down" then
      menuElementActive = menuElementActive + levelsPerLine
      if menuElementActive > #menuElement then menuElementActive = #menuElement end
   elseif key == "up" then
      menuElementActive = menuElementActive - levelsPerLine
      if menuElementActive < 1 then menuElementActive = 1 end
   elseif key == "left" then
      menuElementActive = menuElementActive - 1
      if menuElementActive < 1 then menuElementActive = 1 end
   elseif key == "right" then
      menuElementActive = menuElementActive + 1
      if menuElementActive > #menuElement then menuElementActive = #menuElement end
   elseif key == "escape" then
      Gamestate.switch(mainmenu_old)
   end
end

--menu events

function menuQuit(button)
   Gamestate.switch(mainmenu_old)
end

function menuLevel(button)
  local lvl=button.info

  Gamestate.switch(labyrinth,lvl)
end

function menuToogleMusic(button)
  if (backgroundMusic) then
    sndBackgroundmusic:pause()
    button.txt="Toogle Sound: OFF"
  else
    sndBackgroundmusic:resume()
    button.txt="Toogle Sound: ON"
  end

  backgroundMusic=(backgroundMusic==false)
end

function menuToogleFullscreen(button)
  local fs=love.window.getFullscreen()

  if (fs) then
    button.txt="Toogle Fullscreen: OFF"
  else
    button.txt="Toogle Fullscreen: ON"
  end

  love.window.setFullscreen(false==fs)
end
