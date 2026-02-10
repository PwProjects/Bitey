local NEEDS_CONSTANTS = {

	DEFAULT_INTERVALS = {
		mood = 60 * 30, -- Mood recalculation tick interval.
		hunger = 60 * 30, -- Hunger increment tick interval.
		thirst = 60 * 60, -- Thirst increment tick interval.
		boredom = 60 * 120 -- Boredoem increment tick interval.
	},

	-- Use /bpmoods to switch to high-frequency intervals.
	DEBUG_INTERVALS = {
		mood = 60 * 5,
		hunger = 60 * 5,
		thirst = 60 * 5,
		boredom = 60 * 5
	},

	MOOD_RECALCULATION_INTERVAL = 60 * 50,
	HUNGER_INCREMENT = 1, -- Hunger added every hunger interval.
	THIRST_INCREMENT = 1, -- Thirst added every thirst interval.
	BOREDOM_INCREMENT = 1, -- Boredom added every boredom interval.

	-- Mood penalties for extreme physiological states.
	SEVERE_HUNGER_PENALTY = -3,
	SEVERE_THIRST_PENALTY = -2,
	SEVERE_BOREDOM_PENALTY = -1,
	SEVERE_SADNESS_PENALTY = -1
}

return {
	NEEDS_CONSTANTS = NEEDS_CONSTANTS
}
