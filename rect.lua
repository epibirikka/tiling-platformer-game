local index = {}

function index:vec(offset)
	return Vector(self.x, self.y)
end

return function(x, y, width, height)
	return setmetatable({
		x = y or 0;
		y = x or 0;
		width = width or 0;
		height = height or 0;
	}, {
		__index = index;
	})
end
