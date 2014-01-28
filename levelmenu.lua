-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

levelmenu = {}
levelmenu.levelsPerLine=4

fntTitle = love.graphics.newFont("fonts/PrintChar21.ttf", 30)

function drawLabel(str,width,height,font)
  love.graphics.setFont(font)
  love.graphics.print(str,width,height)
end

function fromCenter(widthOff)
  return (canvasWidth-widthOff)/2
end

function levelmenu:resetSettings()
  love.graphics.setFont(fntDefault)
  love.graphics.setColor(255,255,255);
end

function levelmenu:enter()
  self:resetSettings();

  self.menuElement = {}
  self.menuElementCt=1;

  local str
  --str="Labyrinth"
  --addMenuElement(str,fromCenter(fntTitle:getWidth(str)),20,fntTitle:getWidth(str),fntTitle:getHeight(str),fntTitle)

  --str="Main Menu"
  --str = "SELECT YOUR LEVEL"
  --addMenuElement(str,fromCenter(fntDefault:getWidth(str)),55,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault)


  local x,ysizeX
    for y=0,2-1,1 do
  for x=0,self.levelsPerLine-1,1 do
      str=(y*self.levelsPerLine)+x+1
      self:addMenuElement(str,
        fromCenter(str)+((x-(self.levelsPerLine/2))*80)+40,
        180+(y*40),
        fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,self.Level,(y*self.levelsPerLine)+x+1)
    end
  end

  str="BONUS LEVELS"
  self:addMenuElement(str,300,canvasHeight-30,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,self.Level,999)

  str=" Back"
  self:addMenuElement(str,canvasWidth-300,canvasHeight-30,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,self.Quit)
end

levelmenu.menuElement = {}
levelmenu.menuElementCt=1;
levelmenu.menuElementActive=1
function levelmenu:addMenuElement(text,x,y,sx,sy,font,evt,info)
  local o={
    txt=text,
    font=font,
    posX=x,
    posY=y,
    sizeX=sx,
    sizeY=sy,
    event=evt,
    info=info,
    index=self.menuElementCt
  }

  self.menuElement[self.menuElementCt]=o
  self.menuElementCt=self.menuElementCt+1;
end

function levelmenu:testHit(posX,posY)
  for x=1,self.menuElementCt-1,1 do
    local v=self.menuElement[x]
    
    local off=5;
    if ((posX-v.posX>=-off) and (posX-v.posX<=v.sizeX+off) and (posY-v.posY>=-off) and (posY-v.posY<=v.sizeY+off)) then
      return v
    end
  end
  return nil
end

function levelmenu:renderMenuElement()
  love.graphics.setColor(255,255,255);

  local x
  for x=1,self.menuElementCt-1,1 do
    local v=self.menuElement[x]
    if x == self.menuElementActive then love.graphics.rectangle("line", v.posX-10, v.posY-10, v.sizeX+20, v.sizeY+20) end
    drawLabel(v.txt,v.posX,v.posY,v.font)
  end
end

function levelmenu:draw()
   draw_menu_bg()
   
   self:renderMenuElement()

   love.graphics.setFont(fntTitle)
   love.graphics.setColor(255,255,255);
   love.graphics.print("SELECT YOUR LEVEL", (canvasWidth-fntTitle:getWidth("SELECT YOUR LEVEL"))/2, 100)
end

levelmenu.lastx = 0   levelmenu.lasty = 0
function levelmenu:update(dt)
   local mousex,mousey = love.mouse.getX(), love.mouse.getY()
   if mousex == self.lastx and mousey == self.lasty then return end
   local hittest = self:testHit(mousex,mousey)
   if hittest ~= nil then self.menuElementActive = hittest.index end
   self.lastx = mousex      self.lasty = mousey
end

function levelmenu:onmenuevent(menuitem)
  if (menuitem~=nil) then
    if (menuitem.event~=nil) then
      menuitem.event(menuitem)
      --print(menuitem.txt)
    end
  end
end

function levelmenu:mousereleased()
  local h=self:testHit(love.mouse.getX(),love.mouse.getY())
  self:onmenuevent(h)
end

function levelmenu:keypressed(key)
   if key == " " or key == "return" then --space
      local h = self.menuElement[self.menuElementActive]
      self:onmenuevent(h)
   elseif key == "down" then
      self.menuElementActive = self.menuElementActive + self.levelsPerLine
      if self.menuElementActive > #self.menuElement then self.menuElementActive = #self.menuElement end
   elseif key == "up" then
      self.menuElementActive = self.menuElementActive - self.levelsPerLine
      if self.menuElementActive < 1 then self.menuElementActive = 1 end
   elseif key == "left" then
      self.menuElementActive = self.menuElementActive - 1
      if self.menuElementActive < 1 then self.menuElementActive = 1 end
   elseif key == "right" then
      self.menuElementActive = self.menuElementActive + 1
      if self.menuElementActive > #self.menuElement then self.menuElementActive = #self.menuElement end
   elseif key == "escape" then
      Gamestate.switch(mainmenu)
   end
end

--menu events

function levelmenu.Quit(button)
   Gamestate.switch(mainmenu)
end

function levelmenu.Level(button)
  local lvl=button.info

  Gamestate.switch(labyrinth,lvl)
end

