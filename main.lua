
function love.load()
   io.stdout:setvbuf("no")
   
   love.keyboard.setKeyRepeat(true)
   love.window.setMode(1200, 600, {})

   darkener = love.graphics.newCanvas()
   
   CP = 1
   ScaleX = 10
   ScaleY = 10
   players = {
      { x = 40, y = 40, player = "red",
        form = {0, 0, 20, 0, 20, 20, 0, 20},
        color = {200, 50, 50} },
      { x = 80, y = 100, player = "yellow",
        form = {7,0,   14,0,   21,10,   14,20,   7,20,   0,10},
        color = {200, 250, 50} },
      { x = 120, y = 140, player = "blue",
        form = {10, 0, 20, 20, 0, 20},
        color = {50, 50, 250} }
   }
   
   objects = {
      {}
   }
   print("aaa")
   map = {}
   for line in love.filesystem.lines("map1.txt") do
      local mapline = {}
      for charr in string.gmatch(line, ".") do
         if charr == " " then
            table.insert(mapline, " ")
         else
            table.insert(mapline, ".")
         end
      end
      table.insert(map, mapline)
   end
   refreshDarkener()
end


function refreshDarkener()
   love.graphics.setCanvas(darkener)
   darkener:clear()
   love.graphics.setBlendMode('replace')
   love.graphics.setColor(0, 0, 0, 200)
   love.graphics.rectangle("fill", 0, 0, 1200, 600)
   for pl = 1, #players do
      love.graphics.setColor(255,255,255,0)
      love.graphics.circle("fill", players[pl].x, players[pl].y, 100)
   end
   love.graphics.setCanvas()
end

function love.draw()
   -- love.graphics.print("Hello World", 400, 300)
   love.graphics.setBlendMode('alpha')

   love.graphics.setColor(55,55,55)
   for y=1, #map do
      for x=1, #map[y] do
         if map[y][x] == "." then
            love.graphics.rectangle("fill", x * ScaleX, y * ScaleY, ScaleX, ScaleY)
         end
      end
   end
   
   for i = 1, 3, 1 do
      local pl = players[i]
      love.graphics.translate(pl.x, pl.y)
      love.graphics.setColor(pl.color)
      love.graphics.polygon("fill", pl.form)
      if i == CP then
         love.graphics.setColor(255,255,255)
         love.graphics.polygon("line", pl.form)
      end
      love.graphics.translate(-pl.x, -pl.y)
   end
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(darkener)
end


function testMap(x, y)
    if map[y][x] == "." or map[y+1][x] == "." or map[y+1][x+1] == "." or map[y][x+1] == "."  then
        return false
    end
    return true
end

function movePlayer(idx, dX, dY)
   mapX = players[idx].x / ScaleX
   mapY = players[idx].y / ScaleY
   if testMap(mapX + dX, mapY + dY) == false then return false end
   players[idx].x = players[idx].x + (dX * ScaleX)
   players[idx].y = players[idx].y + (dY * ScaleY)
   refreshDarkener()
   return true
end

function love.keypressed(key)
   if key == "up" then
      movePlayer(CP, 0, -1)
   elseif key == "down" then
      movePlayer(CP, 0, 1)
   elseif key == "left" then
      movePlayer(CP, -1, 0)
   elseif key == "right" then
      movePlayer(CP, 1, 0)
   elseif key == " " then --space
      CP = CP + 1
      if CP > 3 then CP = 1 end
   end
end
