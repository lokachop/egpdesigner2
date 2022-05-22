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
function EGPD2.Exporters.EGP.TranslatePos(x, y)
	return x + 256, y + 256
end

EGPD2.Exporters.EGP.DebugOn = true

local function TryToAddDebugToText(obj)
	local code = "\n"
	if EGPD2.Exporters.EGP.DebugOn then
		code = code .. "    #----BEGIN EGPD2 DEBUG----\n"
		code = code .. "    #OBJECT " .. obj.id .. "\n"
		code = code .. "    #TYPE " .. obj.type .. "\n"
		code = code .. "    #RGBA " .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "\n"
		code = code .. "    #POSPREMOV " .. obj.x .. ", " .. obj.y .. "\n"
		local tx, ty = EGPD2.Exporters.EGP.TranslatePos(obj.x, obj.y)
		code = code .. "    #POSPOSTMOV " .. tx .. ", " .. ty .. "\n"
		code = code .. "    #----END EGPD2 DEBUG----\n"
	end

	return code
end

EGPD2.Exporters.EGP.ObjectCallables = {
	["box"] = function(obj, id)
		local code = "\n"
		code = code .. TryToAddDebugToText(obj)
		local tx, ty = EGPD2.Exporters.EGP.TranslatePos(obj.x, obj.y)
		code = code .. "    EGP:egpBox(" .. id .. ", vec2(" .. tx .. ", " .. ty .. "), vec2(" .. obj.w .. ", " .. obj.h .. "))\n"
		code = code .. "    EGP:egpColor(" .. id .. ", vec4(" .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "))\n"
		code = code .. "    EGP:egpAngle(" .. id .. ", -" .. obj.rot .. ")\n"
		return code, 1
	end,
	["circle"] = function(obj, id)
		local code = "\n"
		code = code .. TryToAddDebugToText(obj)
		local tx, ty = EGPD2.Exporters.EGP.TranslatePos(obj.x, obj.y)
		code = code .. "    EGP:egpCircle(" .. id .. ", vec2(" .. tx .. ", " .. ty .. "), vec2(" .. obj.w .. ", " .. obj.h .. "))\n"
		code = code .. "    EGP:egpColor(" .. id .. ", vec4(" .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "))\n"
		code = code .. "    EGP:egpFidelity(" .. id .. ", " .. obj.fidelity .. ")\n"
		return code, 1
	end,
	["text"] = function(obj, id)
		local code = "\n"
		code = code .. TryToAddDebugToText(obj)
		local tx, ty = EGPD2.Exporters.EGP.TranslatePos(obj.x, obj.y)
		code = code .. "    EGP:egpText(" .. id .. ", \"" .. obj.message .. "\", vec2(" .. tx .. ", " .. ty .. "))\n"
		code = code .. "    EGP:egpAlign(" .. id .. ", " .. obj.alignx .. ", " .. obj.aligny .. ")\n"
		code = code .. "    EGP:egpSize(" .. id .. ", " .. obj.fontsize .. ")\n"
		code = code .. "    EGP:egpColor(" .. id .. ", vec4(" .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "))\n"
		code = code .. "    EGP:egpAngle(" .. id .. ", -" .. obj.rot .. ")\n"
		return code, 1
	end,
	["poly"] = function(obj, id)
		local code = "\n"
		local addCount = 1
		code = code .. TryToAddDebugToText(obj)


		local fine, conv = pcall(love.math.isConvex, EGPD2.PolyData[obj.id])
		if not fine then
			print("err exporting polygon; isconvex fail!")
			return "#error exporting polygon :/", 1
		end
		if conv then
			code = code .. "    EGP:egpPoly(" .. id
			for i = 1, #EGPD2.PolyData[obj.id], 2 do
				local tx, ty = EGPD2.Exporters.EGP.TranslatePos(EGPD2.PolyData[obj.id][i], EGPD2.PolyData[obj.id][i + 1])
				code = code .. ", vec2(" .. tx .. ", " .. ty .. ")"
			end
			code = code .. ")\n"
			code = code .. "    EGP:egpColor(" .. id .. ", vec4(" .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "))\n"
		else
			addCount = addCount - 1
			local fine2, tris = pcall(love.math.triangulate, EGPD2.PolyData[obj.id])
			if not fine2 then
				return "#error exporting polygon :/", 1
			end

			for k, v in pairs(tris) do
				local t1, t2 = EGPD2.Exporters.EGP.TranslatePos(v[1], v[2])
				local t3, t4 = EGPD2.Exporters.EGP.TranslatePos(v[3], v[4])
				local t5, t6 = EGPD2.Exporters.EGP.TranslatePos(v[5], v[6])

				local v1 = "vec2(" .. t1 .. ", " .. t2 .. "), "
				local v2 = "vec2(" .. t3 .. ", " .. t4 .. "), "
				local v3 = "vec2(" .. t5 .. ", " .. t6 .. ")"

				code = code .. "    EGP:egpTriangle(" .. id + addCount .. ", " .. v1 .. v2 .. v3 .. ")\n"
				code = code .. "    EGP:egpColor(" .. id + addCount .. ", vec4(" .. obj.r .. ", " .. obj.g .. ", " .. obj.b .. ", " .. obj.a .. "))\n"
				addCount = addCount + 1
			end

		end
		return code, addCount
	end
}
function EGPD2.Exporters.EGP.Export(fpath)
	local code = ""
	code = code .. "@name EGPD2_" .. fpath .. "\n"
	code = code .. "@inputs EGP:wirelink\n"
	code = code .. "# Exported with lokachop's EGPDesigner2\n"
	code = code .. "# https://github.com/lokachop/egpdesigner2\n\n"
	code = code .. "if(first() | dupefinished())\n"
	code = code .. "{\n"
	code = code .. "    EGP:egpClear()\n"
	local id = 1

	for k, v in pairs(EGPD2.Objects) do
		local fine, ret1, ret2 = pcall(EGPD2.Exporters.EGP.ObjectCallables[v.type], v, id)
		if not fine then
			print("[ERROR] EXPORTING TO EGP; " .. ret1)
			return
		end
		code = code .. ret1
		id = id + ret2
	end

	code = code .. "}\n"
	code = code .. "# Exported with lokachop's EGPDesigner2\n"
	code = code .. "# https://github.com/lokachop/egpdesigner2\n\n"

	code = code .. "if(~EGP)\n"
	code = code .. "{\n"
	code = code .. "    reset()\n"
	code = code .. "}\n"

	love.filesystem.write("egp_" .. fpath .. ".txt", code)
	love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
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
	local data = string.gmatch(str, "|[^|}]+") -- |[%w:-]+ old
	for el in data do
		local key = string.match(el, "[%g]+:")
		local value = string.match(el, ":[%g]+")

		key = string.sub(key, 2, #key - 1)
		value = string.sub(value, 2, #value)

		print("found key " .. tostring(key) .. " with value " .. tostring(value) .. " inside")
		if tonumber(value) then
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
	if polydata then
		EGPD2.PolyData = DecodePolyData(polydata)
	end

	for k, v in pairs(EGPD2.Objects) do
		if v.id > EGPD2.HighestID then
			EGPD2.HighestID = v.id
		end
	end

	print("loading successful!")

	EGPD2.ObjectList.Refresh()
end


