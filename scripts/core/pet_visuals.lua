local debug = require("scripts.util.debug")
local pet_audio = require("scripts.core.pet_audio")
local util = require("util")

local VC = require("scripts.constants.visuals") -- Visuals constants.

local pet_visuals = {}

local EMOTE_MAP = {
	-- General emotes.
	alert = {
		sprite = "virtual-signal/signal-alert"
	},
	home = {
		sprite = "entity/biter-spawner"
	},
	investigate = {
		sprite = "investigate"
	},
	sleeping = {
		sprite = "sleeping"
	},
	tired = {
		sprite = "virtual-signal/signal-battery-low"
	},
	work = {
		sprite = "virtual-signal/signal-mining"
	},
	-- Combat emotes.
	attack = {
		sprite = "item/submachine-gun"
	},
	biter = {
		sprite = "entity/medium-biter"
	},
	defend = {
		sprite = "entity/character"
	},
	fire = {
		sprite = "virtual-signal/signal-fire"
	},
	patrol = {
		sprite = "virtual-signal/signal-white-flag"
	},
	scared = {
		sprite = "scared"
	},
	stay = {
		sprite = "virtual-signal/signal-map-marker"
	},
	-- Feeding emotes.
	hungry = {
		sprite = "item/raw-fish"
	},
	morphing = {
		sprite = "virtual-signal/signal-radioactivity"
	},
	sick = {
		sprite = "sick"
	},
	thirsty = {
		sprite = "fluid/water"
	},
	-- Boredom emotes.
	bored = {
		sprite = "bored"
	},
	confused = {
		sprite = "confused"
	},
	mischievous = {
		sprite = "silly"
	},
	play = {
		sprite = "item/wood"
	},
	playing_dead = {
		sprite = "playing-dead"
	},
	-- Happiness emotes.
	ecstatic = {
		sprite = "ecstatic" -- Placeholder.
	},
	very_happy = {
		sprite = "very-happy" -- Placeholder.
	},
	happy = {
		sprite = "happy" -- Placeholder.
	},
	sad = {
		sprite = "sad" -- Placeholder.
	},
	very_sad = {
		sprite = "very-sad" -- Placeholder.
	},
	-- Friendship emotes.
	angry = {
		sprite = "angry"
	},
	gift = {
		sprite = "item/wooden-chest"
	},
	hurt = {
		sprite = "entity/behemoth-biter-die"
	},
	love = {
		sprite = "virtual-signal/signal-heart"
	}
}

function pet_visuals.emote(player_index, entry, emote, fast_render)
	local pet = entry.unit
	local data = EMOTE_MAP[emote]
	local sprite = (data and data.sprite) or emote

	local sprite_render = pet_visuals.show_pet_reaction(player_index, entry, sprite, fast_render)

	pet_audio.play_for_size(player_index, entry)

	return sprite_render
end

function pet_visuals.show_pet_reaction(player_index, entry, sprite, fast_render)
	local fast_render = fast_render or false
	if not (entry and entry.unit and entry.unit.valid) then
		return
	end

	local pet = entry.unit
	if not (pet and pet.valid) then
		return
	end

	local target = {
		entity = pet,
		offset = {0, VC.EMOTE_VERTICAL_OFFSET}
	}
	if fast_render then
		debug.info("Fast render enabled for sprite [img=" .. sprite .. "].")
	else
		debug.info("Standard render enabled for sprite [img=" .. sprite .. "].")
	end
	local sprite_id = rendering.draw_sprite {
		sprite = sprite,
		target = target,
		surface = pet.surface,
		x_scale = VC.EMOTE_SCALE,
		y_scale = VC.EMOTE_SCALE,
		time_to_live = VC.TIME_TO_LIVE_FALLBACK
	}

	local light_id = rendering.draw_light {
		sprite = VC.EMOTE_LIGHT_SPRITE,
		target = target,
		surface = pet.surface,
		intensity = VC.EMOTE_LIGHT_VALUE,
		scale = VC.EMOTE_LIGHT_VALUE,
		time_to_live = VC.TIME_TO_LIVE_FALLBACK
	}

	local sprite_render = {
		sprite = sprite_id,
		light = light_id,
		color = {
			r = 1,
			g = 1,
			b = 1,
			a = 1
		},
		start_tick = game.tick,
		fade = VC.EMOTE_FADE_RATE,
		player_index = player_index,
		entry = entry,
		fast_render = fast_render
	}

	storage.pet_emote_sprite_queue = storage.pet_emote_sprite_queue or {}
	table.insert(storage.pet_emote_sprite_queue, sprite_render)

	return sprite_render
end

return pet_visuals
