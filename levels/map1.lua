local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "t" and direction == "enter" then playerDied() end
   
   
   if mapchar == "y" then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth.show_map=true
      setTimeout(function() labyrinth.show_map = false end, 1)
      return " "
   end
   
end

maphandler.imagemap = {
   r = { imgStar, consume = true, player="r", inactiveColor = {111,111,111,111} },
   y = { imgStar, consume = true, player="y", inactiveColor = {111,111,111,111} },
   b = { imgStar, consume = true, player="b", inactiveColor = {111,111,111,111} },
   t = { love.graphics.newImage("images/death.png"), player="r", inactiveColor = {0,0,0,0} }
}

maphandler.players = {
   { player = "red", x = 3, y = 3, directionvector = {1,0} },
   { player = "yellow", x = 30, y = 3, directionvector = {-1,0} },
   { player = "blue", x = 3, y = 15, directionvector = {0,-1} },
}

return maphandler
