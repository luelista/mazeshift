-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ../.."; -*-

local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   
   if direction == "enter" and (mapchar == "r" or mapchar == "y" or mapchar == "b") and player.player == mapchar then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth:credit(100)
   end
   
end

maphandler.players = {
   { player = "red", x = 9, y = 3, directionvector = {1,0} },
   { player = "yellow", x = 5, y = 51, directionvector = {0,-1} },
   { player = "blue", x = 90, y = 3, directionvector = {-1,0} }
}

maphandler.imagemap = {
   r = { imgStar, consume = true, player="r", inactiveColor = {111,111,111,111} },
   y = { imgStar, consume = true, player="y", inactiveColor = {111,111,111,111} },
   b = { imgStar, consume = true, player="b", inactiveColor = {111,111,111,111} },
   
}


return maphandler
