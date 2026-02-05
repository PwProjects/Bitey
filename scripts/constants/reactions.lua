local PET_REACTIONS = {
	["raw-fish"] = {
		emotes = {{
			name = "love",
			interrupt = true
		}, {
			name = "defend",
			interrupt = false
		}}
	},

	["uranium-238"] = {
		emotes = {{
			name = "sick",
			interrupt = true
		}, {
			name = "fear",
			interrupt = false
		}}
	}
}

return {
	PET_REACTIONS = PET_REACTIONS
}
