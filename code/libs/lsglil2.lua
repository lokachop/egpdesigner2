--[[
	Lokachop's
	Simple
	GUI
	Library
	In
	Love2D
	2

    a simple gui library coded for love2D, by lokachop!
	NOTE: touching doesnt work with rotated objects!
]]
local utf8 = require("utf8")


lsglil2 = {}
lsglil2.Assets = {}
lsglil2.AssetsSearchPath = "res/lsglil2"
lsglil2.GUITime = 0
lsglil2.DoDebugPrints = true
lsglil2.Flags = {}
lsglil2.Flags.TextEntry = {}
lsglil2.Flags.TextEntry.CurrentUsing = ""
lsglil2.Flags.TextEntry.Active = false

local function printIfDebug(...)
	if lsglil2.DoDebugPrints then
		print(...)
	end
end

local function searchOnDirectoryAndLoad(dir, ldir)
	for k, v in pairs(love.filesystem.getDirectoryItems(dir)) do
		local nfo = love.filesystem.getInfo(dir .. "/" .. v)

		if nfo.type == "directory" then
			printIfDebug("[LSGLIL2]: Recursively checking folder \"" .. v .. "\"")

			searchOnDirectoryAndLoad(dir .. "/" .. v, ldir .. v .. "/")
		elseif nfo.type == "file" then
			printIfDebug("[LSGLIL2]: Found asset \"" .. v .. "\" at directory " .. dir)

			lsglil2.Assets[ldir .. v] = love.graphics.newImage(dir .. "/" .. v)
			printIfDebug("[LSGLIL2]: Loaded asset \"" .. v .. "\" on table index \"" .. ldir .. v .. "\"")
		end
	end
end

searchOnDirectoryAndLoad(lsglil2.AssetsSearchPath, "")


lsglil2.BasePaint = function(time, edata, touching)
	love.graphics.setColor(1, 0, 0, 1)
	if edata["texture"] ~= nil and edata["texture"] ~= "" then
		local tex = lsglil2.Assets[edata["texture"]]

		local sx = edata["w"] / tex:getWidth()
		local sy = edata["h"] / tex:getHeight()

		love.graphics.draw(tex, edata["x"], edata["y"], 0, sx, sy)
	else
		love.graphics.rectangle("fill", edata["x"], edata["y"], edata["w"], edata["h"])
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("NOT DEFINED", edata["x"], edata["y"], edata["w"], "center")

end

lsglil2.BaseUpdateCall = function(time, edata, touching)

end

lsglil2.BaseData = {
	["x"] = 0,
	["y"] = 0,
	["texture"] = "",
	["w"] = 64,
	["h"] = 32,
	["col"] = {1, 1, 1, 1},
	["priority"] = 1,
	["id"] = ""
}


lsglil2.Elements = {}
lsglil2.DrawableElements = {}

function lsglil2.RegisterElement(name, data, updatecall, paint)
	local rdata = {}

	for k, v in pairs(lsglil2.BaseData) do
		rdata[k] = v
	end

	for k, v in pairs(data or {}) do
		printIfDebug("[LSGLIL2]: Added exta data \"" .. k .. "\" to element \"" .. name .. "\"")

		rdata[k] = v
	end

	local rpaint = paint or lsglil2.BasePaint
	local rupdatecall = updatecall or lsglil2.BaseUpdateCall
	lsglil2.Elements[name] = {}
	lsglil2.Elements[name].Data = rdata
	lsglil2.Elements[name].Paint = rpaint
	lsglil2.Elements[name].UpdateCall = rupdatecall

	printIfDebug("[LSGLIL2]: Registered element \"" .. name .. "\"")
end

-- register basic elements
lsglil2.RegisterElement("panel",
{
	["rot"] = 0
},
function() end,
function(time, edata, touching)
	love.graphics.setColor(edata["col"][1], edata["col"][2], edata["col"][3], edata["col"][4])

	love.graphics.push()
	love.graphics.translate(edata["x"], edata["y"])
	love.graphics.rotate(math.rad(edata["rot"]))

	if edata["texture"] ~= nil and edata["texture"] ~= "" then
		local tex = lsglil2.Assets[edata["texture"]]

		local sx = edata["w"] / tex:getWidth()
		local sy = edata["h"] / tex:getHeight()

		love.graphics.draw(tex, 0, 0, 0, sx, sy)
	else
		love.graphics.rectangle("fill", 0, 0, edata["w"], edata["h"])
	end
	love.graphics.pop()
end
)



-- BUTTON
lsglil2.RegisterElement("button", {
	["col"] = {0.1, 0.1, 0.3, 1},
	["text"] = "Label",
	["touching"] = false,
	["hasPressed"] = false,
	["holdable"] = false,
	["onPress"] = function(GUITime) end
},

function(time, edata, touching)
	if touching and love.mouse.isDown(1) and not edata["hasPressed"] then
		pcall(edata["onPress"], lsglil2.GUITime)
		if not edata["holdable"] then
			edata["hasPressed"] = true
		end
	elseif edata["hasPressed"] and (not love.mouse.isDown(1) or not touching) then
		edata["hasPressed"] = false
	end
end,

function(time, edata, touching)
	local currCol = {0, 0, 0}
	if touching then
		if love.mouse.isDown(1) then
			currCol = {edata["col"][1] + 0.2, edata["col"][2] + 0.2, edata["col"][3] + 0.2}
		else
			currCol = {edata["col"][1] + 0.1, edata["col"][2] + 0.1, edata["col"][3] + 0.1}
		end
	else
		currCol = edata["col"]
	end
	love.graphics.setColor(currCol[1], currCol[2], currCol[3], currCol[4])

	love.graphics.rectangle("fill", edata["x"], edata["y"], edata["w"], edata["h"])

	love.graphics.setColor(currCol[1] + 0.075, currCol[2] + 0.075, currCol[3] + 0.075)
	love.graphics.rectangle("fill", edata["x"], edata["y"], edata["w"] - 1, edata["h"] - 1)

	love.graphics.setColor(currCol[1] + 0.15, currCol[2] + 0.15, currCol[3] + 0.15)
	love.graphics.rectangle("fill", edata["x"], edata["y"], edata["w"] - 2, edata["h"] - 2)

	love.graphics.setColor(currCol[1] + 0.35, currCol[2] + 0.35, currCol[3] + 0.35)
	love.graphics.printf(edata["text"], edata["x"], edata["y"], edata["w"], "center")
end)



-- LABEL
lsglil2.RegisterElement("label", {
	["text"] = "Label"
},
function() end,

function(time, edata, touching)
	love.graphics.setColor(edata["col"][1], edata["col"][2], edata["col"][3], edata["col"][4])
	love.graphics.printf(edata["text"], edata["x"], edata["y"], edata["w"], "center")
end
)



-- TEXT ENTRY
lsglil2.RegisterElement("textentry", {
	["text"] = "",
	["backgroundtext"] = "Type here...",
	["active"] = false,
	["releasecall"] = function() end
},
function(time, edata, touching)
	if touching and love.mouse.isDown(1) and not lsglil2.Flags.TextEntry.Active then
		lsglil2.Flags.TextEntry.CurrentUsing = edata.id
		lsglil2.Flags.TextEntry.Active = true
		edata["active"] = true
	elseif not touching and love.mouse.isDown(1) and lsglil2.Flags.TextEntry.Active and edata["active"] then
		lsglil2.Flags.TextEntry.CurrentUsing = ""
		lsglil2.Flags.TextEntry.Active = false
		edata["active"] = false
		pcall(edata["releasecall"], edata)
	end
end,
function(time, edata, touching)
	local avar = 0
	if edata["active"] then
		avar = 0.2
	end

	local tadd = ""
	if edata["active"] and lsglil2.GUITime * 2 % 2 > 1 then
		tadd = "|"
	end

	love.graphics.setColor(edata["col"][1] + avar, edata["col"][2] + avar, edata["col"][3] + avar, edata["col"][4])
	love.graphics.rectangle("fill", edata["x"], edata["y"], edata["w"], edata["h"])

	love.graphics.setColor(edata["col"][1] - 0.1 + avar, edata["col"][2] - 0.1 + avar, edata["col"][3] - 0.1 + avar, edata["col"][4])
	love.graphics.rectangle("fill", edata["x"] + 2, edata["y"] + 2, edata["w"] - 3, edata["h"] - 3)

	love.graphics.setColor(edata["col"][1] - 0.2 + avar, edata["col"][2] - 0.2 + avar, edata["col"][3] - 0.2 + avar, edata["col"][4])
	love.graphics.rectangle("fill", edata["x"] + 2, edata["y"] + 2, edata["w"] - 4, edata["h"] - 4)


	if edata["text"] == "" then
		love.graphics.setColor(edata["col"][1] - 0.3 + avar, edata["col"][2] - 0.3 + avar, edata["col"][3] - 0.3 + avar, edata["col"][4])
		love.graphics.printf(edata["backgroundtext"], edata["x"] + 4, edata["y"], edata["w"] - 4, "left")
	end

	love.graphics.setColor(edata["col"][1] + 0.1 + avar, edata["col"][2] + 0.1 + avar, edata["col"][3] + 0.1 + avar, edata["col"][4])
	love.graphics.printf(edata["text"] .. tadd, edata["x"] + 4, edata["y"], edata["w"] - 4, "left")

end
)



function lsglil2.DebugPrintAllElements()
	if not lsglil2.DoDebugPrints then
		return
	end

	for k, v in pairs(lsglil2.Elements) do
		print(tostring(k) ..  ": ")
		for k2, v2 in pairs(v.Data) do
			print("    " .. k2 .. " (" .. tostring(v2) .. ")")
		end
	end
end

-- object functions
function lsglil2.NewObject(nameID, typeg)
	local tcopy = {}
	tcopy.Data = {}
	tcopy.Paint = lsglil2.Elements[typeg].Paint
	tcopy.UpdateCall = lsglil2.Elements[typeg].UpdateCall

	for k, v in pairs(lsglil2.Elements[typeg].Data) do
		tcopy.Data[k] = v
	end

	printIfDebug("[LSGLIL2]: Made new object with id \"" .. nameID .. "\"")


	lsglil2.DrawableElements[nameID] = tcopy
	lsglil2.DrawableElements[nameID].id = nameID
	lsglil2.DrawableElements[nameID].Data.id = nameID
end

function lsglil2.SetObjectPosition(id, x, y)
	lsglil2.DrawableElements[id].Data["x"] = x
	lsglil2.DrawableElements[id].Data["y"] = y
end

function lsglil2.SetObjectScale(id, w, h)
	lsglil2.DrawableElements[id].Data["w"] = w
	lsglil2.DrawableElements[id].Data["h"] = h
end

function lsglil2.SetObjectColour(id, r, g, b, a)
	local ta = a or 1
	lsglil2.DrawableElements[id].Data["col"] = {r, g, b, ta}
end

function lsglil2.SetObjectColourTable(id, tblcolour)
	if tblcolour[4] == nil then
		tblcolour[4] = 1
	end

	lsglil2.DrawableElements[id].Data["col"] = tblcolour
end

function lsglil2.SetObjectData(id, data, value)
	lsglil2.DrawableElements[id].Data[data] = value
end

function lsglil2.GetObjectData(id)
	return lsglil2.DrawableElements[id].Data
end

function lsglil2.RedefineObjectPaint(id, paint)
	lsglil2.DrawableElements[id].Paint = paint
end

function lsglil2.RedefineObjectUpdate(id, updatecall)
	lsglil2.DrawableElements[id].UpdateCall = updatecall
end

function lsglil2.ChangeObjectPriority(id, prio)
	lsglil2.DrawableElements[id].Data["priority"] = prio
end

function lsglil2.ObjectExists(id)
	if lsglil2.DrawableElements[id] ~= nil then
		return true
	else
		return false
	end
end

function lsglil2.DeleteObject(id)
	lsglil2.DrawableElements[id] = nil
end

local function inrange(num, min, max)
	return (num > min) and (num < max)
end

function lsglil2.CheckIsTouching(obj)
	local mx, my = love.mouse.getPosition()
	local dat = lsglil2.GetObjectData(obj)

	if inrange(mx, dat["x"], dat["x"] + dat["w"]) and inrange(my, dat["y"], dat["y"] + dat["h"]) then
		return true
	else
		return false
	end
end

function lsglil2.HasPressedButton(x, y)
	for k, v in pairs(lsglil2.DrawableElements) do
		local touch = lsglil2.CheckIsTouching(v.id)

		if touch then
			return true
		end
	end
	return false
end

function lsglil2.Update(dt)
	lsglil2.GUITime = lsglil2.GUITime + dt

	for k, v in pairs(lsglil2.DrawableElements) do
		local touch = lsglil2.CheckIsTouching(v.id)
		local fine, msg = pcall(v.UpdateCall, lsglil2.GUITime, v.Data, touch)

		if not fine then
			printIfDebug("[LSGLIL2] [ERROR] [THINK]: " .. tostring(msg))
		end

	end
end

function lsglil2.DrawElements()
	local copySorted = {}
	local i = 0
	for k, v in pairs(lsglil2.DrawableElements) do
		i = i + 1
		copySorted[i] = v
	end

	table.sort(copySorted, function(a, b)
		return a.Data["priority"] < b.Data["priority"]
	end)

	for k, v in pairs(copySorted) do
		local touch = lsglil2.CheckIsTouching(v.id)
		local fine, msg = pcall(v.Paint, lsglil2.GUITime, v.Data, touch)

		if not fine then
			printIfDebug("[LSGLIL2] [ERROR] [DRAW]: " .. tostring(msg))
		end

	end
end


function lsglil2.UpdateTextEntry(t)
	if lsglil2.Flags.TextEntry.CurrentUsing ~= "" then
		printIfDebug("[LSGLIL2]: added text \"" .. t .. "\" to \"" .. lsglil2.Flags.TextEntry.CurrentUsing .. "\"")
		lsglil2.DrawableElements[lsglil2.Flags.TextEntry.CurrentUsing].Data["text"] = lsglil2.DrawableElements[lsglil2.Flags.TextEntry.CurrentUsing].Data["text"] .. t
		return 1
	end

	return 0
end

function lsglil2.UpdateTextEntryKeyPress(key)
	if key ~= "backspace" then
		return 0
	end

	if lsglil2.Flags.TextEntry.CurrentUsing ~= "" then
		local text = lsglil2.DrawableElements[lsglil2.Flags.TextEntry.CurrentUsing].Data["text"]
		local byteoffset = utf8.offset(text, -1)
		if byteoffset then
			lsglil2.DrawableElements[lsglil2.Flags.TextEntry.CurrentUsing].Data["text"] = string.sub(text, 1, byteoffset - 1)
		end
	end

	return 0
end