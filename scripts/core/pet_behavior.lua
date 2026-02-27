local audio = require("scripts.utilities.audio")
local debug = require("scripts.utilities.debug")
local notifications = require("scripts.utilities.notifications")
local pet_modifiers = require("scripts.core.pet_modifiers")
local pet_state = require("scripts.core.pet_state")
local position_util = require("scripts.utilities.position_util")

local t = require("scripts.utilities.text_format")

local BM = require("scripts.constants.biters").BITER_MAP
local LC = require("scripts.constants.lifecycle")
local DC = require("scripts.constants.debug")
local ES = require("scripts.constants.events")

local pet_behavior = {}

local function process_intro_notification(player_index, entry)
	local now = game.tick
	local player = game.get_player(player_index)
	if not player then return end

	if not (entry.unit and entry.unit.valid) then return end
	local pet = entry.unit

	if not entry.intro_end_tick or not entry.intro_pet_alert_threshold then
		entry.intro_end_tick = now
		local random_delay = now + ES.MININUM_DELAY_BEFORE_PET_SPAWN_AFTER_INTRO + math.random(0, ES.RANDOM_DELAY_PADDING)
		entry.intro_pet_alert_threshold = random_delay
	end

	if entry.intro_end_tick and not entry.intro_notification_sent then
		if now > entry.intro_pet_alert_threshold or DC.DEBUG_BYPASS_INTRO_DELAY then
			local direction = position_util.get_direction_of_position(player.position, pet.position)
			if direction then notifications.notify(player, string.format("I heard something to the %s...", direction)) end
			entry.intro_notification_sent = true
			audio.play_global_sound(player, "death-rattle")
			player.force.chart(pet.surface, {
				{
					pet.position.x - 4,
					pet.position.y - 4
				},
				{
					pet.position.x + 4,
					pet.position.y + 4
				}
			})
			player.force.add_chart_tag(pet.surface, {
				position = pet.position,
				icon = {
					type = "virtual",
					name = "signal-deny"
				}
			})
		end
	end
end

function pet_behavior.process_events(player_index, entry)
	process_intro_notification(player_index, entry)
end

function pet_behavior.record_intro_cinematic_end_tick(player_index, entry)
	local player = game.get_player(player_index)
	if not player then return end
	if player.controller_type ~= defines.controllers.cutscene then entry.intro_end_tick = game.tick end
end

function pet_behavior.on_research_finished(event)
	local tech = event.research
	if tech.name == "fluid-handling" then
		for _, player in pairs(tech.force.players) do
			if player and player.valid and player.connected then
				debug.info(string.format("%s %s", "Pet thirst unlocked for player", t.f(player.index, "f")))
				local state = pet_state.get_state(player.index)
				state.has_fluid_handling = true
			end
		end
	end
end

function pet_behavior.guard_player_corpse(player_index, entry, pet, position)
	local friendship = pet_state.get_friendship(player_index)
	local happiness_penalty = friendship * -1
	pet_state.set_happiness(player_index, happiness_penalty)

	pet.commandable.set_command {
		type = defines.command.go_to_location,
		destination = position,
		radius = 0.5,
		distraction = defines.distraction.none
	}
	entry.guard_position = position
	entry.guarding_body = true

	pet_state.force_emote(player_index, entry, "defend")
	pet_state.force_emote(player_index, entry, "very-sad")
end

function pet_behavior.pet_senses_danger(player_index, entry, group)
	local pet = entry.unit
	if not (pet and pet.valid) then return end

	pet.commandable.set_command {
		type = defines.command.stop,
		distraction = defines.distraction.none
	}
	position_util.orient_towards_target(pet, group)

	pet_state.pause(player_index, 300)
	pet_state.force_emote(player_index, entry, "alert")
	pet_state.force_emote(player_index, entry, "scared")

	local player = game.get_player(player_index)
	if not (player and player.valid) then return end

	local distance_squared = position_util.distance_squared(pet.position, player.position)
	if distance_squared <= LC.GUARD_RADIUS_SQUARED then
		entry.delayed_commentary = {
			commentary = "pet_senses_danger",
			tick_trigger = game.tick + 60
		}
	end
end

function pet_behavior.reunion_of_friends(player_index, player, entry, pet)
	notifications.player_resurrected_flavor_text(player, entry)
	pet.commandable.set_command {
		type = defines.command.stop,
		distraction = defines.distraction.none
	}
	position_util.orient_towards_target(pet, player)
	pet_state.pause(player_index, 60)
	pet_state.force_emote(player_index, entry, "horrified", true)
	pet_state.force_emote(player_index, entry, "love")
end

return pet_behavior
