data:extend({
	{
		type = "optimized-particle",
		name = "memorial-wisp",
		life_time = 90,
		fade_away_duration = 30,
		render_layer = "light-effect",
		movement_modifier = 0.01,
		vertical_acceleration = -0.001,
		regular_trigger_effect_frequency = 2,

		pictures = {
			{
				filename = "__biter-pet__/graphics/particles/basic-particle.png",
				width = 32,
				height = 32,
				frame_count = 4,
				line_length = 4,
				draw_as_glow = true,
				blend_mode = "additive",
				animation_speed = 0.01,
				scale = 0.25
			}
		}
	},
	{
		type = "explosion",
		name = "memorial-wisp-spawner",
		animations = {
			{
				filename = "__biter-pet__/graphics/particles/basic-particle.png",
				width = 32,
				height = 32,
				frame_count = 4,
				line_length = 4,
				priority = "low",
				draw_as_glow = true,
				blend_mode = "additive",
				animation_speed = 0.001,
				scale = 0.01
			}
		},
		created_effect = {
			type = "cluster",
			cluster_count = 10,
			distance = 1.5,
			distance_deviation = 1,
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						particle_name = "memorial-wisp",
						probability = 0.2,
						only_when_visible = true,
						offsets = {{0, 5}},
						offset_deviation = {
							{
								-4.0,
								0.5
							},
							{
								4.0,
								0.5
							}
						},
						initial_height = 0.5,
						frame_speed_deviation = 0.1,
						speed_from_center = 0.001,
						speed_from_center_deviation = 0.01,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.001,
						initial_vertical_speed_deviation = 0.01,
					}
				}
			}
		}
	}

})
