local debug = require("scripts.util.debug")
local audio = {}

-- Function feeling cute; might delete later.
function audio.play_sound(player, sound, volume)
	if not (player and player.valid) then
		return
	end

	if not sound then
		return
	end

	debug.info("Playing sound: " .. sound)
	player.play_sound {
		path = sound,
		volume_modifier = volume or 1.0
	}
end

return audio
