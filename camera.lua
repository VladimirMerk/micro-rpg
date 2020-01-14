camera = {}
camera._x = 0
camera._y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.width = love.graphics.getWidth()
camera.height = love.graphics.getHeight()
function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, 0, 10000) --длина доступной области в х
  else
    self._x = value
  end
end

function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, 0, 1000) --ширина доступной области в y
  else
    self._y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:setCenter(x, y)
  if x then self:setX(x-(self.width/2)*self.scaleX) end
  if y then self:setY(y-(self.height/2)*self.scaleY) end
end

function camera:mousePosition()
  return love.mouse.getX() * self.scaleX + self._x, love.mouse.getY() * self.scaleY + self._y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:getVisBounds(shift)
  return {x1 = camera._x+shift, y1 = camera._y+shift, x2 = camera._x + self.width*self.scaleX-shift, y2 = camera._y + self.height*self.scaleY-shift}
end