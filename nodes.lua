-- Nodes

minetest.register_node("moonrealm:stone", {
	description = "Moon Stone",
	tiles = {"moonrealm_stone.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:ironore", {
	description = "Iron Ore",
	tiles = {"moonrealm_stone.png^default_mineral_iron.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:copperore", {
	description = "Copper Ore",
	tiles = {"moonrealm_stone.png^default_mineral_copper.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:goldore", {
	description = "Gold Ore",
	tiles = {"moonrealm_stone.png^default_mineral_gold.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:diamondore", {
	description = "Diamond Ore",
	tiles = {"moonrealm_stone.png^default_mineral_diamond.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:dust", {
	description = "Moon Dust",
	tiles = {"moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("moonrealm:dustprint1", {
	description = "Moon Dust Footprint 1",
	tiles = {"moonrealm_dustprint1.png", "moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("moonrealm:dustprint2", {
	description = "Moon Dust Footprint 2",
	tiles = {"moonrealm_dustprint2.png", "moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("moonrealm:dusttrack", {
	description = "Moon Rover Track",
	tiles = {"moonrealm_dusttrack.png", "moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})


minetest.register_node("moonrealm:waterice", {
	description = "Water Ice",
	tiles = {"default_ice.png"},
	light_source = 1,
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("moonrealm:glass", {
	description = "Glass",
	drawtype = "glasslike",
	tiles = {"default_obsidian_glass.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("moonrealm:light", {
	description = "Light",
	tiles = {"moonrealm_light.png"},
	paramtype = "light",
	light_source = 14,
	is_ground_content = false,
	groups = {dig_immediate = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("moonrealm:stonebrick", {
	description = "Moon Stone Brick",
	tiles = {"moonrealm_stonebricktop.png", "moonrealm_stonebrickbot.png",
		"moonrealm_stonebrick.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:stoneslab", {
	description = "Moon Stone Slab",
	tiles = {"moonrealm_stonebricktop.png", "moonrealm_stonebrickbot.png",
		"moonrealm_stonebrick.png"},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},
	},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("moonrealm:stonestair", {
	description = "Moon Stone Stair",
	tiles = {"moonrealm_stonebricktop.png", "moonrealm_stonebrickbot.png",
		"moonrealm_stonebrick.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	sounds = default.node_sound_stone_defaults(),
})
