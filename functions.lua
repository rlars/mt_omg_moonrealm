

-- Player positions, spacesuit texture status
-- Set gravity and skybox, override light

local player_pos = {}
local player_pos_previous = {}
local player_spacesuit = {} -- To avoid unnecessary resetting of character model

local skytextures = {
	"omg_moonrealm_posy.png",
	"omg_moonrealm_negy.png",
	"omg_moonrealm_posz.png",
	"omg_moonrealm_negz.png",	
	"omg_moonrealm_negx.png",
	"omg_moonrealm_posx.png",
}

minetest.register_on_joinplayer(function(player)
	player_pos_previous[player:get_player_name()] = {x = 0, y = 0, z = 0}

	player:set_sky({r = 0, g = 0, b = 0, a = 0}, "skybox", skytextures, false)
	player:override_day_night_ratio(1)
end)

minetest.register_on_leaveplayer(function(player)
	player_pos_previous[player:get_player_name()] = nil
	player_spacesuit[player:get_player_name()] = nil
end)


-- Globalstep function

local FOOT = false

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do

		-- Footprints
		if FOOT and not default.player_attached[player:get_player_name()] and
				math.random() < 0.15 and
				player_pos_previous[player:get_player_name()] ~= nil then
			local pos = player:getpos()
			player_pos[player:get_player_name()] = {
				x = math.floor(pos.x + 0.5),
				y = math.floor(pos.y + 0.2),
				z = math.floor(pos.z + 0.5)
			}
			local p_ground = {
				x = math.floor(pos.x + 0.5),
				y = math.floor(pos.y + 0.4),
				z = math.floor(pos.z + 0.5)
			}
			local n_ground  = minetest.get_node(p_ground).name
			local p_groundpl = {
				x = math.floor(pos.x + 0.5),
				y = math.floor(pos.y - 0.5),
				z = math.floor(pos.z + 0.5)
			}
			if player_pos[player:get_player_name()].x ~=
					player_pos_previous[player:get_player_name()].x or
					player_pos[player:get_player_name()].y <
					player_pos_previous[player:get_player_name()].y or
					player_pos[player:get_player_name()].z ~=
					player_pos_previous[player:get_player_name()].z then
				if n_ground == "omg_moonrealm:dust" then
					if math.random() < 0.5 then
						minetest.add_node(
							p_groundpl,
							{name = "omg_moonrealm:dustprint1"}
						)
					else
						minetest.add_node(
							p_groundpl,
							{name = "omg_moonrealm:dustprint2"}
						)
					end
				end
			end
			player_pos_previous[player:get_player_name()] = {
				x = player_pos[player:get_player_name()].x,
				y = player_pos[player:get_player_name()].y,
				z = player_pos[player:get_player_name()].z
			}
		end
	end
end)
