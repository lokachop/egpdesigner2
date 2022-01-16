function love.load() -- called on start
	local f = love.filesystem.load("/initlua.lua")
	f()
	love.keyboard.setKeyRepeat(true)

end

function love.update(dt) -- dt is deltatime
	lsglil2.Update(dt)
end

function love.draw() -- draw
end

function love.textinput(t)
	local cancel = lsglil2.UpdateTextEntry(t)
	if not cancel then
		return
		--code to run if user isnt on a text entry
	end
end

function love.keypressed(key)
	local cancel lsglil2.UpdateTextEntryKeyPress(key)
	if not cancel then
		return
		-- code to run if user isnt on a text entry
	end
end

function love.draw() -- draw
	lsglil2.DrawElements()
end
