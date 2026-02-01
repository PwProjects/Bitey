-- TODO: Move constants to constants folder.
-- TODO: Change remnants to just spawn biter corpses and a broken tank or something.
local pet_nest = {}

local DECORATIVES = {
	"green-hairy-grass",
	"muddy-stump",
	"green-carpet-grass"
}

local REMNANTS = {
	"curved-rail-a-remnants",
	"curved-rail-b-remnants",
	"half-diagonal-rail-remnants",
	"straight-rail-remnants",
	"transport-belt-remnants",
	"wall-remnants"
}

local function random_offset(radius)
	return {
		x = (math.random() * radius * 2) - radius,
		y = (math.random() * radius * 2) - radius
	}
end

function pet_nest.decorate(surface, position)
	-- Scatter decoratives.
	for i = 1, 12 do
		local deco = DECORATIVES[math.random(#DECORATIVES)]
		local offset = random_offset(3)

		surface.create_decoratives {
			check_collision = false,
			decoratives = {
				{
					name = deco,
					position = {
						position.x + offset.x,
						position.y + offset.y
					},
					amount = 1
				}
			}
		}
	end

	-- Scatter remants.
	for i = 1, 3 do
		local rem = REMNANTS[math.random(#REMNANTS)]
		local offset = random_offset(2)

		surface.create_entity {
			name = rem,
			position = {
				position.x + offset.x,
				position.y + offset.y
			},
			force = "neutral"
		}
	end

	offset = random_offset(2)
	surface.create_entity {
		name = "medium-biter-corpse",
		position = {
			position.x + offset.x,
			position.y + offset.y
		},
		force = "neutral"
	}
end

return pet_nest
