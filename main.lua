function love.load() -- called on start
	local f = love.filesystem.load("/initlua.lua")
	f()
	love.keyboard.setKeyRepeat(true)
	Time = 0
	EGPD2.Initlsgil2Buttons()
end

function love.update(dt) -- dt is deltatime
	Time = Time + dt
	lsglil2.Update(dt)
	EGPD2.CurrPosOffset[1] = math.sin(Time) * 512
	EGPD2.CurrZoom = math.cos(Time * 0.5) + 1
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
	EGPD2.RenderBackground()
	EGPD2.RenderBorderElements()
	EGPD2.RenderInformation()
	lsglil2.DrawElements()
end
