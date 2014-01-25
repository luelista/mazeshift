local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   
   if direction == "enter" then
      labyrinth:credit(100)
   end

   if mapchar == "y" then
      sndBackgroundmusic:pause() sndCredit:play() labyrinth.show_map=true
      setTimeout(function() labyrinth.show_map = false end, 1)
      return " "
   end
end

maphandler.players = {
   { player = "yellow", x = 20, y = 3, directionvector = {0,1} }
}

maphandler.imagemap = {
   y = { imgStar, player = "y" }
}


return maphandler
