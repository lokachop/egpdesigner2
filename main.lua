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
	--EGPD2.CurrZoom = math.cos(Time * 0.5) + 1
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
		EGPD2.HandleInputs(key)
		-- code to run if user isnt on a text entry
	end
end

function love.draw() -- draw
	--EGPD2.RenderBackground() -- scrapped, looks disgusting
	EGPD2.StartTranslatedStuff()

	EGPD2.RenderImageBase()
	EGPD2.RenderObjects()

	EGPD2.EndTranslatedStuff()

	EGPD2.RenderBorderElements()
	EGPD2.RenderInformation()
	lsglil2.DrawElements()
end

function love.mousepressed(x, y, button, istouch, presses)
	if not lsglil2.HasPressedButton(x, y) and not lsglil2.TextEntryActive() then
		EGPD2.HandleMouse(x, y, button)
	end
end

function love.mousemoved(x, y, dx, dy)
	EGPD2.HandleMoving(x, y, dx, dy)
end

function love.wheelmoved(x, y)
	EGPD2.HandleZooming(x, y)
end