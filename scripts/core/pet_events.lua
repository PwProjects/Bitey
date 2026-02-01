local debug = require("scripts.util.debug")
local notifications = require("scripts.util.notifications")
local position = require("scripts.util.position")

-- TODO: Move costants to constants folder.
local MININUM_DELAY_AFTER_INTRO = 60 * 60 -- 1 minute.
local RANDOM_PADDING = 60 * 30 -- 30 seconds.

local pet_events = {}

local function process_intro_notification(player_index, entry)
	local now = game.tick
	local player = game.get_player(player_index)

	if not player then
		return
	end

	if not (entry.unit and entry.unit.valid) then
		return
	end

	local pet = entry.unit

	if not (entry.intro_end_tick or entry.intro_pet_alert_threshold) then
		entry.intro_end_tick = now
		local random_delay = now + MININUM_DELAY_AFTER_INTRO + math.random(0, RANDOM_PADDING)
		entry.intro_pet_alert_threshold = random_delay
	end

	if entry.intro_end_tick and not entry.intro_notification_sent then
		if now > entry.intro_pet_alert_threshold then
			local direction = position.get_direction_of_position(player.position, pet.position)
			notifications.notify(player, pet, {
				type = "entity",
				name = "small-biter"
			}, "You hear a strange noise coming from the " .. direction .. ".")
			entry.intro_notification_sent = true
		end
	end
end

function pet_events.process_events(player_index, entry)
	process_intro_notification(player_index, entry)
end

function pet_events.record_intro_end_tick(player_index, entry)
	local player = game.get_player(player_index)
	if not player then
		return
	end
	if player.controller_type ~= defines.controllers.cutscene then
		entry.intro_end_tick = game.tick
	end

end

return pet_events
