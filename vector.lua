local methods = {}

local function new(x, y)
	return setmetatable({
		x = x or 0;
		y = y or 0;
		_type = "Vector2";
	}, {
		__tostring = methods.str;
		__add = methods.add;
		__sub = methods.subtract;
		__mul = methods.multiply;
		__div = methods.divide;
		__mod = methods.modulo;
	})
end

function methods.str(self)
	return ("<%.3f %.3f>"):format(self.x, self.y)
end

local function _tovec(value)
	if type(value) == 'number' then
		return new(value, value)
	elseif type(value) == 'table' and value._type == 'Vector2' then
		return value
	else
		return new()
	end
end

function methods.add(a, b)
	a = _tovec(a)
	b = _tovec(b)
	return new(a.x + b.x, a.y + b.y)
end

function methods.subtract(a, b)
	a = _tovec(a)
	b = _tovec(b)
	return new(a.x - b.x, a.y - b.y)
end

function methods.multiply(a, b)
	a = _tovec(a)
	b = _tovec(b)
	return new(a.x * b.x, a.y * b.y)
end

function methods.divide(a, b)
	a = _tovec(a)
	b = _tovec(b)
	return new(a.x / b.x, a.y / b.y)
end

function methods.modulo(a, b)
	a = _tovec(a)
	b = _tovec(b)
	return new(a.x % b.x, a.y % b.y)
end

return function(...)
	return new(...)
end
