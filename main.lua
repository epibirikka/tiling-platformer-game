-- bootstrap love namespace
graphics = love.graphics
timer = love.timer
window = love.window
key = love.keyboard

function love.load()
	require('bootstrap')

	window_dimensions = Vector(800, 600)

	window.setMode(window_dimensions.x, window_dimensions.y)
	window.setTitle("tiling platformer game")

	game:init(window_dimensions)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end
