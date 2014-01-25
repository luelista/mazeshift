local maphandler = {}

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)

   if mapchar == "t" and direction == "enter" then playerDied() end

end

maphandler.imagemap = {
   r = { imgStar, player="r", inactiveColor = {111,111,111} },
   y = { imgStar, player="y", inactiveColor = {111,111,111} },
   b = { imgStar, player="b", inactiveColor = {111,111,111} },
   t = { love.graphics.newImage("images/death.png"), player="r", inactiveColor = {0,0,0} }
}

return maphandler
