EGPD2 = EGPD2 or {}
EGPD2.Objects = {}
EGPD2.CurrObjectType = "box"
EGPD2.CurrZoom = 1
EGPD2.CurrPosOffset = {0, 0}


function EGPD2.Initlsgil2Buttons()
	lsglil2.NewObject("ButtonTypeBox", "button")
	lsglil2.SetObjectPosition("ButtonTypeBox", 4, 32)
	lsglil2.SetObjectScale("ButtonTypeBox", 118, 32)
	lsglil2.SetObjectData("ButtonTypeBox", "text", "Box")
	lsglil2.SetObjectData("ButtonTypeBox", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeBox", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "box"
	end)

	lsglil2.NewObject("ButtonTypeTriangle", "button")
	lsglil2.SetObjectPosition("ButtonTypeTriangle", 4, 64 + 8)
	lsglil2.SetObjectScale("ButtonTypeTriangle", 118, 32)
	lsglil2.SetObjectData("ButtonTypeTriangle", "text", "Triangle")
	lsglil2.SetObjectData("ButtonTypeTriangle", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeTriangle", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "triangle"
	end)

	lsglil2.NewObject("ButtonTypeCircle", "button")
	lsglil2.SetObjectPosition("ButtonTypeCircle", 4, 96 + 16)
	lsglil2.SetObjectScale("ButtonTypeCircle", 118, 32)
	lsglil2.SetObjectData("ButtonTypeCircle", "text", "Circle")
	lsglil2.SetObjectData("ButtonTypeCircle", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeCircle", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "circle"
	end)


	lsglil2.NewObject("ButtonTypeConvexPoly", "button")
	lsglil2.SetObjectPosition("ButtonTypeConvexPoly", 4, 128 + 24)
	lsglil2.SetObjectScale("ButtonTypeConvexPoly", 118, 32)
	lsglil2.SetObjectData("ButtonTypeConvexPoly", "text", "Polygon (Convex)")
	lsglil2.SetObjectData("ButtonTypeConvexPoly", "col", {0.2, 0.2, 0.4})
	lsglil2.SetObjectData("ButtonTypeConvexPoly", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "convexpoly"
	end)


	lsglil2.NewObject("ButtonTypeConcavePoly", "button")
	lsglil2.SetObjectPosition("ButtonTypeConcavePoly", 4, 160 + 32)
	lsglil2.SetObjectScale("ButtonTypeConcavePoly", 118, 32)
	lsglil2.SetObjectData("ButtonTypeConcavePoly", "text", "Polygon (Concave)")
	lsglil2.SetObjectData("ButtonTypeConcavePoly", "col", {0.2, 0.2, 0.4})
	lsglil2.SetObjectData("ButtonTypeConcavePoly", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "concavepoly"
	end)

	lsglil2.NewObject("ButtonTypeLine", "button")
	lsglil2.SetObjectPosition("ButtonTypeLine", 4, 192 + 40)
	lsglil2.SetObjectScale("ButtonTypeLine", 118, 32)
	lsglil2.SetObjectData("ButtonTypeLine", "text", "Line")
	lsglil2.SetObjectData("ButtonTypeLine", "col", {0.4, 0.2, 0.2})
	lsglil2.SetObjectData("ButtonTypeLine", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "line"
	end)

	lsglil2.NewObject("ButtonTypePoint", "button")
	lsglil2.SetObjectPosition("ButtonTypePoint", 4, 224 + 48)
	lsglil2.SetObjectScale("ButtonTypePoint", 118, 32)
	lsglil2.SetObjectData("ButtonTypePoint", "text", "Point")
	lsglil2.SetObjectData("ButtonTypePoint", "col", {0.4, 0.2, 0.2})
	lsglil2.SetObjectData("ButtonTypePoint", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "point"
	end)
end




local bgtex = love.graphics.newImage("res/background.png")
bgtex:setWrap("repeat", "repeat")
local bgquad = love.graphics.newQuad(0, 0, 512, 512, 512, 512)

function EGPD2.DrawCenteredQ(tex, quad, x, y, r, sx, sy)
	local w, h = tex:getDimensions()
	love.graphics.draw(tex, quad, x - w / 2, y - h / 2, r, sx, sx)
end

local function toCentered(x, y)
	local cx = 640
	local cy = 256
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