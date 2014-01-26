local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   if mapchar == "k" and direction == "enter" then
      fillMap(40,14, "#")
   end
   if mapchar == "l" and direction == "enter" then
      fillMap(40,14, ".")
   end
end

maphandler.imagemap = {
   a = { imgTrigger },
   r = { imgStar, player="r", inactiveColor = {111,111,111} },
   y = { imgStar, player="y", inactiveColor = {111,111,111} },
   b = { imgStar, player="b", inactiveColor = {111,111,111} },
   k = { love.graphics.newImage(levelFolder.."map2_k.png") }
}

maphandler.players = {
   { player = "red", x = 3, y = 3, directionvector = {1,0} },
   { player = "yellow", x = 30, y = 3, directionvector = {-1,0} },
   { player = "blue", x = 3, y = 15, directionvector = {0,-1} },
}

return maphandler
