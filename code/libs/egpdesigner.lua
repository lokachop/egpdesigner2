EGPD2 = EGPD2 or {}
EGPD2.Objects = {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrZoom = 1
EGPD2.CurrPosOffset = {0, 0}
EGPD2.CenterPos = {384, 256}
EGPD2.ExportName = "exported"
EGPD2.ImageBase = love.graphics.newImage("res/image.png")


EGPD2.PresetTableCopiesForTypes = {}
EGPD2.PresetTableCopiesForTypes["box"] = {
	id = 0,
	x = 0,
	y = 0,
	type = "box",
	w = 16,
	h = 16,
	r = 255,
	g = 255,
	b = 255,
	a = 255
}

function EGPD2.HandleMoving(x, y, dx, dy)
	if love.mouse.isDown(3) then
		EGPD2.CurrPosOffset[1] = EGPD2.CurrPosOffset[1] + dx
		EGPD2.CurrPosOffset[2] = EGPD2.CurrPosOffset[2] + dy
	end
end

function EGPD2.HandleZooming(x, y)
	if y > 0 then
		EGPD2.CurrZoom = EGPD2.CurrZoom * 1.1
	else
		EGPD2.CurrZoom = EGPD2.CurrZoom / 1.1
	end
end

function EGPD2.CreateObjectNoPoly(x, y, id)
	local tblcopy = {}
	for k, v in pairs(EGPD2.PresetTableCopiesForTypes[EGPD2.CurrObjectType]) do
		tblcopy[k] = v
	end

	tblcopy.x = math.floor(x)
	tblcopy.y = math.floor(y)
	tblcopy.id = id

	EGPD2.Objects[id] = tblcopy
end



function EGPD2.HandleDrawing(x, y, button)
	if button == 1 then
		EGPD2.CreateObjectNoPoly(0, 0, 1)
	end
end

--local bgtex = love.graphics.newImage("res/background.png")
--bgtex:setWrap("repeat", "repeat")
--local bgquad = love.graphics.newQuad(0, 0, 512, 512, 512, 512)

function EGPD2.StartTranslatedStuff()
	love.graphics.push()
	love.graphics.translate(EGPD2.CurrPosOffset[1] + EGPD2.CenterPos[1], EGPD2.CurrPosOffset[2] + EGPD2.CenterPos[2])
	love.graphics.scale(EGPD2.CurrZoom, EGPD2.CurrZoom)
	--love.graphics.translate(-EGPD2.CurrPosOffset[1], -EGPD2.CurrPosOffset[2])
end

function EGPD2.EndTranslatedStuff()
	love.graphics.pop()
end

function EGPD2.RenderImageBase()
	local iw, ih = EGPD2.ImageBase:getDimensions()
	love.graphics.setColor(1, 1, 1, 1)



end


-- res is 768 x 640 so;
-- 2 side margins, 128 wide
-- 1 bottom margin 128 tall
function EGPD2.RenderBorderElements()
	--local w, h = love.graphics.getDimensions()
	local backgroundcol = {0.1, 0.1, 0.1}
	local outlinecol = {0.2, 0.2, 0.4}
	local textcol = {0.6, 0.6, 1}

	love.graphics.setColor(backgroundcol[1], backgroundcol[2], backgroundcol[3], 1)
	love.graphics.rectangle("fill", 0, 0, 128, 512)
	love.graphics.rectangle("fill", 640, 0, 128, 512)

	love.graphics.rectangle("fill", 0, 512, 768, 128)


	love.graphics.setColor(outlinecol[1], outlinecol[2], outlinecol[3], 1)
	love.graphics.rectangle("line", 0, 0, 128, 512)
	love.graphics.rectangle("line", 640, 0, 128, 512)

	love.graphics.rectangle("line", 0, 512, 768, 128)


	love.graphics.setColor(textcol[1], textcol[2], textcol[3], 1)
	love.graphics.printf("Object type selector", 0, 0, 128, "center")
	love.graphics.printf("Object data", 640, 0, 128, "center")
end


function EGPD2.RenderInformation()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.printf("object count: " .. tostring(#EGPD2.Objects) .. "\n (max 300)", 128, 0, 512, "center")


	local typestring = "current object type: " .. EGPD2.CurrObjectType
	local posstring = "\n current pos offset: x:" .. math.floor(EGPD2.CurrPosOffset[1]) .. ", y:" .. math.floor(EGPD2.CurrPosOffset[2])
	local zoomstring = "\n current zoom: x" .. tostring(EGPD2.CurrZoom)

	love.graphics.printf(typestring .. posstring .. zoomstring, 128, 0, 511, "right")
end