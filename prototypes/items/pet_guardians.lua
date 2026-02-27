local function apply_glow_to_animation(animation_block)
	if not (animation_block and animation_block.layers) then return end

	local body_layer = animation_block.layers[1]
	local glow_layer = table.deepcopy(body_layer)

	local function path_swap(old_path)
		local filename = old_path:match("([^/]+)$")
		local new_filename = filename:gsub("%.png", "-glow.png")
		return "__biter-pet__/graphics/masks/" .. new_filename
	end

	if glow_layer.filenames then
		for i, path in ipairs(glow_layer.filenames) do glow_layer.filenames[i] = path_swap(path) end
	elseif glow_layer.filename then
		glow_layer.filename = path_swap(glow_layer.filename)
	end

	if glow_layer.hr_version then
		if glow_layer.hr_version.filenames then
			for i, path in ipairs(glow_layer.hr_version.filenames) do glow_layer.hr_version.filenames[i] = path_swap(path) end
		elseif glow_layer.hr_version.filename then
			glow_layer.hr_version.filename = path_swap(glow_layer.hr_version.filename)
		end
	end

	glow_layer.draw_as_glow = true
	glow_layer.blend_mode = "additive"
	glow_layer.tint = {
		r = 0.2,
		g = 0.2,
		b = 1.0,
		a = 0.5
	}

	table.insert(animation_block.layers, glow_layer)
end

local function apply_base_tint(animation_block)
	if not (animation_block and animation_block.layers) then return end
	local body_layer = animation_block.layers[1]
	body_layer.tint = {r = 0.5, g = 0.7, b = 1.0, a = 1.0}
	if body_layer.hr_version then body_layer.hr_version.tint = base_color end
end

local function add_all_glow_masks(prototype)
	local states = {
		"ending_attack_animation",
		"folded_animation",
		"folding_animation",
		"prepared_alternative_animation",
		"prepared_animation",
		"preparing_animation",
		"starting_attack_animation"
	}

	for _, state in ipairs(states) do
		if prototype[state] then
			apply_base_tint(prototype[state])
			apply_glow_to_animation(prototype[state])
		end
	end
end

local small = table.deepcopy(data.raw["turret"]["small-worm-turret"])
small.name = "memorial-small-worm"
add_all_glow_masks(small)

local medium = table.deepcopy(data.raw["turret"]["medium-worm-turret"])
medium.name = "memorial-medium-worm"
add_all_glow_masks(medium)

local big = table.deepcopy(data.raw["turret"]["big-worm-turret"])
big.name = "memorial-big-worm"
add_all_glow_masks(big)

local behemoth = table.deepcopy(data.raw["turret"]["behemoth-worm-turret"])
behemoth.name = "memorial-behemoth-worm"
add_all_glow_masks(behemoth)

data:extend{
	small,
	medium,
	big,
	behemoth
}
