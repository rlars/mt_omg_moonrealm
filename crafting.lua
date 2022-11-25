-- Crafting

minetest.register_craft({
	output = "default:water_source",
	recipe = {
		{"moonrealm:waterice"},
	},
})

minetest.register_craft({
	output = "moonrealm:stonebrick 4",
	recipe = {
		{"moonrealm:stone", "moonrealm:stone"},
		{"moonrealm:stone", "moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "moonrealm:stoneslab 4",
	recipe = {
		{"moonrealm:stone", "moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "moonrealm:stonestair 4",
	recipe = {
		{"moonrealm:stone", ""},
		{"moonrealm:stone", "moonrealm:stone"},
	}
})

minetest.register_craft({
	output = "moonrealm:light 8",
	recipe = {
		{"moonrealm:glass", "moonrealm:glass", "moonrealm:glass"},
		{"moonrealm:glass", "default:mese", "moonrealm:glass"},
		{"moonrealm:glass", "moonrealm:glass", "moonrealm:glass"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "moonrealm:light 1",
	recipe = {"moonrealm:glass", "default:mese_crystal"},
})

