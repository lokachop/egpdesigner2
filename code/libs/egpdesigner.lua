EGPD2 = EGPD2 or {}
EGPD2.Objects = {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrZoom = 1
EGPD2.CurrPosOffset = {0, 0}
EGPD2.CenterPos = {384, 256}
EGPD2.ExportName = "exported"
EGPD2.ImageBase = love.graphics.newImage("res/image.png")
EGPD2.AddModeActive = false
EGPD2.SelectedObject = 0

EGPD2.BaseObjectProperties = {
	id = 0,
	x = 0,
	y = 0,
	type "undefined :(",
	r = 255,
	g = 255,
	b = 255,
	a = 255,
	drawtype = "undefined"
}


EGPD2.PresetTableCopiesForTypes = {}
EGPD2.PresetTableCopiesForTypes["box"] = {
	type = "box",
	w = 16,
	h = 16,
	drawtype = "nopoly"
}


EGPD2.PresetTableCopiesForTypes["circle"] = {
	type = "circle",
	w = 16,
	h = 16,
	drawtype = "nopoly",
	fidelity = 32
}

for k, v in pairs(EGPD2.PresetTableCopiesForTypes) do
	for k2, v2 in pairs(EGPD2.BaseObjectProperties) do
		if EGPD2.PresetTableCopiesForTypes[k][k2] == nil then
			EGPD2.PresetTableCopiesForTypes[k][k2] = v2
		end
	end
end

EGPD2.ObjectCreators = {}
EGPD2.ObjectCreators["nopoly"] = function(x, y, id)
	local tblcopy = {}
	for k, v in pairs(EGPD2.PresetTableCopiesForTypes[EGPD2.CurrObjectType]) do
		tblcopy[k] = v
	end

	tblcopy.x = math.floor(x)
	tblcopy.y = math.floor(y)
	tblcopy.id = id

	EGPD2.Objects[id] = tblcopy
end


function EGPD2.CreateObjectCurrSelected(x, y, id)
	pcall(EGPD2.ObjectCreators[EGPD2.PresetTableCopiesForTypes[EGPD2.CurrObjectType].drawtype], x, y, id)
end

function EGPD2.MouseToScreen(x, y)
	local offx = EGPD2.CurrPosOffset[1] + EGPD2.CenterPos[1]
	local offy = EGPD2.CurrPosOffset[2] + EGPD2.CenterPos[2]
	local tx = (x - offx) / EGPD2.CurrZoom
	local ty = (y - offy) / EGPD2.CurrZoom

	return tx, ty
end

function EGPD2.FormatStringToNum(str)
	local strf = string.gsub(str, "%D", "")
	return tonumber(strf) or 0
end

local function checkValid(obj)
	if obj.w == nil then
		print("invalid touchable")
		return false
	end

	return true
end

local function inrange(num, min, max)
	return num >= min and num <= max
end

function EGPD2.CheckTouchingObject(x, y)
	local mx, my = EGPD2.MouseToScreen(x, y)
	for k, v in pairs(EGPD2.Objects) do
		if checkValid(v) and inrange(mx, v.x - v.w / 2, v.x + v.w / 2) and inrange(my, v.y - v.h / 2, v.y + v.h / 2) then
			return k
		end
	end
end