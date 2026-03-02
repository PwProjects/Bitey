local debug = require("scripts.utilities.debug")
local normalize = require("scripts.utilities.normalize")
local pet_state = require("scripts.core.pet_state")
local notifications = require("scripts.utilities.notifications")
local position_util = require("scripts.utilities.position_util")

local MT = require("scripts.constants.thresholds").MORPH_THRESHOLDS
local MM = require("scripts.constants.morph").MORPH_MAP

local pet_morph = {}

local function swap_species(player_index, pet, entry, new_prototype, new_species)
	if not (pet and pet.valid) then return end

	local surface = pet.surface
	local position = pet.position
	local force = pet.force
	normalize.clear_emote_queue(player_index)

	local orientation = pet.orientation or 0
	local direction_index = position_util.direction_from_orientation(orientation)
	pet.destroy()

	local new_pet = surface.create_entity {
		name = new_prototype,
		position = position,
		force = force,
		direction = direction_index
	}

	entry.unit = new_pet
	entry.current_form = "active"
	entry.current_species = new_species
	entry.biter_tier = new_prototype


	local player = game.get_player(player_index)
	local pet = entry.unit
	if (player and player.valid and pet and pet.valid) then position_util.orient_towards_target(pet, player) end

	pet.commandable.set_command {
		type = defines.command.stop,
		distraction = defines.distraction.none
	}
	pet_state.pause(player_index, 120)
	notifications.morph_flavor_text(player, entry)
end

function pet_morph.evaluate_morph_state(player_index, pet, entry, item_name)
	local state = pet_state.get_state(player_index)
	local morph = state.morph
	local rules = MT[entry.current_species]

	if not rules then return end
	if morph ~= rules.threshold then return end

	local normalized_name = normalize.name(pet.name)
	local new_prototype = MM[normalized_name]
	local new_species = rules.new_species

	if not new_prototype then return end
	if item_name ~= rules.trigger then return end

	-- It's morbin' time... I mean morphin' time.
	swap_species(player_index, pet, entry, new_prototype, new_species)
end

return pet_morph
