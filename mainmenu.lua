
mainmenu = {}

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
  str="Labyrinth"
  addMenuElement(str,fromCenter(fntTitle:getWidth(str)),20,fntTitle:getWidth(str),fntTitle:getHeight(str),fntTitle)

  str="Main Menu"
  addMenuElement(str,fromCenter(fntDefault:getWidth(str)),55,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault)

  str="Start"
  addMenuElement(str,fromCenter(fntDefault:getWidth(str)),100,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuLevel,1)
  
  str="Levels"
  addMenuElement(str,fromCenter(fntDefault:getWidth(str)),180,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault)

  str="Toogle Sound: ON"
  addMenuElement(str,fromCenter(800),canvasHeight-70,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuToogleMusic)

  str="Toogle Fullscreen: OFF"
  addMenuElement(str,fromCenter(700),canvasHeight-40,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuToogleFullscreen)


  str="Exit"
  addMenuElement(str,canvasWidth-300,canvasHeight-30,fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuQuit)

  local x,ysizeX
  for x=0,9-1,1 do
    for y=0,2-1,1 do
      str=(y*9)+x+1
      addMenuElement(str,
        fromCenter(str)+((x-4)*80),
        220+(y*40),
        fntDefault:getWidth(str),fntDefault:getHeight(str),fntDefault,menuLevel,(y*9)+x+1)
    end
  end
end

menuElement = {}
menuElementCt=1;
function addMenuElement(text,x,y,sx,sy,font,evt,info)
  local o={
    txt=text,
    font=font,
    posX=x,
    posY=y,
    sizeX=sx,
    sizeY=sy,
    event=evt,
    info=info
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
    drawLabel(v.txt,v.posX,v.posY,v.font)
  end
end

function mainmenu:draw()
  love.graphics.setColor(255,0,0);
  love.graphics.circle( "fill", canvasWidth/4*1, canvasHeight/5*4, canvasWidth/5, canvasHeight/5)
  
  love.graphics.setColor(255,255,0);
  love.graphics.circle( "fill", canvasWidth/1*1, canvasHeight/1*0, canvasWidth/4, canvasHeight/4)
  
  love.graphics.setColor(0,0,255);
  love.graphics.circle( "fill", canvasWidth/3*2, canvasHeight/3*2, canvasWidth/8, canvasHeight/8)

  renderMenuElement()
end


function mainmenu:mousereleased()
  local h=testHit(love.mouse.getX(),love.mouse.getY())

  if (h~=nil) then
    if (h.event~=nil) then
      h.event(h)
      print(h.txt)
    end
  end
end

function mainmenu:keypressed(key)
   if key == " " then --space
      Gamestate.switch(labyrinth)
   elseif key == "escape" then
      love.event.quit()
   end
end

--menu events

function menuQuit(button)
  love.event.quit()
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