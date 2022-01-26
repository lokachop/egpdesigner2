EGPD2 = EGPD2 or {}

EGPOBJR = EGPOBJR or {}
EGPOBJR.ObjectCallables = {}

local white = love.graphics.newImage("res/white.png") -- horrendous but i cannot rotate with love.graphics.rectangle
EGPOBJR.ObjectCallables["box"] = function(obj)
	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)

	if obj.rot == 0 then
		love.graphics.rectangle("fill", obj.x - (obj.w / 2), obj.y - (obj.h / 2), obj.w, obj.h)
	else
		love.graphics.draw(white, obj.x, obj.y, math.rad(obj.rot), obj.w, obj.h, 0.5, 0.5)
	end
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

local fontText = love.graphics.newFont(12)

EGPOBJR.ObjectCallables["text"] = function(obj)
	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)

	love.graphics.print(obj.message, obj.x, obj.y, math.rad(obj.rot), obj.fontsize / 12, obj.fontsize / 12, (fontText:getWidth(obj.message) / 2) * obj.alignx, (fontText:getHeight() / 2) * obj.aligny)
end

local selectedShader = love.graphics.newShader([[
	vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texturecolor = Texel(tex, texture_coords);

		float modxy = mod(screen_coords.x / 2 + screen_coords.y / 2, 2);
		return texturecolor * vec4(color.xyz * modxy, color.w);
	}
]])

local polyPointShader = love.graphics.newShader([[
	vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texturecolor = Texel(tex, texture_coords);

		float modxy = mod(screen_coords.x / 2 + screen_coords.y / 2, 1);
		return texturecolor * vec4(color.xyz * modxy, color.w);
	}
]])


EGPOBJR.ObjectCallables["poly"] = function(obj)
	local polyData = EGPD2.PolyData[obj.id]

	if obj.id == EGPD2.SelectedObject then
		local curr = love.graphics.getShader()
		love.graphics.setColor(math.abs(1 - obj.r / 255), math.abs(1 - obj.g / 255), math.abs(1 - obj.b / 255), obj.a / 255)
		love.graphics.setShader(polyPointShader)

		for i = 1, #polyData, 2 do
			love.graphics.rectangle("fill", polyData[i] - 2, polyData[i + 1] - 2, 4, 4)
		end
		love.graphics.setShader(curr)
	end

	love.graphics.setColor(obj.r / 255, obj.g / 255, obj.b / 255, obj.a / 255)



	if love.math.isConvex(polyData) then
		-- is  convex we can skip expensive triangulation
		love.graphics.polygon("fill", polyData)
	else
		-- time to triangulate :/
		local dat = love.math.triangulate(polyData)

		for k, v in pairs(dat) do
			love.graphics.polygon("fill", v[1], v[2], v[3], v[4], v[5], v[6])
		end
	end
end




function EGPD2.RenderObjects()
	for k, v in pairs(EGPD2.Objects) do
		if k == EGPD2.SelectedObject then
			love.graphics.setShader(selectedShader)
		end
		local fine, err = pcall(EGPOBJR.ObjectCallables[v.type], v)
		if not fine then
			print("ERROR RENDERING ELEMENT TYPE " .. v.type .. "; " ..  err)
		end

		love.graphics.setShader()
	end
end