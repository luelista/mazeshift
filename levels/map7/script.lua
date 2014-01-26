local maphandler = {}

function maphandler:onLoad()
   stepinterval = 0.1

   darkeneralpha=255
   pushhelp("use wasd or arrow key to move")

   players[2].enabled=false
   players[3].enabled=false
   
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
   { player = "blue", x = 8, y = 6, directionvector = {1,0} },
   { player = "red", x = 77, y = 8, directionvector = {1,0} },
   { player = "yellow", x = 41, y = 22, directionvector = {0,-1} }
}

return maphandler
