EGPD2 = EGPD2 or {}

EGPOBJR = EGPOBJR or {}
EGPOBJR.ObjectCallables = {}
EGPOBJR.ObjectCallables["box"] = function(obj)
	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)

	love.graphics.rectangle("fill", obj.x - (obj.w / 2), obj.y - (obj.h / 2), obj.w, obj.h)
end

EGPOBJR.ObjectCallables["circle"] = function(obj)
	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)

	if obj.fidelity < 3 then
		obj.fidelity = 3
	end
	if obj.fidelity > 64 then
		obj.fidelity = 64
	end

	local points = {}
	for i = 1, obj.fidelity do
		local relp = i / obj.fidelity
		local px = (math.sin((math.pi * 2) * relp) * obj.w) + obj.x
		local py = (math.cos((math.pi * 2) * relp) * obj.h) + obj.y
		table.insert(points, px)
		table.insert(points, py)
	end

	love.graphics.polygon("fill", points)
end



function EGPD2.RenderObjects()
	for k, v in pairs(EGPD2.Objects) do
		pcall(EGPOBJR.ObjectCallables[v.type], v)
	end
end