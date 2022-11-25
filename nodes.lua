-- Nodes

minetest.register_node("omg_moonrealm:stone", {
	description = "Moon Stone",
	tiles = {"omg_moonrealm_stone.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:ironore", {
	description = "Iron Ore",
	tiles = {"omg_moonrealm_stone.png^default_mineral_iron.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:copperore", {
	description = "Copper Ore",
	tiles = {"omg_moonrealm_stone.png^default_mineral_copper.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:goldore", {
	description = "Gold Ore",
	tiles = {"omg_moonrealm_stone.png^default_mineral_gold.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:diamondore", {
	description = "Diamond Ore",
	tiles = {"omg_moonrealm_stone.png^default_mineral_diamond.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:dust", {
	description = "Moon Dust",
	tiles = {"omg_moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("omg_moonrealm:dustprint1", {
	description = "Moon Dust Footprint 1",
	tiles = {"omg_moonrealm_dustprint1.png", "omg_moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "omg_moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("omg_moonrealm:dustprint2", {
	description = "Moon Dust Footprint 2",
	tiles = {"omg_moonrealm_dustprint2.png", "omg_moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "omg_moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})

minetest.register_node("omg_moonrealm:dusttrack", {
	description = "Moon Rover Track",
	tiles = {"omg_moonrealm_dusttrack.png", "omg_moonrealm_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	drop = "omg_moonrealm:dust",
	sounds = default.node_sound_sand_defaults({
		footstep = {name = "default_sand_footstep", gain = 0.05},
	}),
})


minetest.register_node("omg_moonrealm:waterice", {
	description = "Water Ice",
	tiles = {"default_ice.png"},
	light_source = 1,
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("omg_moonrealm:glass", {
	description = "Glass",
	drawtype = "glasslike",
	tiles = {"default_obsidian_glass.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("omg_moonrealm:light", {
	description = "Light",
	tiles = {"omg_moonrealm_light.png"},
	paramtype = "light",
	light_source = 14,
	is_ground_content = false,
	groups = {dig_immediate = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("omg_moonrealm:stonebrick", {
	description = "Moon Stone Brick",
	tiles = {"omg_moonrealm_stonebricktop.png", "omg_moonrealm_stonebrickbot.png",
		"omg_moonrealm_stonebrick.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("omg_moonrealm:stoneslab", {
	description = "Moon Stone Slab",
	tiles = {"omg_moonrealm_stonebricktop.png", "omg_moonrealm_stonebrickbot.png",
		"omg_moonrealm_stonebrick.png"},
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

minetest.register_node("omg_moonrealm:stonestair", {
	description = "Moon Stone Stair",
	tiles = {"omg_moonrealm_stonebricktop.png", "omg_moonrealm_stonebrickbot.png",
		"omg_moonrealm_stonebrick.png"},
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
