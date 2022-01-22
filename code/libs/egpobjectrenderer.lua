EGPD2 = EGPD2 or {}

EGPOBJR = EGPOBJR or {}
EGPOBJR.ObjectCallables = {}
EGPOBJR.ObjectCallables["box"] = function(obj)
	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)

	love.graphics.rectangle("fill", obj.x - (obj.w / 2), obj.y - (obj.h / 2), 32, 32)
end


function EGPD2.RenderObjects()
	for k, v in pairs(EGPD2.Objects) do
		pcall(EGPOBJR.ObjectCallables[v.type], v)
	end
end