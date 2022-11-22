local base = {
	gravity = 500;
}

function base:init(viewport_dimensions)
	self.player = Player(self)
	self.camera = Vector()

	self.viewport_dimensions = viewport_dimensions
	self.render_tile_size = 45

	self.render_tiles = Vector(
		math.floor(viewport_dimensions.x / self.render_tile_size),
		math.floor(viewport_dimensions.y / self.render_tile_size)
	)

	self.level = {
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		{0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
		{0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1};
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1};
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1};
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1};
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0};
		{0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1};
		{0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1};
		{0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1};
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
	}
end

function base:update(dt)
	self.player:update(dt)
	
	self.camera = self.camera + ((self.player.rect:vec() - (self.viewport_dimensions * 0.5)) - self.camera) * (dt * 10)

	self.camera.x = math.max(self.camera.x, 0)
	self.camera.y = math.min(self.camera.y, 0)
end

function base:draw()
	graphics.setColor(1, 1, 1)
	self:draw_level()
	graphics.setColor(1, 0.35, 0.65)

	graphics.push()
	graphics.translate(-self.camera.x, -self.camera.y)
	graphics.rectangle('fill', self.player.rect.x, self.player.rect.y, self.player.rect.width, self.player.rect.height)
	graphics.pop()
end

function base:tile_at(x, y)
	x = x + 1
	y = y + 1

	if self.level[y] == nil or self.level[y][x] == nil then
		return 0
	end

	return self.level[y][x]
end

function base:tile_world(vec)
	return vec / self.render_tile_size
end

function base:draw_level()
	local render_size = self.render_tile_size

	local offset = self:tile_world(self.camera) 
	local mod = self.camera % render_size

	offset.x = int(offset.x)
	offset.y = int(offset.y)

	for y = -1, self.render_tiles.y+1 do
		for x = -1, self.render_tiles.x+1 do
			local t = Vector(x, y) + offset

			if self:tile_at(t.x, t.y) > 0 then
				graphics.rectangle('fill', render_size * x - mod.x, render_size * y - mod.y, render_size, render_size)
			end
		end
	end


	graphics.print(("camera at %s"):format(tostring(self.camera)))
	graphics.print(("camera/render_size at %s | %s"):format(tostring(offset), tostring(mod)), 0, 20)
end

return base
