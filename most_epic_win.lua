-- -*- compile-command: "\"c:/Program Files/LOVE/love.exe\" ."; -*-

most_epic_win = {}

function most_epic_win:enter()
   
end

function most_epic_win:draw()
   love.graphics.setFont(fntTitle);
    -- draw text "Hello world!" at left: 100, top: 200
   
   if blinkyvis then love.graphics.print("You won ALL THE LEVELS!", 300, 290) end
   
end


blinkytimer = 0   blinkyvis = false
function most_epic_win:update(dt)
   blinkytimer = blinkytimer + dt
   if blinkytimer > 0.4 then
      blinkyvis = not blinkyvis
      blinkytimer = blinkytimer - 0.4
   end
end
function most_epic_win:keypressed(key)
   if key == "return" or key == " " then
      Gamestate.switch(credits)
   end
end


