local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "a" and direction == "enter" then playerDied("Fall to death") end
   
   
   if mapchar == "y" then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth.show_map=true
      setTimeout(function() labyrinth.show_map = false end, 1)
      return " "
   end

   local rx=13
   local ry=55
   local rx2=49
   local ry2=25
   if maphandler == "x" then
      if direction=="enter" then
         mapFill(rx,ry,"g")
         mapFill(rx2,ry2,"g")
      else
         mapFill(rx,ry,"#")
      end
   end

   local yx=49
   local yy=23
   if maphandler == "y" then
      if direction=="enter" then
         mapFill(yx,yy,"g")
         mapFill(yx,yy,"g")
      else
         mapFill(yx,yy,"#")
      end
   end
   
end

maphandler.imagemap = {
   r = { imgStar, player="r", inactiveColor = {111,111,111,111} },
   b = { imgStar, player="b", inactiveColor = {111,111,111,111} },
   a = { imgStar,             }
}

maphandler.players = {
   { player = "red", x = 3, y = 30, directionvector = {1,0} },
   { player = "yellow", x = 5, y = 3, directionvector = {-1,0} },
   { player = "blue", x = 90, y = 15, directionvector = {0,-1} },
}

return maphandler
