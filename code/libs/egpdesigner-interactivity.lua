EGPD2 = EGPD2 or {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrentMode = "select"
EGPD2.SelectedObject = 0
local ScrollPosObjList = {768, 0}

local function inrange(num, min, max)
	return num >= min and num <= max
end

function EGPD2.CanInteractDrawing()
	local mx, my = love.mouse.getPosition()
	return inrange(mx, EGPD2.CenterPos[1] - 256, EGPD2.CenterPos[1] + 256) and inrange(my, EGPD2.CenterPos[2] - 256, EGPD2.CenterPos[2] + 256)
end

function EGPD2.CanInteract()
	local mx, my = love.mouse.getPosition()
	return not lsglil2.HasPressedButton(mx, my) and not lsglil2.TextEntryActive()
end

function EGPD2.SelectObject(id)
	EGPD2.SelectedObject = id
	EGPD2.MakeUIForObjectProperties()
end

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

function EGPD2.HandleScrolling(x, y)
	local mx, my = love.mouse.getPosition()

	if inrange(mx, ScrollPosObjList[1], ScrollPosObjList[1] + 128) and inrange(my, ScrollPosObjList[2], ScrollPosObjList[2] + 640) then
		EGPD2.ObjectList.ScrollObjectList(x, y)
	else
		EGPD2.HandleZooming(x, y)
	end
end

function EGPD2.HandleDrawing(x, y, button)

	if button == 1 then
		local tx, ty = EGPD2.MouseToScreen(x, y)
		local id = #EGPD2.Objects + 1
		EGPD2.CreateObjectCurrSelected(tx, ty, id)
		EGPD2.SelectedObject = id
		if id > EGPD2.HighestID then
			EGPD2.HighestID = id
		end

		EGPD2.MakeUIForObjectProperties()
	end
end

EGPD2.InputCallablesSpace = {
	["select"] = function()
		EGPD2.CurrentMode = "add"
	end,
	["add"] = function()
		EGPD2.CurrentMode = "select"
	end,
	["colpick"] = function()
		EGPD2.CurrentMode = "select"
	end
}


function EGPD2.HandleInputs(key)
	if key == "space" then
		pcall(EGPD2.InputCallablesSpace[EGPD2.CurrentMode])
	end
end

function EGPD2.HandleSelecting(x, y, button)

	if button == 1 then
		local obj = EGPD2.CheckTouchingObject(x, y)
		if obj == nil then
			return
		end
		EGPD2.SelectObject(obj)
	end
end

function EGPD2.HandleColPick(x, y, button)
	local tx, ty = EGPD2.MouseToScreen(x, y)
	tx = math.floor(tx)
	ty = math.floor(ty)

	tx = tx + 256
	ty = ty + 256
	if tx < 0 or ty < 0 then
		return
	end

	if tx >= EGPD2.ImageBase:getWidth() or ty >= EGPD2.ImageBase:getHeight() then
		return
	end

	local r, g, b = EGPD2.ImgData:getPixel(tx, ty)
	EGPD2.Objects[EGPD2.SelectedObject].r = math.floor(r * 255)
	EGPD2.Objects[EGPD2.SelectedObject].g = math.floor(g * 255)
	EGPD2.Objects[EGPD2.SelectedObject].b = math.floor(b * 255)

	EGPD2.DynamicUI.UpdateColours()
	EGPD2.CurrentMode = "select"
end

EGPD2.ModeCallables = {
	["select"] = function(x, y, button)
		EGPD2.HandleSelecting(x, y, button)
	end,
	["add"]  = function(x, y, button)
		EGPD2.HandleDrawing(x, y, button)
	end,
	["colpick"] = function(x, y, button)
		EGPD2.HandleColPick(x, y, button)
	end
}


function EGPD2.HandleMouse(x, y, button)
	if not EGPD2.CanInteractDrawing() then
		return
	end

	local fine, err = pcall(EGPD2.ModeCallables[EGPD2.CurrentMode], x, y, button)
	if not fine then
		print("[ERROR]; " .. err)
	end
end