local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
end

maphandler.imagemap = {
   a = imgTrigger,
   k = love.graphics.newImage("levels/map2_k.png")
}

return maphandler
