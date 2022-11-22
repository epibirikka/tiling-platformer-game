game = require('game')
Player = require('player')
Vector = require('vector')
Rect = require('rect')

function int(val)
	local type = type(val)	

	if type == 'number' then
		return math.floor(val)
	elseif type == 'boolean' then
		return val and 1 or 0
	end
end
