require ("conf")
require ("utils/table")
require ("utils/Vector2")
require ("utils/other")
require ("camera")
require ("animation/anal")

map = {}
map[1]={1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0} 
map[2]={1,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0} 
map[3]={1,0,0,1,1,0,1,1,1,1,1,0,0,0,0,0} 
map[4]={1,1,1,1,0,0,0,1,0,0,0,0,1,0,1,1} 
map[5]={0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1} 
map[6]={0,0,1,0,0,0,1,0,1,0,1,0,0,1,0,1} 
map[7]={0,0,0,1,0,1,0,0,1,1,1,0,0,0,0,1} 
map[8]={0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1} 
map[9]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1} 
map[10]={0,0,0,1,1,1,0,1,1,0,1,0,0,0,0,0} 
map[11]={0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0} 
map[12]={0,1,0,1,0,1,1,1,0,1,1,0,1,1,0,0} 
map[13]={0,1,0,1,0,0,0,0,0,1,0,0,0,1,1,0} 
map[14]={1,0,1,0,1,1,1,1,1,1,0,1,1,0,0,0} 
map[15]={0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0} 
map[16]={0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0}

map = {}
map_obj = {}
map_tiles = {}
for i1=1,128 do 
	map[i1]={}
	map_obj[i1]={}
	map_tiles[i1]={}
	for i2=1,128 do 
		local j = math.random (0,1)
		if(j == 1)then
			j = math.random (0,1)
		end
		if(j == 1)then
			j = math.random (0,1)
		end
		if(j == 1)then
			j = math.random (0,1)
		end
		if(j == 1)then
			j = math.random (0,1)
		end
		map[i1][i2] = j
		map_obj[i1][i2] = j
		map_tiles[i1][i2] = 1
	end
end

scale = 1

local world
local mainChar
function love.load()
	require ("world/World")
	require ("player/Player")
	require ("gui/Gui")
	
	gui = Gui.create()
	gui:createScreen("mainMenu")
	gui:createScreen("editor")
	gui:createScreen("game")

	--gui.screen['mainMenu']['update'] = function()
	--gui.screen['mainMenu']['draw']
	--gui.screen['mainMenu']['mousepressed']

	world = World.create(map)
	mainChar = Character.create(world, 10, 5)
	world:addChar(mainChar)
	camera:setCenter(mainChar:getGlobalCoord().x, mainChar:getGlobalCoord().y)
	love.graphics.setColor(255, 255, 255)
end

function love.update(dt)
	mainChar:walk(dt)
	camera:setCenter(mainChar:getGlobalCoord().x, mainChar:getGlobalCoord().y)
	if love.mouse.isDown("l") then
		local x, y = camera:mousePosition()
		world:clickTitle(x, y)
	end
end

function love.draw()
	--local x, y = love.mouse.getPosition()
	camera:set()
		local x, y = camera:mousePosition()
		love.graphics.setBackgroundColor(128, 128, 128)
		world:drawMap(camera:getVisBounds(-40))
		world:SelectTile(x, y)
		--mainChar:drawPath()
	camera:unset()
	love.graphics.print("x: "..x.." ".."y:"..y, 5, 5)
	local titleCoord = world:getCoordTile(x, y)
	love.graphics.print("tx: "..titleCoord.x.." ".."ty:"..titleCoord.y, 5, 20)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 5, 35)
end


function love.mousepressed(x,y, button)
  if button == "wu" then
    -- wheel up
    camera.scaleX = camera.scaleX + camera.scaleX / 10
    camera.scaleY = camera.scaleY + camera.scaleY / 10
  elseif button == "wd" then
    -- wheel down
    camera.scaleX = camera.scaleX - camera.scaleX / 10
    camera.scaleY = camera.scaleY - camera.scaleY / 10
  elseif button == "r" then
  	--local x, y = love.mouse.getPosition()
  	local x, y = camera:mousePosition()
	local c = mainChar.world:getCoordTile(x, y)
	mainChar:pathFind(c.x, c.y, x, y)
  end
end

function love.keyreleased(key, unicode) -- Клавиша отпущена
	
end

