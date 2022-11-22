local base = {}

function base:vertical_update(dt)
	local rect = self.rect
	local velocity = self.velocity
	
	velocity.y = velocity.y + (self.game.gravity * dt)
	rect.y = rect.y + (dt * self.velocity.y)

	local ceiling_pos = self.game:tile_world(Vector(rect.x, rect.y))
	local right_ceiling_pos = self.game:tile_world(Vector(rect.x + rect.width, rect.y))
	
	if self.game:tile_at(int(ceiling_pos.x), int(ceiling_pos.y)) > 0 or self.game:tile_at(int(right_ceiling_pos.x), int(right_ceiling_pos.y)) > 0 then
		rect.y = (int(ceiling_pos.y) * self.game.render_tile_size) + rect.height
		velocity.y = math.abs(velocity.y * 0.8)
	end

	local tile_pos = self.game:tile_world(Vector(rect.x, rect.y + rect.height))
	local right_tile_pos = self.game:tile_world(Vector(rect.x + rect.width, rect.y + rect.height))

	self.grounded = false

	if self.game:tile_at(int(tile_pos.x), int(tile_pos.y)) > 0 or self.game:tile_at(int(right_tile_pos.x), int(right_tile_pos.y)) > 0 then
		rect.y = (int(tile_pos.y) * self.game.render_tile_size) - rect.height
		velocity.y = 0
		self.grounded = true
	end

end

function base:horizontal_update(dt)
	local velocity = self.velocity
	local rect = self.rect

	if self.grounded then
		velocity.x = velocity.x * (1 / (1 + dt * 3))
	end

	rect.x = rect.x + velocity.x * dt

	local right = false
	local collided = false

	for i = 1, 2 do
		local left_side = self.game:tile_world(Vector(rect.x, rect.y))
		local right_side = self.game:tile_world(Vector(rect.x + rect.width, rect.y))

		local y_side_offset = i-1

		if self.game:tile_at(int(left_side.x), int(left_side.y + y_side_offset)) > 0 then
			rect.x = (int(left_side.x) * self.game.render_tile_size) + self.game.render_tile_size + .05
			right = true
			collided = true
			break
		end

		if self.game:tile_at(int(right_side.x), int(right_side.y + y_side_offset)) > 0 then
			rect.x = (int(right_side.x) * self.game.render_tile_size) - rect.width - .001
			collided = true
			break
		end
	end

	if not collided then
		return
	end

	if self.grounded or not key.isDown('up') then
		self.velocity.x = 0
	else
		self.velocity.x = -100 + (int(right) * 200)
		self.velocity.y = -300
	end
end

function base:update(dt)
	self.velocity.x = self.velocity.x + ( (int(key.isDown('left')) * -1) + (int(key.isDown('right'))) ) * dt * 400
	-- self.rect.y = self.rect.y + ( (int(key.isDown('up')) * -1) + (int(key.isDown('down'))) ) * dt * 400

	self:vertical_update(dt)
	self:horizontal_update(dt)
	
	if self.grounded and key.isDown('up') then
		self.velocity.y = -300
	end
end

function base:draw()
end

function base:new(game)
	self = setmetatable({
		game = game;
		rect = Rect(0, 0, 30, 50);
		velocity = Vector();
		grounded = false;
	}, {__index = base})

	return self
end

return setmetatable(base, {__call = base.new})

