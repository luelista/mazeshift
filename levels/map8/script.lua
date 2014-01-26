local maphandler = {}


local levelBarCt={}
function maphandler:onLoad()
   levelBarCt={}
end

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   if mapchar == "a" and direction == "enter" then

      local ct=0
      for k,v in pairs(levelBarCt) do
          ct=ct+1
      end

      if ct==2 then
         fillMap(11,22, "Z")
      else
         levelBarCt[player.player]=1
      end
   end
   if mapchar == "b" and direction == "enter" then
      fillMap(12,12, "Z")
   end
   if mapchar == "z" and direction == "enter" then
      fillMap(40,16, ".")
      fillMap(43,16, ".")

      fillMap(41,15, "J")
      fillMap(41,18, "J")
   end

   if mapchar == "s" then
      if direction == "enter" then
         fillMap(41, 9, "B")
         fillMap(41,13, "Y")
      else
         fillMap(41, 9, "Y")
         fillMap(41,13, "B")
      end
   end
end

maphandler.imagemap = {
   a = { imgTrigger },
   b = { imgTrigger },
   z = { imgTrigger },
   s = { imgTrigger },

   A = { lvlimg("b1Wall") },
   J = { lvlimg("b1WallR") },
   Z = { lvlimg("b2SpaceWall") },
}

maphandler.players = {
   { player = "red"   , x = 10, y = 25, directionvector = {0,-1} },
   { player = "yellow", x = 13, y = 25, directionvector = {0,-1} },
   { player = "blue"  , x = 16, y = 25, directionvector = {0,-1} },
}

return maphandler
