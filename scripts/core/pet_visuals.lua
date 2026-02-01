local debug = require("scripts.util.debug")
local pet_audio = require("scripts.core.pet_audio")

local VC = require("scripts.constants.visuals") -- Visuals constants.

local pet_visuals = {}

local EMOTE_MAP = {
	-- General emotes.
	home = {
		sprite = "entity/biter-spawner"
	},
	sleeping = {
		sprite = "virtual-signal/signal-battery-low"
	},
	work = {
		sprite = "virtual-signal/signal-mining",
		color = {
			r = 1,
			g = 0.5,
			b = 0,
			a = 1
		}
	},
	investigate = {
		sprite = "virtual-signal/signal-info"
	},
	tired = {
		sprite = "virtual-signal/signal-battery-mid-level"
	},
	alert = {
		sprite = "virtual-signal/signal-alert"
	},
	-- Combat emotes.
	attack = {
		sprite = "item/submachine-gun"
	},
	stay = {
		sprite = "virtual-signal/signal-map-marker"
	},
	biter = {
		sprite = "entity/medium-biter"
	},
	fire = {
		sprite = "virtual-signal/signal-fire",
		color = {
			r = 1,
			g = 0.2,
			b = 0,
			a = 1
		}
	},
	defend = {
		sprite = "entity/character"
	},
	patrol = {
		sprite = "virtual-signal/signal-white-flag",
		color = {
			r = 0,
			g = 0,
			b = 0.8,
			a = 1
		}
	},
	scared = {
		sprite = "virtual-signal/signal-ghost",
		color = {
			r = 0.1,
			g = 0.8,
			b = 0.1,
			a = 1
		}
	},
	-- Feeding emotes.
	hungry = {
		sprite = "item/raw-fish"
	},
	thirsty = {
		sprite = "fluid/water"
	},
	morphing = {
		sprite = "virtual-signal/signal-radioactivity"
	},
	-- Boredom emotes.
	bored = {
		sprite = "virtual-signal/signal-hourglass",
		color = {
			r = 0,
			g = 1,
			b = 1,
			a = 1
		}
	},
	play = {
		sprite = "item/wood"
	},
	mischievous = {
		sprite = "item/explosives"
	},
	confused = {
		sprite = "entity/atomic-bomb-wave"
	},
	-- Sadness emotes.
	ecstatic = {
		sprite = "virtual-signal/signal-skull" -- Placeholder.
	},
	very_happy = {
		sprite = "virtual-signal/signal-skull" -- Placeholder.
	},
	happy = {
		sprite = "virtual-signal/signal-skull" -- Placeholder.
	},
	sad = {
		sprite = "virtual-signal/signal-skull" -- Placeholder.
	},
	crying = {
		sprite = "virtual-signal/signal-skull" -- Placeholder.
	},
	-- Loyalty emotes.
	love = {
		sprite = "virtual-signal/signal-heart"
	},
	gift = {
		sprite = "item/wooden-chest"
	},
	hurt = {
		sprite = "entity/behemoth-biter-die"
	},
	angry = {
		sprite = "fluid/steam"
	}
}

function pet_visuals.emote(player_index, entry, key, play_audio)

	local pet = entry.unit
	local data = EMOTE_MAP[key]
	local sprite = (data and data.sprite) or key
	local color = (data and data.color) or {
		r = 1,
		g = 1,
		b = 1,
		a = 1
	}

	local render_id = pet_visuals.show_pet_reaction(pet, sprite, color)

	if play_audio then
		pet_audio.play_for_size(player_index, entry)
	end

	return render_id
end

function pet_visuals.show_pet_reaction(pet, sprite, color)
	if not (pet and pet.valid) then
		return
	end

	local target = {
		entity = pet,
		offset = {0, VC.EMOTE_VERTICAL_OFFSET}
	}

	local render_id = rendering.draw_sprite {
		sprite = sprite,
		target = target,
		tint = color,
		surface = pet.surface,
		x_scale = VC.EMOTE_SCALE,
		y_scale = VC.EMOTE_SCALE
	}

	local light_id = rendering.draw_light {
		sprite = "utility/light_small",
		target = target,
		surface = pet.surface,
		intensity = 0.5,
		scale = 0.4
	}

	storage.pet_emote_anim_queue = storage.pet_emote_anim_queue or {}
	table.insert(storage.pet_emote_anim_queue, {
		id = render_id,
		color = color,
		target = target,
		fade = VC.EMOTE_FADE_RATE,
		pet = pet,
		start_tick = game.tick,
		light_id = light_id
	})
	return render_id
end

function pet_visuals.animate_pet_reaction_icon()
	-- Pet reaction animations and lighting.
	local peaq = storage.pet_emote_anim_queue
	if not peaq or #peaq == 0 then
		return
	end

	for i = #peaq, 1, -1 do
		local render = peaq[i]

		if not (render.id and render.id.valid) then
			table.remove(peaq, i)
		else
			local age = game.tick - render.start_tick
			local dec_value = math.max(0, render.color.a - age * render.fade)
			
			-- Fade out sprite.
			render.color = {
				r = render.color.r,
				g = render.color.g,
				b = render.color.b,
				a = dec_value
			}
			render.light_id.intensity = math.max(0, dec_value)
			
			-- Destroy sprite and light source if they're invisible.
			if dec_value <= 0 then
				render.id.destroy()
				render.light_id.destroy()
				table.remove(peaq, i)
			end
		end
	end
end

return pet_visuals
