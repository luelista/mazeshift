local maphandler = {}

local p2x=41
local p2y=27

local p3x=90
local p3y=7

function maphandler:onLoad()
   stepinterval = 0.1
   darkeneralpha=255
   levelhelpblocks=false

   displayedihint=false
   displayedjhint=false

   pushhelp("Welcome to MazeShift!\nUse WASD or the arrow keys to move your character")
   players[2].enabled=false
   players[3].enabled=false
end

function enableBlue()
   players[2].enabled=true
   fillMap(p2x,p2y," ")
end

function enableYellow()
   players[3].enabled=true
   fillMap(p3x,p3y," ")
end

displayedihint=false
displayedjhint=false
function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "a" and direction == "enter" then playerDied("Fall to death") end

   if not displayedihint and mapchar == "i" and direction=="enter" then
      displayedihint=true
      
      unshifthelp()
      pushhelp("Look, a new player!\nTry to get him out of his prison")
   end

   if not displayedjhint and mapchar == "j" and direction=="enter" then
      displayedjhint=true
      
      unshifthelp()
      pushhelp("Look at these gray walls, only players with the matching\ncolor can see and pass through them.")
   end

   if mapchar == "x" and direction=="enter" then
      enableBlue()
      fillMap(40,23,".")

      unshifthelp()
      pushhelp("Use SPACE or \"2\" to switch to your new player")
   end

   if mapchar == "y" and direction=="enter" then
      enableYellow()
      fillMap(85,6,".")

      unshifthelp()
      pushhelp("You unlocked player 3!")
   end

end


maphandler.imagemap = {
   s = { lvlimg("bluey") , inactiveColor = {255,255,255,255} },
   t = { lvlimg("greeny"), inactiveColor = {255,255,255,255} },
   Z = { lvlimg("b2SpaceWall") },
   i = { lvlimg("transparent") },
   j = { lvlimg("transparent") },
   --b = { lvlimg("whatsthis"), player="b", inactiveColor = {255,255,255,255} },
   --a = { lvlimg("whatsthis"),             }
}

maphandler.players = {
   { player = "red" , x = 8, y = 6, directionvector = {1,0} },
   { player = "blue", x = p2x, y = p2y, directionvector = {1,0} },
   { player = "yellow", x = p3x, y = p3y, directionvector = {0,-1} }
}

return maphandler
