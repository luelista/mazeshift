local maphandler = {}

function maphandler:onCollision(self, direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
end


return maphandler
