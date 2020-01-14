World = {}
World.__index = World

function World.create(map)
   local wrld = {}
   setmetatable(wrld,World)
   wrld.map = map
   wrld.map_obj = map_obj
   wrld.map_tiles = map_tiles
   wrld.width = #wrld.map[1]
   wrld.height = #wrld.map

   wrld.chars = {}

	wrld.left = 380
	wrld.top = 50

	wrld.dyc = 12

	wrld.dxc = 2 * wrld.dyc
	wrld.wp = 2 * wrld.dxc
	wrld.hp = 2 * wrld.dyc
	wrld.half_wp = wrld.wp/2
	wrld.half_hp = wrld.hp/2

	wrld.obj = {}
	wrld.obj[1] = love.graphics.newImage("objects/1/tree.png")

	wrld.tiles = {}
	wrld.tiles[1] = {img=love.graphics.newImage("tiles/1/ground.png"), width=360, height=256}

   wrld.selectMap = {}
   for i, val in ipairs(wrld.map) do
   		wrld.selectMap[i] = {}
		for i1, val1 in ipairs(val) do
			wrld.selectMap[i][i1] = 0
		end
	end
   return wrld
end

function World:addChar(char)
	table.insert(self.chars,char)
end

function World:getCenterTile(x,y)
	return {x = self.dyc*1+(self.dyc/2)+(self.half_wp*x)-(self.half_wp*y)+self.left, y = self.dyc*1+(self.dyc/2)+(self.half_hp*y)+(self.half_hp*x)+self.top}
end

function World:drawMap(bounds)
	local centerx = 0
	local centery = 0
	local mod = "line"

	--local count = count.table(self.map)
	
	local charPosition = {}

	for i, char in ipairs(self.chars) do
		local charCoord = char:getCoord()
		table.insert(charPosition,{i=i,x=charCoord.x,y=charCoord.y})
	end
				
	--for i1=count, path[i].x - path[i+1].x,1 do 
	--for x, val1 in ipairs(self.map[count]) do
	for y, val in ipairs(self.map) do
		for x, val1 in ipairs(val) do
			centerx = self:getCenterTile(x, y).x
			centery = self:getCenterTile(x, y).y
			
			--love.graphics.circle( "fill", bounds.x1, bounds.y1, 5, 5 )
			--love.graphics.circle( "fill", bounds.x1, bounds.y2, 5, 5 )
			--love.graphics.circle( "fill", bounds.x2, bounds.y1, 5, 5 )
			--love.graphics.circle( "fill", bounds.x2, bounds.y2, 5, 5 )

			if(centerx > bounds.x1 and centerx < bounds.x2 and centery > bounds.y1 and centery < bounds.y2) then
				
				--[[if(val1==1) then
					love.graphics.setColor(255, 255, 255)
					mod = "fill"
				elseif(val1==2) then
					love.graphics.setColor(255, 255, 0)
					mod = "fill"
				else
					love.graphics.setColor(255, 255, 255)
					mod = "line"
				end
				love.graphics.polygon(mod, centerx, centery-self.half_hp, centerx+self.half_wp, centery, centerx, centery+self.half_hp, centerx-self.half_wp, centery)
				]]--

				--if(self.map[y][x]~=0) then

-- wrld.dyc = 12

--	wrld.dxc = 2 * wrld.dyc
--	wrld.wp = 2 * wrld.dxc
--	wrld.hp = 2 * wrld.dyc
--	wrld.half_wp = wrld.wp/2
--	wrld.half_hp = wrld.hp/2

--	wrld.obj = {}
--	wrld.obj[1] = love.graphics.newImage("objects/1/tree.png")

--	wrld.tiles = {}
--	wrld.tiles[1] = {img=love.graphics.newImage("tiles/1/ground.png"), width=256, height=256}

					love.graphics.setColor(255, 255, 255)
					if(self.tiles[1]~=nil) then
						local sfx = self.wp / self.tiles[1].width
						local sfy = self.wp / self.tiles[1].width
						love.graphics.draw(self.tiles[1].img, centerx, centery, 0, sfx, sfy)
					end
				--end
				
				if(self.map[y][x]~=0) then
					love.graphics.setColor(255, 255, 255, 200)
					if(self.obj[self.map[y][x]]~=nil) then
						love.graphics.draw(self.obj[self.map[y][x]], centerx-100, centery-140)
					end
				end
				
				love.graphics.setColor(255, 255, 255)
				
				for i, pos in ipairs(charPosition) do
					if (pos.x == x and pos.y == y) then
						self.chars[pos.i]:draw()
					end
				end
				--[[
				for i, pos in ipairs(charPosition) do
					if(pos.x == x and pos.y == y) then
						self.chars[pos.i]:draw
						end
					end
				end
				]]--
				

				love.graphics.setColor(255, 0, 255)
			end
		end
	end
	love.graphics.setColor(255, 255, 0)
	for y, val in ipairs(self.selectMap) do
		for x, val1 in ipairs(val) do
			if(val1==1) then
				mod = "fill"
				
				centerx = self:getCenterTile(x, y).x
				centery = self:getCenterTile(x, y).y
			
				love.graphics.polygon(mod, centerx, centery-self.half_hp, centerx+self.half_wp, centery, centerx, centery+self.half_hp, centerx-self.half_wp, centery)
			end
		end
	end
--[[	love.graphics.setColor(255, 255, 255)
	for y, val in ipairs(self.map_obj) do
		for x, val1 in ipairs(val) do
			if(val1==1) then
				centerx = self:getCenterTile(x, y).x
				centery = self:getCenterTile(x, y).y
				if(centerx > bounds.x1 and centerx < bounds.x2 and centery > bounds.y1 and centery < bounds.y2) then
					love.graphics.draw(self.obj[1], centerx-100, centery-140)
				end
			end
		end
	end
]]--
	love.graphics.setColor(255, 255, 255)
end

function World:SelectTile(x, y)
	local centerx = 0
	local centery = 0
	local mod = "line"

	for y1, val in ipairs(self.map) do
		for x1, val1 in ipairs(val) do
			if(val1==1) then
				love.graphics.setColor(255, 255, 255)
				mod = "fill"
			else
				love.graphics.setColor(255, 255, 255)
				mod = "line"
			end
			
			centerx = self:getCenterTile(x1, y1).x
			centery = self:getCenterTile(x1, y1).y
			if(x>centerx-self.half_hp and x<=centerx+self.half_hp and y>centery-self.half_hp and y<=centery+self.half_hp) then
				love.graphics.circle( "fill", centerx, centery, 5, 5 )
			end
		end
	end
end

function World:clickTitle(x, y)
	local centerx = 0
	local centery = 0
	local mod = "line"
	for y1, val in ipairs(self.map) do
		for x1, val1 in ipairs(val) do
			if(val1==1) then
				love.graphics.setColor(255, 255, 255)
				mod = "fill"
			else
				love.graphics.setColor(255, 255, 255)
				mod = "line"
			end
			
			centerx = self:getCenterTile(x1, y1).x
			centery = self:getCenterTile(x1, y1).y
			
			if(x>centerx-self.half_hp and x<=centerx+self.half_hp and y>centery-self.half_hp and y<=centery+self.half_hp) then
				for si, sval in ipairs(self.selectMap) do
					for si1, sval1 in ipairs(val) do
						self.selectMap[si][si1] = 0
					end
				end
				self.selectMap[y1][x1] = 1
				--love.graphics.circle( "fill", centerx, centery, 5, 5 )
			end
		end
	end
end

function World:getTileCoord(x, y)
	local coords = {x=0, y=0}
	coords.x = self:getCenterTile(x, y).x
	coords.y = self:getCenterTile(x, y).y
	return coords
end
function World:getCoordTile(x, y)
	local coords = {x=0, y=0}
	local centerx = 0
	local centery = 0
	
	for y1, val in ipairs(self.map) do
		for x1, val1 in ipairs(val) do
			centerx = self:getCenterTile(x1, y1).x
			centery = self:getCenterTile(x1, y1).y
			if(x+1>centerx-self.half_hp and x+1<=centerx+self.half_hp and y+1>centery-self.half_hp and y+1<=centery+self.half_hp) then
				coords.x = x1
				coords.y = y1
			end
		end
	end

	return coords
end

function World:getMap()
	return self.map
end

function World:getWidth()
	return self.width
end

function World:getHeight()
	return self.height
end

function World:changeMap(newmap)
	self.map = newmap
end