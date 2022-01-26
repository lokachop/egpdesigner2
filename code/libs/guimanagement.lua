EGPD2 = EGPD2 or {}
EGPD2.DynamicUI = {}
EGPD2.DynamicUI.ToRemove = {}
EGPD2.DynamicUI.LastHeight = 42
EGPD2.DynamicUI.ConfMakers = {}
EGPD2.DynamicUI.AdderStep = 18

EGPD2.ObjectList = {}
EGPD2.ObjectList.Objects = {}
EGPD2.ObjectList.ScrollModifier = 0


function EGPD2.ObjectList.ScrollObjectList(x, y)
	local addmult = y * 32
	if EGPD2.ObjectList.ScrollModifier + addmult - 512 < -#EGPD2.ObjectList.Objects * 16 then
		return
	end

	if EGPD2.ObjectList.ScrollModifier + addmult > 0 then
		return
	end

	EGPD2.ObjectList.ScrollModifier = EGPD2.ObjectList.ScrollModifier + addmult
	EGPD2.ObjectList.UpdateScrollers()
end

function EGPD2.ObjectList.UpdateScrollers()
	for k, v in pairs(EGPD2.ObjectList.Objects) do
		lsglil2.SetObjectPosition(v.id, 770, 18 + (k * 16) + EGPD2.ObjectList.ScrollModifier)
	end
end

function EGPD2.ObjectList.DeleteObject(id)
	lsglil2.DeleteObject(EGPD2.ObjectList.Objects[id].id)
	EGPD2.ObjectList.Objects[id] = nil
end

EGPD2.ObjectList.ColoursForObjTypes = {
	["box"] = {0.2, 0.4, 0.2},
	["circle"] = {0.2, 0.4, 0.2},
	["poly"] = {0.2, 0.2, 0.4},
	["line"] = {0.4, 0.2, 0.2},
	["text"] = {0.4, 0.4, 0.2}
}


function EGPD2.ObjectList.MakeObject(obj, id)
	local mkid = "ObjListButton" .. id
	lsglil2.NewObject(mkid, "button")
	lsglil2.SetObjectData(mkid, "text", "[#" .. id .. "] " .. obj.type)
	lsglil2.SetObjectScale(mkid, 124, 16)
	lsglil2.SetObjectData(mkid, "col", EGPD2.ObjectList.ColoursForObjTypes[obj.type])
	lsglil2.SetObjectData(mkid, "onPress", function(edata)
		if not lsglil2.TextEntryActive() then
			EGPD2.SelectObject(id)
		end
	end)

	EGPD2.ObjectList.Objects[id] = {
		id = mkid
	}

	EGPD2.ObjectList.UpdateScrollers()
end



function EGPD2.DynamicUI.UpdateColours()
	if EGPD2.Objects[EGPD2.SelectedObject] == nil then
		return
	end
	local obj = EGPD2.Objects[EGPD2.SelectedObject]
	lsglil2.SetObjectData("PanelColours", "col", {obj.r / 255, obj.g / 255, obj.b / 255})
	lsglil2.SetObjectData("confLabelEntryR", "text", obj.r)
	lsglil2.SetObjectData("confLabelEntryG", "text", obj.g)
	lsglil2.SetObjectData("confLabelEntryB", "text", obj.b)
end


function EGPD2.ObjectList.AddObject(id)

end

function EGPD2.DynamicUI.WipeToDeleteUI()
	for k, v in ipairs(EGPD2.DynamicUI.ToRemove) do
		lsglil2.DeleteObject(v)
	end

	EGPD2.DynamicUI.LastHeight = 42
end

function MakeObjectAndAddToTable(id, type)
	lsglil2.NewObject(id, type)
	EGPD2.DynamicUI.ToRemove[#EGPD2.DynamicUI.ToRemove + 1] = id
end


local function MakeEntryNum(id, str, bgstring, grab, releasecall, col)
	local idl = id .. "label"
	local ide = id .. "entry"

	local tcol = col or {0.4, 0.4, 0.4}
	MakeObjectAndAddToTable(idl, "label")
	lsglil2.SetObjectPosition(idl, 644, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectData(idl, "text", str)
	lsglil2.SetObjectData(idl, "alignmode", "left")
	lsglil2.SetObjectScale(idl, 52, 32)

	MakeObjectAndAddToTable(ide, "textentry")
	lsglil2.SetObjectPosition(ide, 694, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectScale(ide, 64, 16)
	lsglil2.SetObjectData(ide, "backgroundtext", bgstring)
	lsglil2.SetObjectData(ide, "text", grab)
	lsglil2.SetObjectData(ide, "col", tcol)
	lsglil2.SetObjectData(ide, "releasecall", releasecall)

	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep
end


local function MakeEntryLong(id, str, bgstring, grab, releasecall, col)
	local idl = id .. "label"
	local ide = id .. "entry"

	local tcol = col or {0.4, 0.4, 0.4}
	MakeObjectAndAddToTable(idl, "label")
	lsglil2.SetObjectPosition(idl, 644, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectData(idl, "text", str)
	lsglil2.SetObjectData(idl, "alignmode", "center")
	lsglil2.SetObjectScale(idl, 120, 32)

	MakeObjectAndAddToTable(ide, "textentry")
	lsglil2.SetObjectPosition(ide, 644, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep)
	lsglil2.SetObjectScale(ide, 120, 48)
	lsglil2.SetObjectData(ide, "backgroundtext", bgstring)
	lsglil2.SetObjectData(ide, "text", grab)
	lsglil2.SetObjectData(ide, "col", tcol)
	lsglil2.SetObjectData(ide, "releasecall", releasecall)

	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep * 4
end


EGPD2.DynamicUI.ConfMakers["w"] = function(obj)
	MakeEntryNum("confw", "Width", "Width", obj.w, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.w = num
	end)
end

EGPD2.DynamicUI.ConfMakers["h"] = function(obj)
	MakeEntryNum("confh", "Height", "Height", obj.h, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.h = num
	end)
end

EGPD2.DynamicUI.ConfMakers["x"] = function(obj)
	MakeEntryNum("confx", "Pos X", "PosX", obj.x, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.x = num
	end)
end

EGPD2.DynamicUI.ConfMakers["y"] = function(obj)
	MakeEntryNum("confy", "Pos Y", "PosY", obj.y, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.y = num
	end)
end

local function clampalgn(num)
	if num > 2 then num = 2 end
	if num < 0 then num = 0 end
	return num
end

EGPD2.DynamicUI.ConfMakers["alignx"] = function(obj)
	MakeEntryNum("confalgnx", "Align X", "AlgnX", obj.alignx, function(edata)
		local num = clampalgn(EGPD2.FormatStringToNum(edata.text))
		edata.text = num
		obj.alignx = num
	end, {0.4, 0.6, 0.6})
end

EGPD2.DynamicUI.ConfMakers["aligny"] = function(obj)
	MakeEntryNum("confalgny", "Align Y", "AlgnY", obj.aligny, function(edata)
		local num = clampalgn(EGPD2.FormatStringToNum(edata.text))
		edata.text = num
		obj.aligny = num
	end, {0.4, 0.6, 0.6})
end

EGPD2.DynamicUI.ConfMakers["fontsize"] = function(obj)
	MakeEntryNum("conffontsize", "Fontsize", "FontSz", obj.fontsize, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.fontsize = num
	end, {0.4, 0.6, 0.6})
end




EGPD2.DynamicUI.ConfMakers["message"] = function(obj)
	MakeEntryLong("confmessage", "Text", "text", obj.message, function(edata)
		obj.message = edata.text
	end, {0.4, 0.6, 0.6})
end


EGPD2.DynamicUI.ConfMakers["fidelity"] = function(obj)
	MakeEntryNum("conf_fidelity", "Fidelity", "Fidelity", obj.fidelity, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		if num < 3 then
			num = 3
		end
		if num > 32 then
			num = 32
		end

		edata.text = num
		obj.fidelity = num
	end, {0.4, 0.6, 0.6})
end

EGPD2.DynamicUI.ConfMakers["rot"] = function(obj)
	MakeEntryNum("confrot", "Rotation", "Degrees", obj.rot, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.rot = num
	end)
end


EGPD2.DynamicUI.ConfMakers["r"] = function(obj)
	MakeObjectAndAddToTable("confLabelColour", "label")
	lsglil2.SetObjectPosition("confLabelColour", 644, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep)
	lsglil2.SetObjectData("confLabelColour", "text", "Colour")
	lsglil2.SetObjectData("confLabelColour", "alignmode", "left")
	lsglil2.SetObjectScale("confLabelColour", 42, 32)

	MakeObjectAndAddToTable("PanelColours", "panel")
	lsglil2.SetObjectPosition("PanelColours", 686, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectScale("PanelColours", 4, EGPD2.DynamicUI.AdderStep * 3)
	lsglil2.SetObjectData("PanelColours", "col", {obj.r / 255, obj.g / 255, obj.b / 255})

	MakeObjectAndAddToTable("confLabelEntryR", "textentry")
	lsglil2.SetObjectPosition("confLabelEntryR", 694, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectScale("confLabelEntryR", 64, 16)
	lsglil2.SetObjectData("confLabelEntryR", "backgroundtext", "Red")
	lsglil2.SetObjectData("confLabelEntryR", "text", obj.r)
	lsglil2.SetObjectData("confLabelEntryR", "col", {0.5, 0.3, 0.3})
	lsglil2.SetObjectData("confLabelEntryR", "releasecall", function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.r = num
		lsglil2.SetObjectData("PanelColours", "col", {obj.r / 255, obj.g / 255, obj.b / 255})
	end)

	MakeObjectAndAddToTable("confLabelEntryG", "textentry")
	lsglil2.SetObjectPosition("confLabelEntryG", 694, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep)
	lsglil2.SetObjectScale("confLabelEntryG", 64, 16)
	lsglil2.SetObjectData("confLabelEntryG", "backgroundtext", "Green")
	lsglil2.SetObjectData("confLabelEntryG", "text", obj.g)
	lsglil2.SetObjectData("confLabelEntryG", "col", {0.3, 0.5, 0.3})
	lsglil2.SetObjectData("confLabelEntryG", "releasecall", function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.g = num
		lsglil2.SetObjectData("PanelColours", "col", {obj.r / 255, obj.g / 255, obj.b / 255})
	end)

	MakeObjectAndAddToTable("confLabelEntryB", "textentry")
	lsglil2.SetObjectPosition("confLabelEntryB", 694, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep * 2)
	lsglil2.SetObjectScale("confLabelEntryB", 64, 16)
	lsglil2.SetObjectData("confLabelEntryB", "backgroundtext", "Blue")
	lsglil2.SetObjectData("confLabelEntryB", "text", obj.b)
	lsglil2.SetObjectData("confLabelEntryB", "col", {0.3, 0.3, 0.5})
	lsglil2.SetObjectData("confLabelEntryB", "releasecall", function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.b = num
		lsglil2.SetObjectData("PanelColours", "col", {obj.r / 255, obj.g / 255, obj.b / 255})
	end)

	MakeObjectAndAddToTable("confColourPickRGB", "button")
	lsglil2.SetObjectPosition("confColourPickRGB", 644, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep * 2)
	lsglil2.SetObjectScale("confColourPickRGB", 38, 16)
	lsglil2.SetObjectData("confColourPickRGB", "text", "Pick")
	lsglil2.SetObjectData("confColourPickRGB", "col", {0.3, 0.3, 0.3})
	lsglil2.SetObjectData("confColourPickRGB", "onPress", function()
		if EGPD2.CurrentMode ~= "colpick" then
			EGPD2.CurrentMode = "colpick"
		end
	end)

	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + (EGPD2.DynamicUI.AdderStep * 3)
end

EGPD2.DynamicUI.MakeOrder = {
	"w", "h", "r", "x", "y", "rot", "fidelity", "fontsize", "alignx", "aligny", "message"
}



function EGPD2.MakeUIForObjectProperties()
	EGPD2.DynamicUI.WipeToDeleteUI()

	if EGPD2.Objects[EGPD2.SelectedObject] == nil then
		return
	end

	local valids = {}
	for k, v in pairs(EGPD2.Objects[EGPD2.SelectedObject]) do
		valids[k] = true
	end


	for k, v in ipairs(EGPD2.DynamicUI.MakeOrder) do
		if valids[v] then
			local fine, msg = pcall(EGPD2.DynamicUI.ConfMakers[v], EGPD2.Objects[EGPD2.SelectedObject])
			if not fine then
				print("ERROR; " .. msg)
			end
		end
	end

	MakeObjectAndAddToTable("confDeleteButton", "button")
	lsglil2.SetObjectPosition("confDeleteButton", 644, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectData("confDeleteButton", "col", {0.4, 0.1, 0.1})
	lsglil2.SetObjectScale("confDeleteButton", 120, 32)
	lsglil2.SetObjectData("confDeleteButton", "text", "Delete")
	lsglil2.SetObjectData("confDeleteButton", "onPress", function(edata)
		if not lsglil2.TextEntryActive() then
			EGPD2.SafeDelete(EGPD2.SelectedObject)
		end
	end)

end