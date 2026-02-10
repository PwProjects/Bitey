local debug = require("scripts.util.debug")
local normalize = require("scripts.util.normalize")
local pet_state = require("scripts.core.pet_state")
local t = require("scripts.util.text_format")

local LC = require("scripts.constants.lifecycle")

local SCALING = require("__biter-pet__.shared.scaling")
local SCALE = SCALING.SIZE_SCALE

local pet_state_machine = {}

function pet_state_machine.enter_idle(player_index, pet, entry, destination)
	if entry.wake_state == "idle" then return end
	if not (pet and pet.valid) then return end

	local surface = pet.surface
	local pos = pet.position
	local force = pet.force
	local name = pet.name .. "-idle"
	normalize.clear_emote_queue(player_index)
	pet.destroy()
	debug.trace(string.format("Switching to %s state.", t.f("idle", "f")))
	local idler = surface.create_entity {
		name = name,
		position = pos,
		force = force
	}

	idler.commandable.set_command {
		type = defines.command.wander,
		destination = destination,
		radius = radius,
		distraction = defines.distraction.none
	}

	entry.unit = idler
	entry.wake_state = "idle"
end

function pet_state_machine.enter_active(player_index, entry)
	if not entry.wake_state then return end
	if entry.wake_state == "active" then return end

	local unit = entry.unit
	if not (unit and unit.valid) then return end

	local surface = unit.surface
	local position = unit.position
	local force = unit.force

	local name = normalize.name(unit.name)
	normalize.clear_emote_queue(player_index)
	unit.destroy()

	local active = surface.create_entity {
		name = name,
		position = position,
		force = force
	}

	entry.unit = active
	entry.wake_state = "active"
end

local function get_sleep_animation_name(orientation)
	local suffix = (orientation <= 0.5) and "right" or "left"
	return string.format("pet-sleeping-animation-%s", suffix)
end

function pet_state_machine.enter_sleep(player_index, entry)
	if entry.wake_state == "sleeping" then return end
	local pet = entry.unit
	if not (pet and pet.valid) then return end

	local surface = pet.surface
	local position = pet.position
	local force = pet.force
	local name = normalize.name(pet.name)
	local scale_factor = SCALE[name] * 0.5
	local sleeper_name = string.format("%s%s", name, "-sleeping")
	local animation = get_sleep_animation_name(pet.orientation)
	entry.sleep_direction = pet.orientation
	normalize.clear_emote_queue(player_index)
	pet.destroy()

	local sleeper = surface.create_entity {
		name = sleeper_name,
		position = position,
		force = force
	}

	local id = rendering.draw_animation {
		animation = animation,
		target = sleeper,
		surface = sleeper.surface,
		x_scale = scale_factor,
		y_scale = scale_factor,
		render_layer = "object-under",
		direction = entry.sleep_direction

	}
	game.print(tostring(entry.sleep_direction))
	entry.sleep_animation_id = id

	sleeper.commandable.set_command {
		type = defines.command.stop,
		distraction = defines.distraction.none
	}

	entry.unit = sleeper
	entry.wake_state = "sleeping"

	-- TODO: Add play_sound=true/false to emote table.
	-- TODO: Add custom fade_rate key to emote table.
	-- TODO: Add biter snoring sound if doable.
	-- TODO: Switch from default biter emote roars to snoring sounds if wake_state="sleeping"
	-- TODO: Maybe add custom light color to mood emotes when biter is "dreaming".
	pet_state.force_emote(player_index, entry, "sleeping", false)
end

return pet_state_machine
