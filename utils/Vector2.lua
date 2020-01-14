Vector2 = {}

--function Vector2.add(_v1, _v2) -- _v1 + _v2
--	return Vector2(_v1[1] + _v2[1], _v1[2] + _v2[2])
--end

function Vector2.add(_v1, _v2)
	local x
	local y
	if type(_v1) == "number" then
		x = _v1 + _v2[1]
		y = _v1 + _v2[2]
	elseif type(_v2) == "number" then
		x = _v1[1] + _v2
		y = _v1[2] + _v2
	else
		x = _v1[1] + _v2[1]
		y = _v1[2] + _v2[2]
	end
	return Vector2(x, y)
end

function Vector2.sub(_v1, _v2)
	local x
	local y
	if type(_v1) == "number" then
		x = _v1 - _v2[1]
		y = _v1 - _v2[2]
	elseif type(_v2) == "number" then
		x = _v1[1] - _v2
		y = _v1[2] - _v2
	else
		x = _v1[1] - _v2[1]
		y = _v1[2] - _v2[2]
	end
	return Vector2(x, y)
end

function Vector2.multiply(a, b)
	local x
	local y
	if type(a) == "number" then
		x = a * b.x
		y = a * b.y
	elseif type(b) == "number" then
		x = a.x * b
		y = a.y * b
	else
		x = a.x * b.x
		y = a.y * b.y
	end
	return Vector2(x, y)
end

function Vector2.divide(a, b)
	local x
	local y
	if type(a) == "number" then
		x = a / b.x
		y = a / b.y
	elseif type(b) == "number" then
		x = a.x / b
		y = a.y / b
	else
		x = a.x / b.x
		y = a.y / b.y
	end
	return Vector2(x, y)
end
--function Vector2.sub(_v1, _v2) -- _v1 - _v2
--	return Vector2(_v1[1] - _v2[1], _v1[2] - _v2[2])
--end

--function Vector2.multiply(_v1, _n) -- _v1 * _n
--	return Vector2(_v1[1] * _n, _v1[2] * _n)
--end

--function Vector2.divide(_v1, _n) -- _v1 * _n
--	return Vector2(_v1[1] / _n, _v1[2] / _n)
--end

function Vector2.concat(a, b)
	if type(a) == "string" then
		return a .. Vector2.tostring(b)
	elseif type(b) == "string" then
		return Vector2.tostring(a) .. b
	else
		return Vector2.tostring(a) .. Vector2.tostring(b)
	end
end

function Vector2.serialize(v)
	return v
end

function Vector2.tostring(v)
	return v.x .. "," .. v.y
end

function Vector2.unaryMinus(_v) -- -_v
	return Vector2(-_v[1], -_v[2])
end

function Vector2.dotProduct(_v1, _v2) -- _v1 . _v2
	return _v1[1] * _v2[1] + _v1[2] * _v2[2]
end

function Vector2.sqlength(_v) -- |_v|²
	return Vector2.dotProduct(_v, _v)
end

function Vector2.length(_v) -- |_v|
	return math.sqrt(Vector2.sqlength(_v))
end

function Vector2.normalize(_v) -- ||_v||
	local sqlength = Vector2.sqlength(_v)
	if sqlength > 0 then
		return Vector2.divide(_v, math.sqrt(sqlength))
	end
	error("can't normalize a null vector")
end

function Vector2.sqdistance(_v1, _v2) -- |_v2 - _v1|²
	return Vector2.sqlength(Vector2.sub(_v2, _v1))
end

function Vector2.distance(_v1, _v2) -- |_v2 - _v1|
	return Vector2.length(Vector2.sub(_v2, _v1))
end

function Vector2.distanceToPoint(_v1, x, y)
	local _v2 = Vector2(_v1.x - x, _v1.y - y)
	return Vector2.distance(_v1, _v2)
end

function Vector2.equals(_v1, _v2) -- _v1 == _v2
	return _v1[1] == _v2[1] and _v1[2] == _v2[2]
end

function Vector2.direction(_v1, _v2)
	return math.atan2(_v2.y-_v1.y, _v2.x-_v1.x) * 180 / math.pi
end


----------------------------------------------------------------------

local Vector2_aliases = { x = 1, y = 2 }

local Vector2_mt = {}

function Vector2_mt:__index(_key)
	local alias = Vector2_aliases[_key]
	if alias ~= nil then
		return self[alias]
	end
	return Vector2[_key]
end

function Vector2_mt:__newindex(_key, _value)
	local alias = Vector2_aliases[_key]
	if alias ~= nil then
		self[alias] = _value
	end
	rawset(self, _key, _value)
end

Vector2_mt.__tostring = Vector2.tostring
Vector2_mt.__serialize = Vector2.serialize
Vector2_mt.__concat = Vector2.concat
Vector2_mt.__add = Vector2.add
Vector2_mt.__sub = Vector2.sub
Vector2_mt.__mul = Vector2.multiply
Vector2_mt.__div = Vector2.divide
Vector2_mt.__unm = Vector2.unaryMinus
Vector2_mt.__eq = Vector2.equals

setmetatable(Vector2, {
	__call = function(self, _x, _y)
		if type(_x) == "table" then
			assert(_y == nil)
			return setmetatable({ _x[1], _x[2] }, Vector2_mt)
		else
			assert(type(_x) == "number" and type(_y) == "number")
			return setmetatable({ _x, _y }, Vector2_mt)
		end
	end
})