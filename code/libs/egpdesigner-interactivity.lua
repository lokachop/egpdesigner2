EGPD2 = EGPD2 or {}



function EGPD2.HandleMoving(x, y, dx, dy)
	if love.mouse.isDown(3) then
		EGPD2.CurrPosOffset[1] = EGPD2.CurrPosOffset[1] + dx
		EGPD2.CurrPosOffset[2] = EGPD2.CurrPosOffset[2] + dy
	end
end

function EGPD2.HandleZooming(x, y)
	if y > 0 then
		EGPD2.CurrZoom = EGPD2.CurrZoom * 1.1
	else
		EGPD2.CurrZoom = EGPD2.CurrZoom / 1.1
	end
end

function EGPD2.HandleDrawing(x, y, button)
	if button == 1 then
		local tx, ty = EGPD2.MouseToScreen(x, y)
		local id = #EGPD2.Objects + 1
		EGPD2.CreateObjectCurrSelected(tx, ty, id)
		EGPD2.SelectedObject = id
		EGPD2.MakeUIForObjectProperties()
	end
end

function EGPD2.HandleInputs(key)
	if key == "space" then
		EGPD2.AddModeActive = not EGPD2.AddModeActive
	end
end

function EGPD2.HandleSelecting(x, y, button)
	if button == 1 then
		local obj = EGPD2.CheckTouchingObject(x, y)
		if obj == nil then
			return
		end
		EGPD2.SelectedObject = obj
		EGPD2.MakeUIForObjectProperties()
	end
end


function EGPD2.HandleMouse(x, y, button)
	if EGPD2.AddModeActive then
		EGPD2.HandleDrawing(x, y, button)
	else
		EGPD2.HandleSelecting(x, y, button)
	end
end