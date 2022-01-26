EGPD2 = EGPD2 or {}
EGPD2.Math = {}

function EGPD2.Math.inrange(num, min, max)
	return num >= min and num <= max
end


function EGPD2.Math.inBox(cx, cy, bx, by, sx, sy)
	return EGPD2.Math.inrange(cx, bx, bx + sx) and EGPD2.Math.inrange(cy, by, by + sy)
end


-- implementation from https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/
local function area(x1, y1, x2, y2, x3, y3)
	return math.abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2)
end

function EGPD2.Math.inTriangle(px, py, x1, y1, x2, y2, x3, y3)
	local areaTri = area(x1, y1, x2, y2, x3, y3)

	local area1 = area(px, py, x2, y2, x3, y3)

	local area2 = area(x1, y1, px, py, x3, y3)

	local area3 = area(x1, y1, x2, y2, px, py)

	return areaTri == (area1 + area2 + area3)
end


function EGPD2.Math.inPoly(x, y, polydata)
	local fine, ret = pcall(love.math.triangulate(polydata))
	if not fine then
		print("[ERROR] [InPoly]: " .. ret)
	end

	for k, v in pairs(ret) do
		if EGPD2.Math.inTriangle(x, y, ret[1], ret[2], ret[3], ret[4], ret[5], ret[6]) then
			return true
		end
	end

	return false
end