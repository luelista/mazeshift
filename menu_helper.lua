--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--
return {
	new = function()
		return {
			menuitems = {},
			curmenuitem = 1,
			menutop = 100,
      menuheight = 20,
      mouselasty = 0,
      add = function(self, txt, act)
         table.insert(self.menuitems, {tx = txt, a = act})
      end,
			update = function(self, dt)
				local mousey = love.mouse.getY()
        if mousey ~= mouselasty then   mouselasty = mousey
           local menuitem = self:getMenuByYPos(mousey)
           if menuitem ~= 0 then  self.curmenuitem = menuitem end
        end
			end,
			draw = function(self, x, y)

         love.graphics.setFont(fntDefault)
         
         local top = self.menutop local left = 100
         for i = 1,#self.menuitems do
            top = top + self.menuheight
            love.graphics.print(self.menuitems[i].tx, 100, top)
            if i == self.curmenuitem then love.graphics.print("", 80, top) end
         end
         
			end,
      
      getMenuByYPos = function (self, ypos)
         local menuitem = (ypos - self.menutop) / self.menuheight
         if menuitem >= 1 and menuitem < #self.menuitems+1 then
            return math.floor(menuitem)
         end
         return 0
      end,

      mousepressed = function(self, x, y, button)
         if button == "l" then
            local menuitem = self:getMenuByYPos(y)
            if menuitem ~= 0 then self.menuitems[self.curmenuitem]:a(self.menuitems[self.curmenuitem]) end
         end
      end,

			keypressed = function(self, key)
				if key == "up" then
           self.curmenuitem = self.curmenuitem - 1
           if self.curmenuitem < 1 then self.curmenuitem = #self.menuitems end
        elseif key == "down" then
           self.curmenuitem = self.curmenuitem + 1
           if self.curmenuitem > #self.menuitems then self.curmenuitem = 1 end
        elseif key == "return" or key == " " then
           self.menuitems[self.curmenuitem]:a(self.menuitems[self.curmenuitem])
        end
			end
		}
	end
}
