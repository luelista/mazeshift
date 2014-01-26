local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   if mapchar == "k" and direction == "enter" then
      fillMap(40,14, "#")
   end
   if mapchar == "l" and direction == "enter" then
      fillMap(40,14, ".")
   end
   if mapchar == "m" and direction == "enter" then
      fillMap(50,11,".")
   end
   if mapchar == "m" and direction == "leave" then
      fillMap(50,11,"#")
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
   { player = "red", x = 6, y = 16, directionvector = {1,0} },
   { player = "yellow", x = 6, y = 23, directionvector = {1,0} },
   { player = "blue", x = 6, y = 31, directionvector = {1,0} },
}

return maphandler
