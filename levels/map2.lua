local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   if mapchar == "k" and direction == "enter" then
      fillMap(40,15, "#")
   end
end

maphandler.imagemap = {
   a = imgTrigger,
   k = love.graphics.newImage("levels/map2_k.png")
}

return maphandler
