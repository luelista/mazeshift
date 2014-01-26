-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

labyrinth = {}
labyrinth.current_level = nil

fntHuge = love.graphics.newFont(fontFilename, 48)

labyrinth.credits = 100

levelFolder=nil
function labyrinth:enter(oldstate, level)
   if level == nil then return end
   
   labyrinth.current_level = level
   labyrinth.stopgame = false
   
   labyrinth.state = "play"
   
   levelFolder="levels/map" .. level .. "/"
   if love.filesystem.exists(levelFolder.."map.txt") == false then
      Gamestate.switch(most_epic_win)
      return
   end
   
   playtimesec = 0
   cherrysfound = 0 cherrystotal = 0 livesremaining = 3
   hugeoverlay = ""
   
   darkener = love.graphics.newCanvas()
   mapcanvas = love.graphics.newCanvas()
   
   imgCherry = love.graphics.newImage("images/cherry.png")
   imgStar = love.graphics.newImage("images/star.png")
   imgTrigger = love.graphics.newImage("images/trigger.png")
   imgLife = love.graphics.newImage("images/life.png")
   imgViewangle = love.graphics.newImage("images/viewangle.png")
   
   sndCredit = love.audio.newSource("sound/square-sweep-up.wav", "static")
   sndEpicWin = love.audio.newSource("sound/square-fanfare.wav", "static")
   
   if (love.filesystem.exists(levelFolder.."bg.png")) then
      levelBg=love.graphics.newImage(levelFolder.."bg.png")
      levelBg:setWrap("repeat", "repeat")
      levelBgQuad = love.graphics.newQuad( 0,0, canvasWidth,canvasHeight, levelBg:getWidth(),levelBg:getHeight() )
   else
      levelBg=nil
   end

   CP = 1
   ScaleX = 10
   ScaleY = 10
   default_players = {
      red = { player = "r", speed = 50,
        form = {0, 0, 20, 0, 20, 20, 0, 20},
        color = {200, 50, 50}, objectcanvas = love.graphics.newCanvas() },

      yellow = { player = "y", speed = 50,
        form = {7,0,   14,0,   21,10,   14,20,   7,20,   0,10},
        color = {200, 250, 50}, objectcanvas = love.graphics.newCanvas() },

      blue = { player = "b", speed = 50,
        form = {0, 0, 0, 20, 20, 10},
        color = {50, 50, 250}, objectcanvas = love.graphics.newCanvas() }
   }
   
   print("Hello, World!")
   map = {}
   for line in love.filesystem.lines(levelFolder.."map.txt") do
      local mapline = {}
      for charr in string.gmatch(line, ".") do
         table.insert(mapline, charr)
         if charr == "c" then cherrystotal = cherrystotal + 1 end
      end
      table.insert(map, mapline)
   end

   mapScript=require(levelFolder.."script")
   if (mapScript==nil) then
      mapScript={}
   end

   darkeneralpha = 150
   stepinterval = 0.05
   
   levelhelp = {}
   levelhelpalpha = 0
   
   if (mapScript.onLoad~=nil) then
      mapScript:onLoad()
   end
   
   print("stepinterval:",stepinterval)
   
   resetPlayers()
   refreshDarkener()
   refreshMap()
end


function pushhelp(txt)
   table.insert(levelhelp, txt)
   labyrinth.stopgame = true
end

function lvlimg(nam)
   return love.graphics.newImage(levelFolder..nam..".png")
end

function labyrinth:credit(num)
   self.credits = self.credits + num
   
end

function resetPlayer(i)
   local player = players[i]
   player.directionvector = mapScript.players[i].directionvector 
   player.tx = mapScript.players[i].x 
   player.ty = mapScript.players[i].y 

   player.direction=0.5-math.atan2(player.directionvector[1],player.directionvector[2]) / math.pi
end

function resetPlayers()
   players = {}
   for i=1,#mapScript.players do
      local player = default_players[mapScript.players[i].player]
      
      player.directionvector = mapScript.players[i].directionvector 
      player.tx = mapScript.players[i].x 
      player.ty = mapScript.players[i].y 
      
      player.direction=0.5-math.atan2(player.directionvector[1],player.directionvector[2]) / math.pi
      
      table.insert(players, player)
   end
end



function refreshDarkener()
   love.graphics.setCanvas(darkener)
   darkener:clear()
   love.graphics.setBlendMode('alpha')
   love.graphics.setColor(0, 0, 0, darkeneralpha)
   love.graphics.rectangle("fill", 0, 0, 1200, 600)
   love.graphics.setBlendMode('multiplicative')
   for pl = 1, #players do
      love.graphics.setColor(255,255,255,255)
      --love.graphics.circle("fill", players[pl].x, players[pl].y, 100)
      local p = players[pl]
      local px = (p.tx+1-p.directionvector[1])*ScaleX
      local py = (p.ty+1-p.directionvector[2])*ScaleY
      --love.graphics.arc("fill", px, py, 140, (p.direction-0.25)*math.pi, (p.direction+0.25)*math.pi)
      love.graphics.draw(imgViewangle, p.tx*ScaleX+ScaleX, p.ty*ScaleY,  (p.direction-0.25)*math.pi, 1, 1, 30, 30)
      p.stencil = function()
         love.graphics.arc("fill", px, py, 220, (p.direction-0.25)*math.pi, (p.direction+0.25)*math.pi)
      end
   end
   love.graphics.setCanvas()
   love.graphics.setBlendMode('alpha')
end

function refreshMap()
   love.graphics.setCanvas(mapcanvas)
   love.graphics.setColor(255,255,255)
   mapcanvas:clear()

   if (levelBg~=nil) then
      love.graphics.draw(levelBg, levelBgQuad, 0,0, 0, 1,1);
   end

   for i=1, #players do players[i].objectcanvas:clear() end
   
   for y=1, #map do
      for x=1, #map[y] do
         --love.graphics.setColor(0,255,0)
         --love.graphics.rectangle("fill", x*ScaleX, y*ScaleY, 1, 1)
         if map[y][x] == "." or (map[y][x] == "#" and labyrinth.disable_hittest) then
            love.graphics.setColor(99,99,99)
            love.graphics.rectangle("line", x * ScaleX, y * ScaleY, ScaleX, ScaleY)
         elseif map[y][x] == "#" then
            love.graphics.setColor(99,99,99)
            love.graphics.rectangle("fill", x * ScaleX, y * ScaleY, ScaleX, ScaleY)
         elseif map[y][x] == "c" then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(imgCherry, x * ScaleX, y * ScaleY)
         elseif map[y][x] == "R" or map[y][x] == "Y" or map[y][x] == "B" then
            love.graphics.setColor(111,111,111)
            love.graphics.rectangle("fill", (x) * ScaleX, (y) * ScaleY, ScaleX, ScaleY)
            for i = 1, #players do if map[y][x] == players[i].player:upper() then
                  love.graphics.setCanvas(players[i].objectcanvas) love.graphics.setColor(players[i].color)
                  love.graphics.rectangle("fill", (x) * ScaleX+1, (y) * ScaleY+1, ScaleX-2, ScaleY-2)
                  love.graphics.setCanvas(mapcanvas)
            end end
         elseif string.match(map[y][x], "[a-z]") then
            
            local img = mapScript.imagemap[map[y][x]]
            if img == nil then img = { imgTrigger } end
            if img.inactiveColor == nil then love.graphics.setColor(255,255,255) else  love.graphics.setColor(img.inactiveColor) end
            
            love.graphics.draw(img[1], x * ScaleX, y * ScaleY)
            if img.player ~= nil then
               for i = 1, #players do if img.player == players[i].player:sub(1,1) then
                     love.graphics.setCanvas(players[i].objectcanvas) love.graphics.setColor(players[i].color)
                     love.graphics.draw(img[1], (x) * ScaleX, (y) * ScaleY)
                     love.graphics.setCanvas(mapcanvas)
               end end
            end
         end
      end
   end
   love.graphics.setCanvas()
end


function labyrinth:draw()
   -- love.graphics.print("Hello World", 400, 300)
   love.graphics.setBlendMode('alpha')

   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(mapcanvas)

   for i = 1, #players do
      local pl = players[i]
      if not labyrinth.show_map then love.graphics.setStencil(pl.stencil) end
      love.graphics.draw(pl.objectcanvas)
      love.graphics.setStencil()
   end
   
   if not labyrinth.show_map then
      love.graphics.draw(darkener)
   end

   for i = 1, #players do
      local pl = players[i]
      love.graphics.push()
      --
      love.graphics.translate((1+pl.tx)*ScaleX, (1+pl.ty)*ScaleY)
      love.graphics.rotate(pl.direction*math.pi)
      love.graphics.translate(-ScaleX, -ScaleY)
      love.graphics.setColor(pl.color)
      love.graphics.polygon("fill", pl.form)
      if i == CP then
         love.graphics.setColor(255,255,255)
         love.graphics.polygon("line", pl.form)
      end
      love.graphics.pop()
   end
   
   if hugeoverlay ~= "" then
      drawHugeoverlay()
   end
   
   if #levelhelp > 0 then
      drawLevelhelp()
   end
   
   printInfobar()
end

overlayalpha = 0
function drawHugeoverlay()
   love.graphics.setColor(255,255,255,math.min(overlayalpha,255))
   love.graphics.setFont(fntHuge)
   love.graphics.print(hugeoverlay, (canvasWidth-fntHuge:getWidth(hugeoverlay))/2, canvasHeight/2-45)
   love.graphics.setFont(fntTitle)
   love.graphics.print(hugeoverlay2, (canvasWidth-fntTitle:getWidth(hugeoverlay2))/2, canvasHeight/2+40)
end

function setHugeoverlay(text, text2, timeout)
   overlayalpha = 0
   hugeoverlay = text   hugeoverlay2 = text2
   function hugeoverlayincrease() 
      overlayalpha = overlayalpha + 2
      if overlayalpha < 255 then setTimeout(hugeoverlayincrease, 0.01) end
   end
   setTimeout(hugeoverlayincrease, 0.02)
   if timeout ~= nil then
      function hugeoverlaydecrease() 
         overlayalpha = overlayalpha - 10
         if overlayalpha > 0 then setTimeout(hugeoverlaydecrease, 0.01) else hugeoverlay = "" end
      end
      setTimeout(hugeoverlaydecrease, timeout)
   end
end

function drawLevelhelp()
   love.graphics.setColor(0,0,0,255)
   love.graphics.setFont(fntTitle)
   love.graphics.print(levelhelp[1], (canvasWidth-fntTitle:getWidth(levelhelp[1]))/2, canvasHeight-130)
   love.graphics.setFont(fntDefault)
   love.graphics.print("press  to hide message", canvasWidth-340, canvasHeight-80)
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.setFont(fntTitle)
   love.graphics.print(levelhelp[1], (canvasWidth-fntTitle:getWidth(levelhelp[1]))/2+2, canvasHeight-130+2)
   love.graphics.setFont(fntDefault)
   love.graphics.print("press  to hide message", canvasWidth-340+2, canvasHeight-80+2)
   
end

function playerDied(msg)
   livesremaining = livesremaining - 1
   if livesremaining > 0 then
      if msg == nil then msg = "YOU WERE KILLED" end
      setHugeoverlay(msg, livesremaining .. " live(s) remaining", 1.5)
      local pl = CP
      labyrinth.stopgame = true
      setTimeout(function() resetPlayer(pl) labyrinth.stopgame = false end, 1.5)
   else
      setHugeoverlay("GAME OVER", "press SPACE to try again")
      labyrinth.stopgame = true  labyrinth.state = "dead"  labyrinth.credits = 100
   end
end

function printInfobar()
   local top = canvasHeight - 20
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.setFont(fntDefault)
   love.graphics.print(string.format("%d:%02d", math.floor(playtimesec/60), math.floor(playtimesec%60)), 10, top)
   
   love.graphics.draw(imgCherry, 70, top-2)
   love.graphics.print(string.format("%d / %d", cherrysfound, cherrystotal), 100, top)

   love.graphics.print(string.format("Level %03d", labyrinth.current_level), 240, top)
   
   love.graphics.draw(imgLife, 395, top-4)
   love.graphics.print(string.format("%02d", livesremaining), 420, top)
   
   love.graphics.setColor(255,244,155,255)
   love.graphics.draw(imgStar, 580, top-4)
   love.graphics.print(string.format("%05d", labyrinth.credits), 605, top)
end

function onCollision(idx, firstColl, cx, cy)
   if firstColl == "c" then
      --players[idx].colliding = firstColl
      sndBackgroundmusic:pause()
      cherrysfound = cherrysfound + 1
      if cherrysfound == cherrystotal then
         setHugeoverlay("EPIC WIN!", "  press SPACE for next level\n\npress ESCAPE to return to menu")
         labyrinth.stopgame = true   labyrinth.state = "win"
         sndBackgroundmusic:pause()
         sndEpicWin:setVolume(2)
         sndEpicWin:play()
      else
         sndCredit:play()
      end
      return " "
   end
   
   players[idx].collision = firstColl
   players[idx].collisionX = cx  players[idx].collisionY = cy
   if mapScript.imagemap ~= nil and mapScript.imagemap[firstColl] ~= nil and mapScript.imagemap[firstColl].consume and (mapScript.imagemap[firstColl].player == nil or players[idx].player == mapScript.imagemap[firstColl].player) then return " " end

   return firstColl
end


function onCheckCollision9(idx)
   local searchOn = {-1,-1, 0,-1, 1,-1,   -1,0, 0,0, 1,0,   -1,1, 0,1, 1,1}
   for i = 1, #searchOn-1, 2 do
      local cy, cx = players[idx].ty + searchOn[i], players[idx].tx + searchOn[i+1]
      coll = map[cy][cx]
      if string.match(coll, "[a-z]") then
         if coll ~= " " then
            res = onCollision(idx, coll, cx, cy)
            map[cy][cx] = res
            refreshMap()
            return
         end
      end
   end
end

-- returns '#' if any element is '#', otherwise returns first non-space, otherwise returns space
function testMap(x, y, player)
   if y < 1 or y >= #map or x < 1 or x >= #map[y] then return false end
   if labyrinth.disable_hittest then return true end
   
   coll = { map[y][x], map[y+1][x], map[y+1][x+1], map[y][x+1] }
   res = " "
   for i = 1, #coll do
      if coll[i] == "#" then return false end
      if coll[i] ~= " " then res = coll[i] end
   end

   return (not (string.match(res, "[A-Z]") ~= nil and res:lower() ~= player.player))
end

function fillMap(px,py,char,oldChar)
   if char == oldChar then return end
   local ref=false
   if (oldChar==nil) then
      oldChar=map[py][px]
      ref=true
   end

   if (map[py][px]==oldChar) then map[py][px]=char else return end

   if (px~=1) then fillMap(px-1, py, char, oldChar) end
   if (px~=#map[py]) then fillMap(px+1, py, char, oldChar) end

   if (py~=1) then fillMap(px, py-1, char, oldChar) end
   if (py~=#map) then fillMap(px, py+1, char, oldChar) end

   if (ref) then
      refreshMap()
      killOnHit()
   end
end

function killOnHit()
   local i
   for i=1,#players do
      local x=testMap(players[i].tx, players[i].ty,players[i])
      if (x==false) then
         CP=i
         playerDied("YOU WERE WALLED IN")
      end
   end
end

function round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num * mult + 0.5) / mult
end

function movePlayer(idx, dX, dY)
   local p = players[idx]
   local newX = p.tx + dX
   local newY = p.ty + dY
   local validPos = testMap(math.floor(newX), math.floor(newY),p)
   
   if (not validPos) then
      if dX ~= 0 then p.tx = round(p.tx, 0) else p.ty = round(p.ty, 0) end
      return false
   end
   
   players[idx].tx = newX
   players[idx].ty = newY
   return true
end

timerinterval = 0
function labyrinth:update(dt)
   if labyrinth.stopgame then return end
   --print(dt)
   timerinterval = timerinterval + dt
   playtimesec = playtimesec + dt
   if timerinterval > stepinterval then
      timerinterval = timerinterval % stepinterval
      
      local dx,dy=0,0
      if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
         dy = dy - 1
      end
      if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
         dy = dy + 1
      end
      if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
         dx = dx - 1
      end
      if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
         dx = dx + 1
      end
      if dx ~= 0 or dy ~= 0 then
         movePlayer(CP, dx, 0)
         movePlayer(CP, 0, dy)
         local pl = players[CP]
         pl.direction = 0.5-(math.atan2(dx, dy)/math.pi)
         pl.directionvector = {dx,dy}
         
         local old_col, old_cx, old_cy = pl.collision, pl.collisionX, pl.collisionY
         pl.collision = " "
         onCheckCollision9(CP)
         print(old_col , pl.collision)
         if (old_col ~= pl.collision or old_x ~= pl.collisionX or old_y ~= pl.collisionY) then
            if (old_col ~= " ") then
               mapScript:onCollision("leave",old_col,pl,pl.tx,pl.ty,CP)
            end
            if pl.collision ~= " " then
               mapScript:onCollision("enter",pl.collision,pl,pl.tx,pl.ty,CP)
            end
         end
         
         refreshDarkener()
         --print(math.atan2(dx,dy), math.atan2(dy,dx))  
      end
   end
end

function labyrinth:keypressed(key)
   print(labyrinth.stopgame,livesremaining,labyrinth.current_level)
   if labyrinth.state ~= "play" and (key == " " or key == "return") then
      if labyrinth.state == "dead" then labyrinth:enter("labyrinth",labyrinth.current_level) 
      elseif labyrinth.state == "win" then labyrinth:enter("labyrinth",labyrinth.current_level + 1) end
      return
   end
   
   if key == " " then --space
      CP = CP + 1
      if CP > #players then CP = 1 end
   elseif key == "1" then
      CP = 1
   elseif key == "2" and #players >= 2 then
      CP = 2
   elseif key == "3" and #players >= 3 then
      CP = 3
   elseif key == "4" and #players >= 4 then
      CP = 4
   elseif key == "5" and #players >= 5 then
      CP = 5
   elseif key == "r" then
      labyrinth:enter()
   elseif key == "b" then
      if #levelhelp > 0 then table.remove(levelhelp, 1)  if #levelhelp == 0 then labyrinth.stopgame = false end   end
   elseif key == "up" or key == "down" or key == "left" or key == "right" then
      timerinterval = stepinterval
   elseif key == "escape" then
      Gamestate.switch(pause)
   end
end

