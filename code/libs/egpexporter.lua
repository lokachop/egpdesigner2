EGPD2 = EGPD2 or {}
EGPD2.Exporters = {}


EGPD2.Exporters.Text = {}


function EGPD2.Exporters.Text.Export(fpath)
	if fpath == "" or fpath == nil then
		print("invalid savepath")
		return
	end

	local exportStr = "["
	for k, v in pairs(EGPD2.Objects) do
		for k2, v2 in pairs(v) do
			exportStr = exportStr .. "|" .. k2 .. ":" .. v2
		end
	end
	exportStr = exportStr .. "]"

	exportStr = exportStr .. "<"
	for k, v in pairs(EGPD2.PolyData) do
		exportStr = exportStr .. "{i" .. k .. ":"
		for k2, v2 in pairs(v) do
			exportStr = exportStr .. "(" .. v2
		end
	end
	exportStr = exportStr .. ">"

	print("RawContents; " .. exportStr)

	love.filesystem.write(fpath .. ".egd", exportStr)
	love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
	print("Saved as " .. fpath .. ".egd")
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
	if fpath == "" or fpath == nil then
		print("invalid savepath")
		return
	end

	local filedata = love.filesystem.read(fpath .. ".egd")
	--print("READ; " .. filedata)

	local objdata = string.match(filedata, "%[[%g+]+%]")
	print("object data: " .. objdata)

end


