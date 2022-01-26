EGPD2 = EGPD2 or {}
EGPD2.Objects = {}
EGPD2.PolyData = {}
EGPD2.CurrZoom = 1
EGPD2.CurrPosOffset = {0, 0}
EGPD2.CenterPos = {384, 256}
EGPD2.ExportName = "exported"
EGPD2.HighestID = 0

EGPD2.ObjectList = EGPD2.ObjectList or {}


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
	drawtype = "nopoly",
	rot = 0
}


EGPD2.PresetTableCopiesForTypes["circle"] = {
	type = "circle",
	w = 16,
	h = 16,
	drawtype = "nopoly",
	fidelity = 32
}

EGPD2.PresetTableCopiesForTypes["poly"] = {
	type = "poly",
	drawtype = "poly",
}


EGPD2.PresetTableCopiesForTypes["text"] = {
	type = "text",
	drawtype = "nopoly",
	message = "#BASE_EGPD2",
	alignx = 0,
	aligny = 0,
	fontsize = 12,
	rot = 0
}


for k, v in pairs(EGPD2.PresetTableCopiesForTypes) do
	for k2, v2 in pairs(EGPD2.BaseObjectProperties) do
		if EGPD2.PresetTableCopiesForTypes[k][k2] == nil then
			if type(v2) == "table" then
				EGPD2.PresetTableCopiesForTypes[k][k2] = {}
				for k3, v3 in pairs(v2) do
					EGPD2.PresetTableCopiesForTypes[k][k2][k3] = v3
				end
				print(tostring(v2) .. " is table")
			else
				EGPD2.PresetTableCopiesForTypes[k][k2] = v2
			end
		end
	end
end

function EGPD2.PushObject(tbl, id)
	print("pushing object id " .. id .. "...")
	EGPD2.Objects[id] = tbl
	EGPD2.ObjectList.MakeObject(tbl, id)
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

	EGPD2.PushObject(tblcopy, id)
end


EGPD2.ObjectCreators["poly"] = function(x, y, id)
	local tblcopy = {}
	for k, v in pairs(EGPD2.PresetTableCopiesForTypes[EGPD2.CurrObjectType]) do
		tblcopy[k] = v
	end

	tblcopy.x = math.floor(x)
	tblcopy.y = math.floor(y)
	tblcopy.id = id

	EGPD2.PushObject(tblcopy, id)
	EGPD2.CurrentMode = "drawpoly"
	EGPD2.PolyData[id] = {}
end


function EGPD2.DeleteObject(id)
	EGPD2.Objects[id] = nil
	EGPD2.ObjectList.DeleteObject(id)
	EGPD2.DynamicUI.WipeToDeleteUI()
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
	local strf = string.gsub(str, "[%a%c%s%z]", "")
	return tonumber(strf) or 0
end

local function checkValid(obj)
	if obj == nil then
		return false
	end

	if obj.w == nil then
		print("invalid touchable")
		return false
	end

	return true
end

local BlacklistedModes = {
	["colpick"] = true
}

function EGPD2.SafeDelete(id)
	if not lsglil2.TextEntryActive() and not (BlacklistedModes[EGPD2.CurrentMode] or false) then
		EGPD2.DeleteObject(id)
		EGPD2.ObjectList.Objects[id] = nil
		EGPD2.ObjectList.DeleteObject(id)
	end
end


EGPD2.TouchCheckers = {
	["nopoly"] = function(obj, x, y)
		if checkValid(obj) and EGPD2.Math.inBox(x, y, obj.x - obj.w / 2, obj.y - obj.h / 2, obj.w, obj.h) then
			return true
		end
	end,
	["poly"] = function(obj, x, y)
		return EGPD2.Math.inPoly(x, y, EGPD2.PolyData[obj.id])
	end
}

function EGPD2.CheckTouchingObject(x, y)
	local mx, my = EGPD2.MouseToScreen(x, y)
	for i = EGPD2.HighestID, 0, -1 do
		local obj = EGPD2.Objects[i]
		if obj ~= nil then
			local fine, ret = pcall(EGPD2.TouchCheckers[obj.drawtype], obj, mx, my)

			if not fine then
				print("touch error!; " .. ret)
				return
			end

			if ret == true then
				return i
			end
		end
	end
end