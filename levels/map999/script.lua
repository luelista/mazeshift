
require "../../mazecode"

local maphandler = {}

function maphandler:onLoad()

   print("*** the magic bonus level ***")
   
   keepkey = true
   stepinterval = 0.08
   
   width = math.floor((canvasWidth-25) / ScaleX / 4)*2 + 1
   height = math.floor((canvasHeight-45) / ScaleX / 4)*2 + 1
   print ("Generating "..width.."x"..height.." map...")
   local mazemaster
   if math.random(2) == 1 then
      mazemaster = MazeMasterRecDiv( width, height )
      darkeneralpha = 188
   else
      mazemaster = MazeMasterRecBack( width, height )
      darkeneralpha = 255
   end
   
   setHugeoverlay("A UNIQUE LEVEL", "ESPECIALLY DESIGNED AND MADE FOR YOU", 1.8)
   
   if not mazemaster then 
      pushhelp("An error occured.")
      return
   end
   
   --mazemaster:SetSize(30,5)
   if param2 then
			mazemaster:SetDepth(param2+0)
   end
   if param3 then
			mazemaster:SetMinCorridor(param3+0)
   end
   mazemaster:GenerateMaze()
   mazemaster:MakeEntrance()
   mazemaster:MakeExit()
   
   local newgrid = mazemaster:GetGrid()
   
   local output = ""
   local gwidth, gheight = #(newgrid), #(newgrid[1])
   local str = ''
   for x=1, gwidth do
      local row = ""
      for y = 1,gheight do  
         local b =  tostring( newgrid[x][y] )
         b = b .. b
         if b == "XX" then b = "# " end
         if b == "DD" and gheight == y then b = "c " end
         if b == "DD" then b = "b " end
         
         row = row .. b
      end 
      output = output .. row .. "\n"
      output = output .. string.rep(" ",gheight*2) .. "\n"
--row:gsub("b ", "  ")
   end
   
   print("Writing map to "..levelFolder .. "map.txt")
   love.filesystem.createDirectory(levelFolder)
   love.filesystem.write(levelFolder .. "map.txt", output)
   
   
end

function maphandler:onCollision(direction, mapchar, player, tx, ty, playerIndex)
   print("onCollision", direction, mapchar, player, tx, ty, playerIndex)
   
   if direction == "enter" and (mapchar == "r" or mapchar == "y" or mapchar == "b") and player.player == mapchar then
      sndCoin:play() labyrinth:credit(100)
      
   end
   
end

maphandler.imagemap = {
   r = { imgStar, consume = true, player="r", inactiveColor = {111,111,111,111} },
   y = { imgStar, consume = true, player="y", inactiveColor = {111,111,111,111} },
   b = { imgStar, consume = true, player="b", inactiveColor = {111,111,111,111} },
}

maphandler.players = {
  -- { player = "yellow", x = 5, y = 10, directionvector = {1,0} },
   { player = "blue", x = 3, y = 3, directionvector = {1,0} },
  -- { player = "red", x = 5, y = 34, directionvector = {1,0} }
}
return maphandler

