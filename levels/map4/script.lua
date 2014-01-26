local maphandler = {}

function maphandler:onLoad()
   stepinterval = 0.1
   pushhelp("Only fields turning blue or red may be walked on, \nwhite fields will kill you.")
end

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "a" and direction == "enter" then playerDied("Fall to death") end

   local rx=55
   local ry=14
   local rx2=55
   local ry2=25
   if mapchar == "x" then
      if direction=="enter" then
         fillMap(rx,ry,".")
         fillMap(rx2,ry2,".")
      else
         fillMap(rx,ry,"#")
         fillMap(rx2,ry2,"#")
      end
   end

   local yx=55
   local yy=23
   if mapchar == "y" then
      if direction=="enter" then
         fillMap(yx,yy,".")
      else
         fillMap(yx,yy,"#")
      end
   end
   
end


maphandler.imagemap = {
   r = { lvlimg("whatsthis"), player="r", inactiveColor = {255,255,255,255} },
   b = { lvlimg("whatsthis"), player="b", inactiveColor = {255,255,255,255} },
   a = { lvlimg("whatsthis"),             }
}

maphandler.players = {
   { player = "red", x = 3, y = 30, directionvector = {1,0} },
   { player = "yellow", x = 5, y = 3, directionvector = {-1,0} },
   { player = "blue", x = 90, y = 15, directionvector = {0,-1} },
}

return maphandler
