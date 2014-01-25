-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

function love.load()
   io.stdout:setvbuf("no")
   
   love.keyboard.setKeyRepeat(true)
   love.window.setMode(1024, 600, {})

   darkener = love.graphics.newCanvas()
   mapcanvas = love.graphics.newCanvas()
   
   imgCherry = love.graphics.newImage("cherry.png")
   imgStar = love.graphics.newImage("star.png")
   
   CP = 1
   ScaleX = 10
   ScaleY = 10
   players = {
      { tx = 3, ty = 3, player = "red", direction = 0.5, speed = 50,
        form = {0, 0, 20, 0, 20, 20, 0, 20},
        color = {200, 50, 50}, objectcanvas = love.graphics.newCanvas() },
      { tx = 50, ty = 15, player = "yellow", direction = 1, speed = 50,
        form = {7,0,   14,0,   21,10,   14,20,   7,20,   0,10},
        color = {200, 250, 50}, objectcanvas = love.graphics.newCanvas() },
      { tx = 7, ty = 46, player = "blue", direction = 1.5, speed = 50,
        form = {10, 0, 20, 20, 0, 20},
        color = {50, 50, 250}, objectcanvas = love.graphics.newCanvas() }
   }

   print("Hello, World!")
   map = {}
   for line in love.filesystem.lines("map1.txt") do
      local mapline = {}
      for charr in string.gmatch(line, ".") do
         table.insert(mapline, charr)
      end
      table.insert(map, mapline)
   end
   refreshDarkener()
   refreshMap()
end


function refreshDarkener()
   love.graphics.setCanvas(darkener)
   darkener:clear()
   love.graphics.setBlendMode('replace')
   love.graphics.setColor(0, 0, 0, 230)
   love.graphics.rectangle("fill", 0, 0, 1200, 600)
   for pl = 1, #players do
      love.graphics.setColor(255,255,255,20)
      --love.graphics.circle("fill", players[pl].x, players[pl].y, 100)
      local p = players[pl]
      love.graphics.arc("fill", (p.tx+1)*ScaleX, (p.ty+1)*ScaleY, 140, (p.direction-0.25)*math.pi, (p.direction+0.25)*math.pi)
   end
   love.graphics.setCanvas()
end

function refreshMap()
   love.graphics.setCanvas(mapcanvas)
   mapcanvas:clear()
   for i=1, #players do players[i].objectcanvas:clear() end
   
   for y=1, #map do
      for x=1, #map[y] do
         if map[y][x] == "#" then
            love.graphics.setColor(99,99,99)
            love.graphics.rectangle("fill", x * ScaleX, y * ScaleY, ScaleX, ScaleY)
         end
         if map[y][x] == "c" then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(imgCherry, x * ScaleX, y * ScaleY)
         end
         if map[y][x] == "r" or map[y][x] == "y" or map[y][x] == "b" then
            love.graphics.setColor(111,111,111)
            love.graphics.draw(imgStar, (x+0.5) * ScaleX, (y+0.5) * ScaleY)
            for i = 1, #players do if map[y][x] == players[i].player:sub(1,1) then
                  love.graphics.setCanvas(players[i].objectcanvas) love.graphics.setColor(players[i].color)
                  love.graphics.draw(imgStar, (x+0.5) * ScaleX, (y+0.5) * ScaleY)
                  love.graphics.setCanvas(mapcanvas)
            end end
         end
      end
   end
   love.graphics.setCanvas()
end

function love.draw()
   -- love.graphics.print("Hello World", 400, 300)
   love.graphics.setBlendMode('alpha')

   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(mapcanvas)
   love.graphics.draw(darkener)

   for i = 1, 3, 1 do
      local pl = players[i]
      love.graphics.translate(pl.tx*ScaleX, pl.ty*ScaleY)
      love.graphics.setColor(pl.color)
      love.graphics.polygon("fill", pl.form)
      if i == CP then
         love.graphics.setColor(255,255,255)
         love.graphics.polygon("line", pl.form)
      end
      love.graphics.translate(-pl.tx*ScaleX, -pl.ty*ScaleY)
   end
   
end


function testMap(x, y)
   if map[y][x] == "#" or map[y+1][x] == "#" or map[y+1][x+1] == "#" or map[y][x+1] == "#"  then
      return false
   end
   return true
end
function round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num * mult + 0.5) / mult
end
function movePlayer(idx, dX, dY)
   newX = players[idx].tx + dX
   newY = players[idx].ty + dY
   if testMap(math.floor(newX), math.floor(newY)) == false then
      if dX ~= 0 then players[idx].tx = round(players[idx].tx, 0) else players[idx].ty = round(players[idx].ty, 0) end
      return false
   end
   players[idx].tx = newX
   players[idx].ty = newY
   return true
end

timerinterval = 0
function love.update(dt)
   timerinterval = timerinterval + dt
   if timerinterval > 0.05 then
      timerinterval = timerinterval - 0.05
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
         refreshDarkener()
         players[CP].direction = 0.5-(math.atan2(dx, dy)/math.pi)
         print(math.atan2(dx,dy), math.atan2(dy,dx))
      end
   end
end

function love.keypressed(key)
   if key == " " then --space
      CP = CP + 1
      if CP > 3 then CP = 1 end
   elseif key == "escape" then
      love.event.quit()
   end
end

