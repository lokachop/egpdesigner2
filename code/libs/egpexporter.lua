EGPD2 = EGPD2 or {}
EGPD2.Exporters = {}


EGPD2.Exporters.Text = {}


function EGPD2.Exporters.Text.Export(fpath)
	local exportStr = "["
	for k, v in pairs(EGPD2.Objects) do
		exportStr = exportStr .. "{|i" .. k .. "|t" .. v.type .. "|x" .. v.x .. "|y" .. "|r" .. v.r .. "|g" .. v.g .. "|b" .. v.b
	end

	exportStr = exportStr .. "["
	for k, v in pairs(EGPD2.PolyData) do
		exportStr = exportStr .. "{i" .. k
		for k2, v2 in pairs(v) do
			exportStr = exportStr .. "(" .. v2
		end
	end
	print(exportStr)
end

EGPD2.Exporters.EGP = {}
function EGPD2.Exporters.EGP.Export(fpath)
	print("this would export \"" .. fpath .. "\" to EGP but i didnt code it yet")
end

EGPD2.Exporters.GPU = {}
function EGPD2.Exporters.GPU.Export(fpath)
	print("this would export \"" .. fpath .. "\" to wireGPU but i didnt code it yet")
end


EGPD2.Importer = {}
function EGPD2.Importer.Import(fpath)
	print("this would import \"" .. fpath .. "\" to egpdesigner but i didnt code it yet")
end


