local debug = require("scripts.util.debug")
local pet_state = require("scripts.core.pet_state")
local normalize = require("scripts.util.normalize")
local t = require("scripts.util.text_format")

local GROWTH_CONSTANTS = require("scripts.constants.growth")
local GS = GROWTH_CONSTANTS.GROWTH_SETTINGS
local GR = GROWTH_CONSTANTS.GROWTH_RULES
local DC = require("scripts.constants.debug")

local pet_growth = {}

-- Get current tier index.
local function get_tier_index(name)
	for i, tier in ipairs(GC.TIERS) do if tier == name then return i end end
	return 1
end

local function get_growth_chance()
	return (debug.current_level >= 3) and GC.DEBUG_PET_GROWTH_CHANCE or GC.PET_GROWTH_CHANCE
end

local function get_baby_to_small_growth_threshold()
	return (debug.current_level >= 3) and GC.DEBUG_BABY_TO_SMALL_THRESHOLD or GC.BABY_TO_SMALL_THRESHOLD
end

local function get_small_to_large_growth_threshold()
	return (debug.current_level >= 3) and GC.DEBUG_SMALL_TO_LARGE_THRESHOLD or GC.SMALL_TO_LARGE_THRESHOLD
end

local function pet_met_surface_evolution_threshold(growth_threshold, surface)
	local evolution_factor = (GC.DEBUG_IGNORE_EVOLUTION_GATES and 1) or game.forces.enemy.get_evolution_factor(surface)
	local growth_chance = get_growth_chance()
	local dice_roll = math.random()
	debug.info(string.format("%s >= %s and %s < %s", evolution_factor, growth_threshold, dice_roll, growth_chance))
	return evolution_factor >= growth_threshold and math.random() < growth_chance
end

-- Set evolution factor for testing: /c game.forces["enemy"].set_evolution_factor(0.99, game.player.surface)
local function upgrade_pet(player_index, entry, new_name)
	local old_unit = entry.unit
	if not (old_unit and old_unit.valid) then return end
	if normalize.name(old_unit.name) == new_name then return end

	local surface = old_unit.surface
	local position = old_unit.position
	local force = old_unit.force

	debug.info(string.format("Pet evolving from %s to %s.", t.f(old_unit.name, "f"), t.f(new_name, "f")))
	normalize.clear_emote_queue(player_index)

	old_unit.destroy()

	local new_pet = surface.create_entity {
		name = new_name,
		position = position,
		force = force
	}

	new_pet.ai_settings.allow_destroy_when_commands_fail = false
	new_pet.ai_settings.allow_try_return_to_spawner = false

	new_pet.commandable.set_command {
		type = defines.command.wander,
		destination = position,
		radius = 0.1,
		distraction = defines.distraction.none
	}

	entry.unit = new_pet
	entry.biter_tier = new_name
	entry.wake_state = "active"

	local em = pet_state.get_queue(player_index)
end

-- Called immediately after eating.
function pet_growth.try_grow(player_index, entry)
	local pet = entry.unit
	if not (pet and pet.valid) then return end

	local name = normalize.name(pet.name)
	local rule = GR[name]
	if not rule then return end

	-- Pet growth hunger gate.
	local hunger = pet_state.get_hunger(player_index) or 0
	if hunger >= rule.hunger_threshold and not GS.DEBUG_IGNORE_EVOLUTION_GATES then return end

	-- Pet growth evolution factor gate.
	local surface = pet.surface
	local evolution_factor = (GS.DEBUG_IGNORE_EVOLUTION_GATES and 1) or game.forces.enemy.get_evolution_factor(surface)
	if evolution_factor < rule.evo_factor_threshold then return end

	-- Pet growth chance gate.
	local chance = (debug.current_level >= 3) and GS.DEBUG_PET_GROWTH_CHANCE or rule.chance
	if math.random() >= chance then return end

	-- Pet growth evolution state gate.
	local evolution = pet_state.get_evolution(player_index) or 0
	if evolution < rule.evo_state_threshold and not GS.DEBUG_IGNORE_EVOLUTION_GATES then return end

	-- All gate checks passed so perform upgrade.
	upgrade_pet(player_index, entry, rule.next)
end

function pet_growth.try_grow_old(player_index, entry)
	local pet = entry.unit
	if not (pet and pet.valid) then return end

	-- Biter must meet hunger threshold before growth is triggered.
	local hunger = pet_state.get_hunger(player_index) or 0
	if hunger >= GC.EVOLUTION_HUNGER_THRESHOLD and not GC.DEBUG_IGNORE_EVOLUTION_GATES then return end
	local surface = pet.surface
	local normalized_name = normalize.name(pet.name)
	local tier = get_tier_index(normalized_name)

	-- Baby biter to small biter.
	if normalized_name == "pet-small-biter-baby" then
		local growth_chance = get_growth_chance()
		local growth_threshold = get_baby_to_small_growth_threshold(surface)
		if pet_met_surface_evolution_threshold(growth_threshold, surface) then
			upgrade_pet(player_index, entry, "pet-small-biter-small")
			entry.biter_tier = "pet-small-biter-small"
			return
		end
		return
	end

	-- Baby spitter to small spitter.
	if normalized_name == "pet-small-spitter-baby" then
		local growth_chance = get_growth_chance()
		local growth_threshold = get_baby_to_small_growth_threshold(surface)
		if pet_met_surface_evolution_threshold(growth_threshold, surface) then
			upgrade_pet(player_index, entry, "pet-small-spitter-small")
			entry.biter_tier = "pet_small_biter-small"
			return
		end
		return
	end

	-- Small to large biter.
	if normalized_name == "pet-small-biter-small" then
		local growth_chance = get_growth_chance()
		local growth_threshold = get_small_to_large_growth_threshold(surface)
		if pet_met_surface_evolution_threshold(growth_threshold, surface) then
			upgrade_pet(player_index, entry, "pet-small-biter-large")
			entry.biter_tier = "pet-small-biter-large"
		end
		return
	end
end

return pet_growth

-- Implement the growth phases below.
-- pet-small-biter-large to pet-medium-biter-baby
-- pet-medium-biter-baby to pet-medium-biter-small
-- pet-medium-biter-small to pet-medium-biter-large

-- pet-medium-biter-large to pet-big-biter-baby
-- pet-big-biter-baby to pet-big-biter-small
-- pet-big-biter-small to pet-big-biter-large

-- pet-big-biter-large to pet-behemoth-biter-baby
-- pet-behemoth-biter-baby to pet-behemoth-biter-small
-- pet-behemoth-biter-small to pet-behemoth-biter-large

-- pet-small-spitter-baby to pet-small-spitter-small
-- pet-small-spiiter-small to pet-small-spitter-large

-- pet-small-spitter-large to pet-medium-spitter-baby
-- pet-medium-spitter-baby to pet-medium-spitter-small
-- pet-medium-spitter-small to pet-medium-spitter-large

-- pet-medium-spitter-large to pet-big-spitter-baby
-- pet-big-spitter-baby to pet-big-spitter-small
-- pet-big-spitter-small to pet-big-spitter-large

-- pet-big-spitter-large to pet-behemoth-spitter-baby
-- pet-behemoth-spitter-baby to pet-behemoth-spitter-small
-- pet-behemoth-spitter-small to pet-behemoth-spitter-large

-- Large to worry about this later...
