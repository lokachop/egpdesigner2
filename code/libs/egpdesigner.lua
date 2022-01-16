EGPD2 = EGPD2 or {}
EGPD2.Objects = {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrZoom = 1
EGPD2.CurrPosOffset = {0, 0}
EGPD2.CenterPos = {640, 256}
EGPD2.ExportName = "exported"




local bgtex = love.graphics.newImage("res/background.png")
bgtex:setWrap("repeat", "repeat")
local bgquad = love.graphics.newQuad(0, 0, 512, 512, 512, 512)

function EGPD2.DrawCenteredQ(tex, quad, x, y, r, sx, sy)
	local w, h = tex:getDimensions()
	love.graphics.draw(tex, quad, x - w / 2, y - h / 2, r, sx, sx)
end

local function toCentered(x, y)
	local cx = EGPD2.CenterPos[1]
	local cy = EGPD2.CenterPos[2]
	return x - cx, y - cy
end

function EGPD2.RenderBackground()
	love.graphics.setColor(1, 1, 1, 1)
	local cx, cy = toCentered(EGPD2.CurrPosOffset[1], EGPD2.CurrPosOffset[2])

	bgquad:setViewport(cx / (EGPD2.CurrZoom * 2.5), cy / (EGPD2.CurrZoom * 1), 512 / EGPD2.CurrZoom, 512 / EGPD2.CurrZoom)
	EGPD2.DrawCenteredQ(bgtex, bgquad, 384, 256, 0, EGPD2.CurrZoom, EGPD2.CurrZoom)
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