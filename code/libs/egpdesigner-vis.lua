EGPD2 = EGPD2 or {}

function EGPD2.StartTranslatedStuff()
	love.graphics.push()
	love.graphics.translate(EGPD2.CurrPosOffset[1] + EGPD2.CenterPos[1], EGPD2.CurrPosOffset[2] + EGPD2.CenterPos[2])
	love.graphics.scale(EGPD2.CurrZoom, EGPD2.CurrZoom)
end

function EGPD2.EndTranslatedStuff()
	love.graphics.pop()
end

--[[

-- scrapped, looks disgusting

--local bgtex = love.graphics.newImage("res/background.png")
--bgtex:setWrap("repeat", "repeat")
--local bgquad = love.graphics.newQuad(0, 0, 512, 512, 512, 512)
function EGPD2.RenderBackground()
	love.graphics.setColor(1, 1, 1, 1)
	bgquad:setViewport(0, 0, 512, 512, 512 * EGPD2.CurrZoom, 512 * EGPD2.CurrZoom)
	love.graphics.draw(bgtex, bgquad, 384, 256, 0, 1, 1, 256, 256)
end
]]

function EGPD2.RenderImageBase()
	local iw, ih = EGPD2.ImageBase:getDimensions()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.draw(EGPD2.ImageBase, -iw / 2, -ih / 2)


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
	love.graphics.rectangle("fill", 0, 0, 128, 512) -- left rect
	love.graphics.rectangle("fill", 640, 0, 128, 512) -- right rect
	love.graphics.rectangle("fill", 768, 0, 128, 640) -- right rect 2


	love.graphics.rectangle("fill", 0, 512, 768, 128) -- bottom rect




	love.graphics.setColor(outlinecol[1], outlinecol[2], outlinecol[3], 1)
	love.graphics.rectangle("line", 0, 0, 128, 512) -- left rect
	love.graphics.rectangle("line", 640, 0, 128, 512) -- right rect
	love.graphics.rectangle("line", 768, 0, 128, 640) -- right rect 2

	love.graphics.rectangle("line", 0, 512, 768, 128) -- bottom rect

	love.graphics.line(640, 32, 768 + 128, 32)



	love.graphics.setColor(textcol[1], textcol[2], textcol[3], 1)
	love.graphics.printf("Object type selector", 0, 0, 128, "center")
	love.graphics.printf("Object data", 640, 0, 128, "center")

	love.graphics.printf("Object list", 768, 0, 128, "center")
end


function EGPD2.RenderInformation()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.printf("object count: " .. tostring(#EGPD2.Objects) .. "\n (max 300)", 128, 0, 512, "center")


	local typestring = "current object type: " .. EGPD2.CurrObjectType
	local posstring = "\n current pos offset: x:" .. math.floor(EGPD2.CurrPosOffset[1]) .. ", y:" .. math.floor(EGPD2.CurrPosOffset[2])
	local zoomstring = "\n current zoom: x" .. tostring(EGPD2.CurrZoom)

	love.graphics.printf(typestring .. posstring .. zoomstring, 128, 0, 511, "right")


	love.graphics.printf("addmode: " .. tostring(EGPD2.AddModeActive), 128, 496, 511, "center")
	local typeobject = "nil"
	if EGPD2.Objects[EGPD2.SelectedObject] then
		typeobject = EGPD2.Objects[EGPD2.SelectedObject].type
	end

	love.graphics.printf("OBJECT " .. tostring(EGPD2.SelectedObject) .. " (" .. typeobject .. ")", 640, 16, 128, "center")
end