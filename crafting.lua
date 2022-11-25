-- Crafting

minetest.register_craft({
	output = "default:water_source",
	recipe = {
		{"omg_moonrealm:waterice"},
	},
})

minetest.register_craft({
	output = "omg_moonrealm:stonebrick 4",
	recipe = {
		{"omg_moonrealm:stone", "omg_moonrealm:stone"},
		{"omg_moonrealm:stone", "omg_moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "omg_moonrealm:stoneslab 4",
	recipe = {
		{"omg_moonrealm:stone", "omg_moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "omg_moonrealm:stonestair 4",
	recipe = {
		{"omg_moonrealm:stone", ""},
		{"omg_moonrealm:stone", "omg_moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "omg_moonrealm:light 8",
	recipe = {
		{"omg_moonrealm:glass", "omg_moonrealm:glass", "omg_moonrealm:glass"},
		{"omg_moonrealm:glass", "default:mese", "omg_moonrealm:glass"},
		{"omg_moonrealm:glass", "omg_moonrealm:glass", "omg_moonrealm:glass"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "omg_moonrealm:light 1",
	recipe = {"omg_moonrealm:glass", "default:mese_crystal"},
})

