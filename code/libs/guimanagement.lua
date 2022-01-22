EGPD2 = EGPD2 or {}
EGPD2.DynamicUI = {}
EGPD2.DynamicUI.ToRemove = {}

function EGPD2.DynamicUI.WipeToDeleteUI()
	for k, v in ipairs(EGPD2.DynamicUI.ToRemove) do
		lsglil2.DeleteObject(v)
	end
end

function MakeObjectAndAddToTable(id, type)
	lsglil2.NewObject(id, type)
end


function EGPD2.MakeUIForObjectProperties()
	EGPD2.DynamicUI.WipeToDeleteUI()

	if EGPD2.Objects[EGPD2.SelectedObject] == nil then
		return
	end


	for k, v in pairs(EGPD2.Objects[EGPD2.SelectedObject]) do
		print(v)
	end
end