local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "a" and direction == "enter" then playerDied("Fall to death") end
   
   
   if mapchar == "y" then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth.show_map=true
      setTimeout(function() labyrinth.show_map = false end, 1)
      return " "
   end

   local rx=55
   local ry=14
   local rx2=49
   local ry2=25
   if mapchar == "x" then
      if direction=="enter" then
         fillMap(rx,ry,".")
         fillMap(rx2,ry2,".")
      else
         fillMap(rx,ry,"#")
      end
   end

   local yx=49
   local yy=23
   if mapchar == "y" then
      if direction=="enter" then
         fillMap(yx,yy,".")
         fillMap(yx,yy,".")
      else
         fillMap(yx,yy,"#")
      end
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
