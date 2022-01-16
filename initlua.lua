--load init first
for k, v in pairs(love.filesystem.getDirectoryItems("/code/init")) do
	local f = love.filesystem.load("/code/init/"..v)
	f()
end
-- load utilfunctions
for k, v in pairs(love.filesystem.getDirectoryItems("/code/libs")) do
	local f = love.filesystem.load("/code/libs/"..v)
	f()
end
