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

function EGPD2.MakeUIForObjectProperties()
	EGPD2.DynamicUI.WipeToDeleteUI()

	if EGPD2.Objects[EGPD2.SelectedObject] == nil then
		return
	end


	for k, v in pairs(EGPD2.Objects[EGPD2.SelectedObject]) do
		local fine, msg = pcall(EGPD2.DynamicUI.ConfMakers[k], EGPD2.Objects[EGPD2.SelectedObject])
		if not fine then
			print("ERROR; " .. msg)
		end
	end
end