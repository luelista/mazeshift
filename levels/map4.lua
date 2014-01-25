local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "a" and direction == "enter" then playerDied("Fall to death") end
   
   
   if mapchar == "y" then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth.show_map=true
      setTimeout(function() labyrinth.show_map = false end, 1)
      return " "
   end
   
end

maphandler.imagemap = {
   r = { imgStar, player="r", inactiveColor = {255,255,255,255} },
   b = { imgStar, player="b", inactiveColor = {255,255,255,255} },
   a = { imgStar,             }
}

maphandler.players = {
   { player = "red", x = 3, y = 30, directionvector = {1,0} },
   { player = "yellow", x = 5, y = 3, directionvector = {-1,0} },
   { player = "blue", x = 90, y = 15, directionvector = {0,-1} },
}

return maphandler
