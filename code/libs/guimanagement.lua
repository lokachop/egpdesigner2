EGPD2 = EGPD2 or {}
EGPD2.DynamicUI = {}
EGPD2.DynamicUI.ToRemove = {}
EGPD2.DynamicUI.LastHeight = 42
EGPD2.DynamicUI.ConfMakers = {}
EGPD2.DynamicUI.AdderStep = 18

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


local function MakeEntryNum(id, str, bgstring, grab, releasecall)
	local idl = id .. "label"
	local ide = id .. "entry"
	MakeObjectAndAddToTable(idl, "label")
	lsglil2.SetObjectPosition(idl, 644, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectData(idl, "text", str)
	lsglil2.SetObjectScale(idl, 42, 32)

	MakeObjectAndAddToTable(ide, "textentry")
	lsglil2.SetObjectPosition(ide, 694, EGPD2.DynamicUI.LastHeight)
	lsglil2.SetObjectScale(ide, 64, 16)
	lsglil2.SetObjectData(ide, "backgroundtext", bgstring)
	lsglil2.SetObjectData(ide, "text", grab)
	lsglil2.SetObjectData(ide, "col", {0.4, 0.4, 0.4})
	lsglil2.SetObjectData(ide, "releasecall", releasecall)
end

EGPD2.DynamicUI.ConfMakers["w"] = function(obj)
	MakeEntryNum("confw", "Width", "Width", obj.w, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.w = num
	end)
	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep
end

EGPD2.DynamicUI.ConfMakers["h"] = function(obj)
	MakeEntryNum("confh", "Height", "Height", obj.h, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.h = num
	end)
	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep
end

EGPD2.DynamicUI.ConfMakers["x"] = function(obj)
	MakeEntryNum("confx", "Pos X", "PosX", obj.x, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.x = num
	end)
	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep
end

EGPD2.DynamicUI.ConfMakers["y"] = function(obj)
	MakeEntryNum("confy", "Pos Y", "PosY", obj.y, function(edata)
		local num = EGPD2.FormatStringToNum(edata.text)
		edata.text = num
		obj.y = num
	end)
	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep
end


EGPD2.DynamicUI.ConfMakers["r"] = function(obj)
	MakeObjectAndAddToTable("confLabelColour", "label")
	lsglil2.SetObjectPosition("confLabelColour", 644, EGPD2.DynamicUI.LastHeight + EGPD2.DynamicUI.AdderStep)
	lsglil2.SetObjectData("confLabelColour", "text", "Colour")
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
		print(obj.col)
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
		print(obj.col)
	end)

	EGPD2.DynamicUI.LastHeight = EGPD2.DynamicUI.LastHeight + (EGPD2.DynamicUI.AdderStep * 3)
end

EGPD2.DynamicUI.MakeOrder = {
	"w", "h", "r", "x", "y"
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
			print("make; " .. v)
			local fine, msg = pcall(EGPD2.DynamicUI.ConfMakers[v], EGPD2.Objects[EGPD2.SelectedObject])
			if not fine then
				print("ERROR; " .. msg)
			end
		end
	end

end