EGPD2 = EGPD2 or {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrentMode = "select"
EGPD2.SelectedObject = 1
EGPD2.SelectedSubPolyID = 1
local ScrollPosObjList = {768, 0}


function EGPD2.CanInteractDrawing()
	local mx, my = love.mouse.getPosition()
	return EGPD2.Math.inBox(mx, my, EGPD2.CenterPos[1] - 256, EGPD2.CenterPos[2] - 256, 512, 512)
end

function EGPD2.CanInteract()
	local mx, my = love.mouse.getPosition()
	return not lsglil2.HasPressedButton(mx, my) and not lsglil2.TextEntryActive()
end

function EGPD2.SelectObject(id)
	EGPD2.SelectedObject = id
	if EGPD2.Objects[id].drawtype == "poly" then
		EGPD2.SelectedSubPolyID = #EGPD2.PolyData[id] + 1
	end
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

	if EGPD2.Math.inBox(mx, my, ScrollPosObjList[1], ScrollPosObjList[2], 128, 640) then
		EGPD2.ObjectList.ScrollObjectList(x, y)
	else
		EGPD2.HandleZooming(x, y)
	end
end

function EGPD2.HandleDrawing(x, y, button)

	if button == 1 then
		local tx, ty = EGPD2.MouseToScreen(x, y)
		EGPD2.CreateObjectCurrSelected(tx, ty, EGPD2.SelectedObject)
		if EGPD2.SelectedObject > EGPD2.HighestID then
			EGPD2.HighestID = EGPD2.SelectedObject
		end

		EGPD2.MakeUIForObjectProperties()
	end
end

--[[
EGPD2.InputCallables = {
	["select"] = function(key)
		if key == "space" then
			if EGPD2.Objects[EGPD2.SelectedObject] ~= nil and EGPD2.Objects[EGPD2.SelectedObject].drawtype == "poly" then
				EGPD2.CurrentMode = "drawpoly"
			else
				EGPD2.CurrentMode = "add"
			end
		end
	end,
	["add"] = function(key)
		if key == "space" then
			EGPD2.CurrentMode = "select"
		end
	end,
	["colpick"] = function(key)
		if key == "space" then
			EGPD2.CurrentMode = "select"
		end
	end,
	["drawpoly"] = function(key)
		if key == "space" then
			EGPD2.CurrentMode = "select"
		end
	end
}
]]--

EGPD2.AdvInputCallables = {
	["select"] = {
		["space"] = function(key)
		end
	},
	["add"] = {
		["space"] = function(key)
			EGPD2.CurrentMode = "select"
		end
	},
	["colpick"] = {
		["space"] = function(key)
			EGPD2.CurrentMode = "select"
		end
	},
	["drawpoly"] = {
		["space"] = function(key)
			EGPD2.CurrentMode = "select"
		end,
		["q"] = function(key)
			local id = EGPD2.SelectedObject
			if EGPD2.Objects[id] and EGPD2.Objects[id].drawtype == "poly" then
				EGPD2.SelectedSubPolyID = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID - 2, 1, #EGPD2.PolyData[EGPD2.SelectedObject] + 1)
			end
		end,
		["e"] = function(key)
			local id = EGPD2.SelectedObject
			if EGPD2.Objects[id] and EGPD2.Objects[id].drawtype == "poly" then
				EGPD2.SelectedSubPolyID = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID + 2, 1, #EGPD2.PolyData[EGPD2.SelectedObject] + 1)
			end
		end
	}
}

local toCallModes = {
	["drawpoly"] = true,
	["colpick"] = true
}

EGPD2.GlobalCallOnKey = {
	["w"] = function()
		if toCallModes[EGPD2.CurrentMode] then
			EGPD2.CurrentMode = "select"
		end

		if not EGPD2.CanInteract() then
			return
		end

		EGPD2.SelectedObject = EGPD2.SelectedObject + 1
		EGPD2.SelectedSubPolyID = #(EGPD2.PolyData[EGPD2.SelectedObject] or {}) + 1
		EGPD2.MakeUIForObjectProperties()
	end,
	["s"] = function()
		if toCallModes[EGPD2.CurrentMode] then
			EGPD2.CurrentMode = "select"
		end

		if not EGPD2.CanInteract() then
			return
		end

		EGPD2.SelectedObject = EGPD2.SelectedObject - 1
		EGPD2.SelectedSubPolyID = #(EGPD2.PolyData[EGPD2.SelectedObject] or {}) + 1
		EGPD2.MakeUIForObjectProperties()
	end,
	["r"] = function()
		EGPD2.CurrentMode = "select"
	end,
	["f"] = function()
		EGPD2.CurrentMode = "add"
	end,
	["t"] = function()
		if EGPD2.Objects[EGPD2.SelectedObject] ~= nil and EGPD2.Objects[EGPD2.SelectedObject].drawtype == "poly" then
			EGPD2.CurrentMode = "drawpoly"
		end
	end
}

function EGPD2.HandleInputs(key)
	pcall(EGPD2.GlobalCallOnKey[key], key)

	if not EGPD2.AdvInputCallables[EGPD2.CurrentMode][key] then
		print("[" .. EGPD2.CurrentMode .. "] undefined key; " .. key)
		return
	end

	local fine, err = pcall(EGPD2.AdvInputCallables[EGPD2.CurrentMode][key], key)
	if not fine then
		print("[ERR] [SPCHNDL]; " .. err)
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

function EGPD2.HandleDrawPoly(x, y, button)
	if button == 1 then
		local tx, ty = EGPD2.MouseToScreen(x, y)
		tx = math.floor(tx)
		ty = math.floor(ty)

		local spoly = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID, 1, 256)


		EGPD2.PolyData[EGPD2.SelectedObject][spoly] = tx
		EGPD2.PolyData[EGPD2.SelectedObject][spoly + 1] = ty

		EGPD2.SelectedSubPolyID = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID + 2, 1, 256)
	elseif button == 2 then
		EGPD2.SelectedSubPolyID = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID - 2, 1, 256)
		local spoly = EGPD2.Math.Clamp(EGPD2.SelectedSubPolyID, 1, 256)

		--EGPD2.PolyData[EGPD2.SelectedObject][spoly] = nil
		--EGPD2.PolyData[EGPD2.SelectedObject][spoly] = nil
		table.remove(EGPD2.PolyData[EGPD2.SelectedObject], spoly)
		table.remove(EGPD2.PolyData[EGPD2.SelectedObject], spoly)
	end
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
	end,
	["drawpoly"] = function(x, y, button)
		EGPD2.HandleDrawPoly(x, y, button)
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