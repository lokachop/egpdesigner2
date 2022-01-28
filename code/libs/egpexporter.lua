EGPD2 = EGPD2 or {}
EGPD2.Exporters = {}


EGPD2.Exporters.Text = {}


function EGPD2.Exporters.Text.Export(fpath)
	if fpath == "" or fpath == nil then
		print("invalid savepath")
		return
	end

	print("--==loka egd saver v0.3==--")

	local exportStr = "["
	for k, v in pairs(EGPD2.Objects) do
		exportStr = exportStr .. "{"
		for k2, v2 in pairs(v) do
			exportStr = exportStr .. "|" .. k2 .. ":" .. v2
		end
		exportStr = exportStr .. "}"
	end
	exportStr = exportStr .. "]"

	exportStr = exportStr .. "<"
	for k, v in pairs(EGPD2.PolyData) do
		print("saving polygon with id " .. k)
		exportStr = exportStr .. "{:" .. k .. ":"
		for k2, v2 in pairs(v) do
			print("|WRITEPOS; " .. v2)
			exportStr = exportStr .. "(" .. v2
		end
		exportStr = exportStr .. "}"
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

local function DecodeObject(str)
	local dataelements = {}
	print("decoding object " .. str)
	-- example object for reference
	-- {|1:string|x:18|id:1|y:10|rot:0|drawtype:nopoly|g:255|b:255|w:16|r:255|h:16|a:255|type:box}
	local data = string.gmatch(str, "|[%w:-]+")
	for el in data do
		--print("element " .. el)
		local key = string.match(el, "[%w:-]+:")
		local value = string.match(el, ":[%w:-]+")
		key = string.sub(key, 1, #key - 1)
		value = string.sub(value, 2, #value)

		print("found key " .. tostring(key) .. " with value " .. tostring(value) .. " inside")
		if string.match(value, "[-%d]+") then
			dataelements[key] = tonumber(value)
		else
			dataelements[key] = value
		end
	end

	return dataelements
end

local function DecodeObjectsLoop(str)
	local ret = string.gmatch(str, "%b{}")
	local objects = {}
	for obj in ret do
		local dat = DecodeObject(obj)
		objects[dat.id] = dat
	end

	return objects
end

local function DecodePolygon(str)
	print("decoding polygon " .. str)
	local cleanedPoly = string.gsub(str, "[{}:]", "")
	print("(cleaned: " .. cleanedPoly .. ")")

	local idx = 1
	local coords = {}
	local decoords = string.gmatch(cleanedPoly, "%([%-]?[%d]+[%.]?[%d]*")
	for pos in decoords do
		local cpos = string.sub(pos, 2, #pos)
		cpos = math.floor(tonumber(cpos))
		print("got pos; " .. cpos)

		print("setting " .. idx .. " to " .. cpos)
		coords[idx] = cpos
		idx = idx + 1
	end

	return coords
end

local function DecodePolyData(str)
	local ret = string.gmatch(str, "%b{}")
	local pdata = {}
	for obj in ret do
		local id = string.match(obj, "%b::")
		id = string.gsub(id, ":" , "")
		id = tonumber(id)
		print("id; " .. id)
		pdata[id] = DecodePolygon(obj)
	end

	return pdata
end


EGPD2.Importer = {}
function EGPD2.Importer.Import(fpath)
	if fpath == "" or fpath == nil then
		print("invalid savepath")
		return
	end

	print("--==loka egd loader v0.3==--")

	local filedata = love.filesystem.read(fpath .. ".egd")
	--print("READ; " .. filedata)

	local objdata = string.match(filedata, "%[[%g]+%]")
	local polydata = string.match(filedata, "<[%g]+%>")

	print("object data: " .. objdata)
	print("\n\n")
	print("poly data: " .. tostring(polydata))

	EGPD2.Objects = {}
	EGPD2.PolyData = {}
	EGPD2.CurrZoom = 1
	EGPD2.CurrPosOffset = {0, 0}
	EGPD2.CenterPos = {384, 256}
	EGPD2.CurrObjectType = "box"
	EGPD2.CurrentMode = "select"
	EGPD2.SelectedObject = 1
	EGPD2.SelectedSubPolyID = 1

	EGPD2.Objects = DecodeObjectsLoop(objdata)
	EGPD2.PolyData = DecodePolyData(polydata)

	for k, v in pairs(EGPD2.Objects) do
		if v.id > EGPD2.HighestID then
			EGPD2.HighestID = v.id
		end
	end

	print("loading successful!")

	EGPD2.ObjectList.Refresh()
end


