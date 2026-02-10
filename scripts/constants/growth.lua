local GROWTH_SETTINGS = {
	-- NOTE: Change back after debugging evolution.
	DEBUG_IGNORE_EVOLUTION_GATES = true,
	DEBUG_PET_GROWTH_CHANCE = 1,
	DEBUG_BABY_TO_SMALL_THRESHOLD = 0,
	DEBUG_SMALL_TO_LARGE_THRESHOLD = 0,

	-- Default growth chance and evolution factor thresholds.
	PET_GROWTH_CHANCE = 0.25,
	EVOLUTION_HUNGER_THRESHOLD = 15,
	BABY_TO_SMALL_THRESHOLD = 0.06,
	SMALL_TO_LARGE_THRESHOLD = 0.12
}

-- TODO: Update evo_state_thresholds
-- Growth tiers in order.
local GROWTH_RULES = {
	["pet-small-biter-baby"] = {
		next = "pet-small-biter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-small-biter-small"] = {
		next = "pet-small-biter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-small-biter-large"] = {
		next = "pet-medium-biter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-biter-baby"] = {
		next = "pet-medium-biter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-biter-small"] = {
		next = "pet-medium-biter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-biter-large"] = {
		next = "pet-big-biter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-big-biter-baby"] = {
		next = "pet-big-biter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-big-biter-small"] = {
		next = "pet-big-biter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-big-biter-large"] = {
		next = "pet-behemoth-biter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-biter-baby"] = {
		next = "pet-behemoth-biter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-biter-small"] = {
		next = "pet-behemoth-biter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-biter-large"] = {
		next = nil,
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-small-spitter-baby"] = {
		next = "pet-small-spitter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-small-spitter-small"] = {
		next = "pet-small-spitter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-small-spitter-large"] = {
		next = "pet-medium-spitter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-spitter-baby"] = {
		next = "pet-medium-spitter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-spitter-small"] = {
		next = "pet-medium-spitter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-medium-spitter-large"] = {
		next = "pet-large-spitter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-large-spitter-baby"] = {
		next = "pet-large-spitter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-large-spitter-small"] = {
		next = "pet-large-spitter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-large-spitter-large"] = {
		next = "pet-behemoth-spitter-baby",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-spitter-baby"] = {
		next = "pet-behemoth-spitter-small",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-spitter-small"] = {
		next = "pet-behemoth-spitter-large",
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	},
	["pet-behemoth-spitter-large"] = {
		next = nil,
		hunger_threshold = 15,
		evo_factor_threshold = 0.06,
		evo_state_threshold = 0,
		chance = 0.025
	}
}
return {
	GROWTH_SETTINGS = GROWTH_SETTINGS,
	GROWTH_RULES = GROWTH_RULES
}
