-- TODO: Clean this up.
local debug = require("scripts.util.debug")
local pet_lifecycle = require("scripts.core.pet_lifecycle")
local pet_state = require("scripts.core.pet_state")
local pet_spawn = require("scripts.core.pet_spawn")
local pet_events = require("scripts.core.pet_events")
local pet_visuals = require("scripts.core.pet_visuals")
local pet_animation = require("scripts.core.pet_animation")


local VC = require("scripts.constants.visuals") -- Visuals constants.

local events = {}

function events.on_init()
	storage.biter_pet = storage.biter_pet or {}
	storage.pet_spawn_point = storage.pet_spawn_point or nil

	storage.last_mood = {}
	storage.emote_state = {}

	-- TODO: Maybe move logic below to pet_events module or somewhere more appropriate.
	-- Create neutral game force and add orphan to it.
	if not game.forces["pet_orphan"] then
		game.create_force("pet_orphan")
	end

	local orphan = game.forces["pet_orphan"]
	local enemy = game.forces["enemy"]
	local player_force = game.forces["player"]

	orphan.set_cease_fire(enemy, true)
	enemy.set_cease_fire(orphan, true)

	orphan.set_cease_fire(player_force, true)
	player_force.set_cease_fire(orphan, true)
end

function events.on_load()
	-- Rebind metatables at some point.
end

-- Update migration logic.
function events.on_configuration_changed(cfg)
	storage.last_mood = storage.last_mood or {}
	storage.emote_state = storage.emote_state or {}

	-- TODO: Maybe move logic below to pet_events module or somewhere more appropriate.
	-- Create neutral game force and add orphan to it.
	if not game.forces["pet_orphan"] then
		game.create_force("pet_orphan")
	end

	local orphan = game.forces["pet_orphan"]
	local enemy = game.forces["enemy"]
	local player_force = game.forces["player"]

	orphan.set_cease_fire(enemy, true)
	enemy.set_cease_fire(orphan, true)

	orphan.set_cease_fire(player_force, true)
	player_force.set_cease_fire(orphan, true)
end

function events.on_player_created(event)
	local player = game.get_player(event.player_index)
	local entry = pet_lifecycle.get_pet_entry(player.index)
	-- Find a point to spawn the biter at.
	if not storage.pet_spawn_point then
		storage.pet_spawn_point = pet_spawn.choose_orphan_spawn(player.surface, player.position)
	end

	-- Spawn the biter.
	pet_spawn.spawn_orphan_baby(player, entry)
end

function events.on_tick(event)
	pet_lifecycle.on_tick(event)
	pet_animation.animate_pet_reaction_icon()
end

function events.on_entity_died(event)
	pet_lifecycle.on_entity_died(event)
end

function events.on_cutscene_cancelled(event)
	-- Record game tick when cutscene ended.
	local entry = pet_lifecycle.get_pet_entry(event.player_index)
	pet_events.record_intro_end_tick(event.player_index, entry)
end

return events
