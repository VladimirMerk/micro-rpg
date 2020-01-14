Character = {}
Character.__index = Character

function Character.create(world, x, y)
	local chr = {}
	chr.world = world;
	chr.path = {}

	chr.globalx = 0
	chr.globaly = 0

	chr.pathThreshold = 3
	chr.currpoint = 1
	chr.speed = 20
	chr.loop = false

	chr.globalx = chr.world:getTileCoord(x, y).x
	chr.globaly = chr.world:getTileCoord(x, y).y

	chr.oldpos = chr.world:getCoordTile(chr.globalx, chr.globaly)

	local thisMap = chr.world:getMap()
	thisMap[chr.oldpos.y][chr.oldpos.x] = 2
	

   	chr.animations = {}
   	chr.animations['walk'] = {img=love.graphics.newImage("player/walk.png")}
   	chr.animations['walk']['dir'] = {
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 0),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 1),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 2),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 3),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 7),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 6),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 5),
		newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 4)
	}

	chr.thisAnimation = nil
	--chr.thisAnimation = newAnimation(chr.animations['walk']['img'], 55, 65, 0.1, 9, 4)
	--chr.thisAnimation:setMode("bounce")
	setmetatable(chr,Character)
	return chr
end

function Character:draw()
	--local thisMap = self.world:getMap();
	--love.graphics.setColor(255,0,0)
	--love.graphics.circle( "fill", self.globalx, self.globaly, 5, 5 )
	--love.graphics.setColor(255, 255, 255)
	if(self.thisAnimation ~= nil) then
		self.thisAnimation:draw(self.globalx-35, self.globaly-58)
	end
end

function Character:drawPath()
	if (self.path and next(self.path) ~= nil) then
		for i, val in ipairs(self.path) do
			local convertcoord = self.world:getTileCoord(val.x, val.y)
			love.graphics.setColor(0,0,255)
			love.graphics.circle( "fill", convertcoord.x, convertcoord.y, 5, 5 )
			love.graphics.setColor(255, 200, 200)
			love.graphics.print(val.i, convertcoord.x+5, convertcoord.y+5)
			love.graphics.setColor(255, 255, 255)
		end
	end
end


function Character:walk(dt)
	if (self.path and next(self.path) ~= nil) then

		if(self.path[self.currpoint] == nil) then
            if(self.loop) then
            	self.path = table.invert2(self.path)
            	self:setCurrpoint(1)
            else
            	self.path = nil
        	end
        else

			local from = Vector2(self.globalx, self.globaly)
			local tocoord = self.world:getTileCoord(self.path[self.currpoint].x, self.path[self.currpoint].y)
			local to = Vector2(tocoord.x, tocoord.y)

			direction = Vector2.direction(from, to) + 180
			print_r(direction)
			if(direction > (23+0) and direction <= (68+0)) then
				self.thisAnimation = self.animations['walk']['dir'][1]
			elseif(direction > (68+0) and direction <= (113+0)) then
				self.thisAnimation = self.animations['walk']['dir'][2]
			elseif(direction > (113+0) and direction <= (158+0)) then
				self.thisAnimation = self.animations['walk']['dir'][3]
			elseif(direction > (158+0) and direction <= (203+0)) then
				self.thisAnimation = self.animations['walk']['dir'][4]
			elseif(direction > (203+0) and direction <= (248+0)) then
				self.thisAnimation = self.animations['walk']['dir'][5]
			elseif(direction > (248+0) and direction <= (293+0)) then
				self.thisAnimation = self.animations['walk']['dir'][6]
			elseif(direction > (293+0) and direction <= (338+0)) then
				self.thisAnimation = self.animations['walk']['dir'][7]
			else
				self.thisAnimation = self.animations['walk']['dir'][8]
			end

			if(Vector2.distance(from, to) < self.pathThreshold) then
	    		--// Если вейпоинты кончились, т.е. это был последний
		        self:setCurrpoint(self.currpoint + 1)
	    	end
	    	--print(to)
		    if(from.x < to.x) then
				from.x = from.x + ((self.speed*2)*dt)
			end
	        if(from.x > to.x) then
	        	from.x = from.x - ((self.speed*2)*dt)
	        end
	        if(from.y < to.y) then
				from.y = from.y + (self.speed*dt)
			end
	        if(from.y > to.y) then
	        	from.y = from.y - (self.speed*dt)
	        end
	        --print(from)
		    self:setGlobalCoord(from)
	    end
	end
	local thisPos = self.world:getCoordTile(self.globalx, self.globaly)
	if(thisPos.x ~= self.oldpos.x or thisPos.y ~= self.oldpos.y) then
		local thisMap = self.world:getMap()
		if(thisMap[thisPos.y][thisPos.x] == 0) then
			thisMap[thisPos.y][thisPos.x] = 2
		end
		thisMap[self.oldpos.y][self.oldpos.x] = 0
		self.oldpos = thisPos
	end
    if(self.thisAnimation ~= nil) then
    	self.thisAnimation:update(dt)
    end
end

function Character:getCoord()
	return self.world:getCoordTile(self.globalx, self.globaly)
end

function Character:getInnerCoord()
	local coords = {x=0, y=0}
	coords['y'] = self.innery
	coords['x'] = self.innerx
	return coords
end

function Character:getEndInnerCoord()
	local coords = {x=0, y=0}
	coords['y'] = self.endy
	coords['x'] = self.endx
	return coords
end

function Character:getGlobalCoord(coord)
	local coords = {x=0, y=0}
	coords['y'] = self.globaly
	coords['x'] = self.globalx
	return coords
end

function Character:getEndGlobalCoord()
	local coords = {x=0, y=0}
	coords['y'] = self.endy
	coords['x'] = self.endx
	return coords
end

function Character:setInnerCoord(x, y)
	self.innerx = x
	self.innery = y
end

function Character:setCurrpoint(point)
	self.currpoint = point
end
function Character:getCurrpoint()
	return self.currpoint
end

function Character:setEndInnerCoord(x, y)
	self.endy = y
	self.endx = x
end

function Character:setEndGlobalCoord(x, y)
	self.endy = y
	self.endx = x
end

function Character:setGlobalCoord(coord)
	self.globalx = coord.x
	self.globaly = coord.y
end

function Character:pathFind(endx, endy, globalx, globaly)
	self:setEndGlobalCoord(globalx, globaly)
	local Jumper = require ("Jumper.init")
  	local walkable = 0
  	local wmap = self.world:getMap();
  	local pathfinder = Jumper(wmap,walkable)
  	local start = self:getCoord()
	local endx, endy = endx,endy
	local stop = false
	if((start['x']~=endx or start['y']~=endy) and (endx > 0 and endy > 0)) then
	  	local path, pathLen = pathfinder:getPath(start['x'], start['y'], endx, endy)
	  	if path then
	  		local newpath = {}
	  		local newpath2 = {}
			local add = true
			
			for i, val in ipairs(path) do
				add = true
				if(path[i+1] ~= nil) then
					
					if(path[i].x > path[i+1].x and path[i].y > path[i+1].y) then
						if(path[i].x - path[i+1].x > 1) then
							for i1=0,path[i].x - path[i+1].x,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x - i1, y=path[i].y - i1}
								add = false
							end
						end
					end
					
					if(path[i].x == path[i+1].x and path[i].y > path[i+1].y) then
						if(path[i].y - path[i+1].y > 1) then
							for i1=0,path[i].y - path[i+1].y,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x, y=path[i].y - i1}
								add = false
							end
						end
					end
					
					if(path[i].x < path[i+1].x and path[i].y > path[i+1].y) then
						if(path[i].y - path[i+1].y > 1) then
							for i1=0,path[i].y - path[i+1].y,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x + i1, y=path[i].y - i1}
								add = false
							end
						end
					end

					if(path[i].x < path[i+1].x and path[i].y == path[i+1].y) then
						if(path[i+1].x - path[i].x > 1) then
							for i1=0,path[i+1].x - path[i].x,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x + i1, y=path[i].y}
								add = false
							end
						end
					end

					if(path[i].x < path[i+1].x and path[i].y < path[i+1].y) then
						if(path[i+1].x - path[i].x > 1) then
							for i1=0,path[i+1].x - path[i].x,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x + i1, y=path[i].y + i1}
								add = false
							end
						end
					end

					if(path[i].x == path[i+1].x and path[i].y < path[i+1].y) then
						if(path[i+1].y - path[i].y > 1) then
							for i1=0,path[i+1].y - path[i].y,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x, y=path[i].y + i1}
								add = false
							end
						end
					end

					if(path[i].x > path[i+1].x and path[i].y < path[i+1].y) then
						if(path[i+1].y - path[i].y > 1) then
							for i1=0,path[i+1].y - path[i].y,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x - i1, y=path[i].y + i1}
								add = false
							end
						end
					end

					if(path[i].x > path[i+1].x and path[i].y == path[i+1].y) then
						if(path[i].x - path[i+1].x > 1) then
							for i1=0,path[i].x - path[i+1].x,1 do 
								newpath[table.count(newpath)+1] = {x=path[i].x - i1, y=path[i].y}
								add = false
							end
						end
					end
				end
				if(add) then
					newpath[table.count(newpath)+1] = {x=path[i].x, y=path[i].y}
				end
			end

			--print_r(newpath)
			local t = 1
			local next = true
			for i, val in ipairs(newpath) do
				if(newpath[i+1] ~= nil) then
					if(newpath2[table.count(newpath2)] ~= nil and newpath2[table.count(newpath2)].x == newpath[i].x and newpath2[table.count(newpath2)].y == newpath[i].y) then
						next=false
					else
						next=true
					end
					if(stop~=true and next==true) then
						newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y, i=t}
						t = t + 1
					end
					if(newpath[i].x > newpath[i+1].x and newpath[i].y > newpath[i+1].y) then
						--Left top
						if(wmap[newpath[i].y][newpath[i].x-1] ~= 0 and wmap[newpath[i].y-1][newpath[i].x] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y-1, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y-1][newpath[i].x] ~= 0 and wmap[newpath[i].y][newpath[i].x-1] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x-1, y=newpath[i].y, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y-1][newpath[i].x] == 1 and wmap[newpath[i].y][newpath[i].x-1] == 1) then
							stop = true
						end
					elseif(newpath[i].x < newpath[i+1].x and newpath[i].y > newpath[i+1].y) then
						--Right top
						--print('Right top')

						if(wmap[newpath[i].y][newpath[i].x+1] ~= 0 and wmap[newpath[i].y-1][newpath[i].x] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y-1, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y-1][newpath[i].x] ~= 0 and wmap[newpath[i].y][newpath[i].x+1] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x+1, y=newpath[i].y, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y-1][newpath[i].x] == 1 and wmap[newpath[i].y][newpath[i].x+1] == 1) then
							stop = true
						end
					elseif(newpath[i].x < newpath[i+1].x and newpath[i].y < newpath[i+1].y) then
						--Right bottom
						--print('Right bottm')
						if(wmap[newpath[i].y+1][newpath[i].x] ~= 0 and wmap[newpath[i].y][newpath[i].x+1] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x+1, y=newpath[i].y, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y][newpath[i].x+1] ~= 0 and wmap[newpath[i].y+1][newpath[i].x] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y+1, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y][newpath[i].x+1] == 1 and wmap[newpath[i].y+1][newpath[i].x] == 1) then
							stop = true
						end
					elseif(newpath[i].x > newpath[i+1].x and newpath[i].y < newpath[i+1].y) then
						--Left bottom
						--print('Left bottm')
						if(wmap[newpath[i].y+1][newpath[i].x] ~= 0 and wmap[newpath[i].y][newpath[i].x-1] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x-1, y=newpath[i].y, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y][newpath[i].x-1] ~= 0 and wmap[newpath[i].y+1][newpath[i].x] ~= 1) then
							newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y+1, i=t}
							t = t + 1
						elseif(wmap[newpath[i].y][newpath[i].x-1] == 1 and wmap[newpath[i].y+1][newpath[i].x] == 1) then
							stop = true
						end
					end
				else
					newpath2[table.count(newpath2)+1] = {x=newpath[i].x, y=newpath[i].y, i=t}
					t = t + 1
				end
	  		end

	  		local newpath3 = {}

	  		for i, val in ipairs(newpath2) do
	  			if(newpath2[i+2] ~= nil) then
	  				if(i==4) then
	  					print(newpath2[i].x, newpath2[i].y, newpath2[i+1].x, newpath2[i+1].y, newpath2[i+2].x, newpath2[i+2].y)
	  				end
	  				if(
	  					(newpath2[i].x == newpath2[i+1].x and newpath2[i].y ~= newpath2[i+1].y and newpath2[i+1].x ~= newpath2[i+2].x and newpath2[i+1].y == newpath2[i+2].y) or 
	  					(newpath2[i].x ~= newpath2[i+1].x and newpath2[i].y == newpath2[i+1].y and newpath2[i+1].x == newpath2[i+2].x and newpath2[i+1].y ~= newpath2[i+2].y) or 
	  					(newpath2[i].x == newpath2[i+1].x and newpath2[i].y ~= newpath2[i+1].y and newpath2[i+1].x ~= newpath2[i+2].x and newpath2[i+1].y == newpath2[i+2].y) or 
	  					(newpath2[i].x ~= newpath2[i+1].x and newpath2[i].y == newpath2[i+1].y and newpath2[i+1].x == newpath2[i+2].x and newpath2[i+1].y ~= newpath2[i+2].y)
	  				) then
	  					print(i, i+1, i+2)
						local vx = 0
						local vy = 0
						local ax = newpath2[i].x
						local ay = newpath2[i].y
						local bx = newpath2[i+1].x
						local by = newpath2[i+1].y
						local cx = newpath2[i+2].x
						local cy = newpath2[i+2].y
						local dx = (ax + cx) / 2
						local dy = (ay + cy) / 2
						vx = bx + (bx-dx)
						vy = by + (by-dy)
						--print(vx, vy)
						local bez = love.math.newBezierCurve({newpath2[i].x, newpath2[i].y, newpath2[i+1].x, newpath2[i+1].y, newpath2[i+2].x, newpath2[i+2].y})
						table.remove(newpath2, i)
						if(vx > 0 and vy > 0) then
							bez:setControlPoint(2, vx, vy)
						end
						bez = bez:render(2)
						for i1=1,table.count(bez),4 do 
							--if(newpath3[table.count(newpath3)] bez[i1])
							newpath3[table.count(newpath3)+1] = {x=bez[i1], y=bez[i1+1], i = 0}
						end
					else
						newpath3[table.count(newpath3)+1] = {x=newpath2[i].x, y=newpath2[i].y, i = i}
	  				end
	  			else
					newpath3[table.count(newpath3)+1] = {x=newpath2[i].x, y=newpath2[i].y, i = i}
	  			end
	  		end

	  		self.path = newpath3
	  		--table.remove(self.path, 1)
	  		--table.remove(self.path, table.maxn(self.path))
	  		if self.path and self.path[1] ~= nil then
				self:setCurrpoint(1)
			end

	  	end
  	end
end