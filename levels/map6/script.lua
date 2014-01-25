local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   
   if direction == "enter" then
      labyrinth:credit(100)
   end
   
end

maphandler.players = {
   { player = "blue", x = 2, y = 2, directionvector = {1,1} }
}

maphandler.imagemap = {
   p = { love.graphics.newImage(levelFolder.."map5_p.png"), consume = true }
}


return maphandler
