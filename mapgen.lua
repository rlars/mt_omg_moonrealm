-- Clear stuff

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()


-- Set mapgen settings

minetest.set_mapgen_setting("mg_name", "flat", true)
minetest.set_mapgen_setting("water_level", -100000, true)
minetest.set_mapgen_setting("mg_flags", "caves,nodungeons,light,nodecorations", true)


-- Register biome

	minetest.register_biome({
		name = "moon",
		--node_dust = "",
		node_top = "omg_moonrealm:dust",
		depth_top = 1,
		node_filler = "omg_moonrealm:dust",
		depth_filler = 2,
		node_stone = "omg_moonrealm:stone",
		--node_water_top = "",
		--depth_water_top = ,
		node_water = "omg_moonrealm:ice",
		node_river_water = "omg_moonrealm:ice",
		--node_riverbed = "",
		--depth_riverbed = ,
		y_min = -31000,
		y_max = 31000,
		heat_point = 50,
		humidity_point = 50,
	})


-- Register ores

	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:ironore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 7 * 7 * 7,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = 0,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:ironore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_min          = -31000,
		y_max          = -64,
	})

	-- Copper

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:copperore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -63,
		y_max          = -16,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:copperore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -64,
	})

	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:goldore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -255,
		y_max          = -64,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:goldore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Mese block

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 18 * 18 * 18,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -255,
		y_max          = -64,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Diamond

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:diamondore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 17 * 17 * 17,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -255,
		y_max          = -128,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:diamondore",
		wherein        = "omg_moonrealm:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Water ice

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "omg_moonrealm:waterice",
		wherein        = "omg_moonrealm:dust",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 1,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = 0,
	})


-- Localise data buffers
local dbuf = {}
-- buffers for 2d perlin noise
local perlin_buf = {}
local perlin_buf_1 = {}
local perlin_buf_2 = {}
local radial_distortion_perlin_buf = {}
local ring_distortion_perlin_buf = {}
-- buffer for heightmap
local height_buf = {}


-- cache for global and regional heights
local cached_craters = {}



-- craters may belong to one of the following categories:
-- + global craters with a size larger than 64^2 / 2
-- + regional craters with a size smaller than 64^2 / 2, but larger than 64
-- + local craters with a size < 64
-- The idea behind it is that these influence the landscape on different scales and so smaller craters can be generated on demand if needed.
-- returns crater parameters; r <= 64
local function create_local_crater_params(rand, grid_x, grid_z)
	local new_crater = {
		x = grid_x + .1 * rand:next(0, 639),
		z = grid_z + .1 * rand:next(0, 639),
		r = math.min(64, .1 * rand:next(90^(1/1.5), 640^(1/1.5))^1.5),
		seed = rand:next(),
		shape = rand:next(0, 63),
		age = rand:next(0, 1E9),
	}
	return new_crater
end

local function create_local_craters_params(minp, maxp)
	local loc_min_x = math.floor(minp.x / 64)
	local loc_min_z = math.floor(minp.z / 64)
	local loc_max_x = math.ceil(maxp.x / 64)
	local loc_max_z = math.ceil(maxp.z / 64)

	local craters = {}

	for loc_z = loc_min_z - 2, loc_max_z + 2 do
		for loc_x = loc_min_x - 2, loc_max_x + 2 do

			local rand = PcgRandom(loc_x + 31 * loc_z)
			local n = math.abs(rand:rand_normal_dist(0, 1))
			--minetest.debug("x: " .. loc_x, ", z: " .. loc_z .. ", n: " .. n)
			for i = 1, n do
				table.insert(craters, create_local_crater_params(rand, loc_x * 64, loc_z * 64))
			end
			--minetest.debug("cx: " .. craters[#craters].x, ", cz: " .. craters[#craters].z .. ", r: " .. craters[#craters].r)
		end
	end
	table.sort(craters, function (a, b) return a.age > b.age end)
	return craters
end


-- returns crater parameters; 64 < r <= 64^2
local function create_regional_crater_params(rand, grid_x, grid_z)
	return {
		x = grid_x + .1 * rand:next(0, 64^2 - 1),
		z = grid_z + .1 * rand:next(0, 64^2 - 1),
		r = math.min(64^2, .1 * rand:next(640^(1/1.5), ((64)^2 / 2 * 10)^(1/1.5))^1.5),
		seed = rand:next(),
		shape = rand:next(0, 63),
		age = rand:next(0, 1E9),
	}
end

local function create_regional_craters_params(minp, maxp)
	local loc_min_x = math.floor(minp.x / 64^2)
	local loc_min_z = math.floor(minp.z / 64^2)
	local loc_max_x = math.ceil(maxp.x / 64^2)
	local loc_max_z = math.ceil(maxp.z / 64^2)

	local craters = {}

	for loc_z = loc_min_z - 1, loc_max_z + 1 do
		for loc_x = loc_min_x - 1, loc_max_x + 1 do

			local rand = PcgRandom(loc_x + 31 * loc_z)
			local n = math.abs(rand:rand_normal_dist(0, 2))
			--minetest.debug("x: " .. loc_x, ", z: " .. loc_z .. ", n: " .. n)
			for i = 1, n do
				table.insert(craters, create_regional_crater_params(rand, loc_x * 64^2, loc_z * 64^2))
				--minetest.debug("x: " .. craters[#craters].x, ", z: " .. craters[#craters].z .. ", r: " .. craters[#craters].r)
			end
		end
	end
	table.sort(craters, function (a, b) return a.age > b.age end)
	return craters
end


--local c_air  = minetest.get_content_id("air")
local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_stone = minetest.get_content_id("omg_moonrealm:stone")
local c_dust = minetest.get_content_id("omg_moonrealm:dust")


local function calc_min_max_r_phi(center_2d, area)
	local center_2d = vector.new(center_2d.x, 0, center_2d.z)
	if area:contains(center_2d.x, 0, center_2d.z) then
		local max_r = math.max(
			vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MinEdge.z)),
			vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MinEdge.z)),
			vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MaxEdge.z)),
			vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MaxEdge.z))
		)
		return 0, max_r, -math.pi, math.pi
	end
	if area:contains(center_2d.x, 0, area.MinEdge.z) then
		-- an x edge is closest
		if center_2d.z > area.MaxEdge.z then
			local min_r = math.abs(center_2d.z - area.MaxEdge.z)
			local max_r = math.max(
				vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MinEdge.z)),
				vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MinEdge.z))
			)
			return min_r, max_r, math.atan2(area.MaxEdge.z - center_2d.z, area.MinEdge.x - center_2d.x), math.atan2(area.MaxEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x)
		elseif center_2d.z < area.MinEdge.z then
			local min_r = math.abs(center_2d.z - area.MinEdge.z)
			local max_r = math.max(
				vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MaxEdge.z)),
				vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MaxEdge.z))
			)
			return min_r, max_r, math.atan2(area.MinEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x), math.atan2(area.MinEdge.z - center_2d.z, area.MinEdge.x - center_2d.x)
		else
			assert(false, "Invalid state")
		end
	elseif area:contains(area.MinEdge.x, 0, center_2d.z) then
		-- a z edge is closest
		if center_2d.x > area.MaxEdge.x then
			local min_r = math.abs(center_2d.x - area.MaxEdge.x)
			local max_r = math.max(
				vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MinEdge.z)),
				vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MaxEdge.z))
			)
			return min_r, max_r, math.atan2(area.MaxEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x), math.atan2(area.MinEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x)
		elseif center_2d.x < area.MinEdge.x then
			local min_r = math.abs(center_2d.x - area.MinEdge.x)
			local max_r = math.max(
				vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MinEdge.z)),
				vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MaxEdge.z))
			)
			return min_r, max_r, math.atan2(area.MinEdge.z - center_2d.z, area.MinEdge.x - center_2d.x), math.atan2(area.MaxEdge.z - center_2d.z, area.MinEdge.x - center_2d.x)
		else
			assert(false, "Invalid state")
		end
	else
		if center_2d.x > area.MaxEdge.x and center_2d.z > area.MaxEdge.z then
			local min_r = vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MaxEdge.z))
			local max_r = vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MinEdge.z))
			return min_r, max_r, math.atan2(area.MaxEdge.z - center_2d.z, area.MinEdge.x - center_2d.x), math.atan2(area.MinEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x)
		elseif center_2d.x > area.MaxEdge.x and center_2d.z < area.MinEdge.z then
			local min_r = vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MinEdge.z))
			local max_r = vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MaxEdge.z))
			return min_r, max_r, math.atan2(area.MaxEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x), math.atan2(area.MinEdge.z - center_2d.z, area.MinEdge.x - center_2d.x)
		elseif center_2d.x < area.MinEdge.x and center_2d.z < area.MinEdge.z then
			local min_r = vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MinEdge.z))
			local max_r = vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MaxEdge.z))
			return min_r, max_r, math.atan2(area.MinEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x), math.atan2(area.MaxEdge.z - center_2d.z, area.MinEdge.x - center_2d.x)
		elseif center_2d.x < area.MinEdge.x and center_2d.z > area.MaxEdge.z then
			local min_r = vector.distance(center_2d, vector.new(area.MinEdge.x, 0, area.MaxEdge.z))
			local max_r = vector.distance(center_2d, vector.new(area.MaxEdge.x, 0, area.MinEdge.z))
			return min_r, max_r, math.atan2(area.MinEdge.z - center_2d.z, area.MinEdge.x - center_2d.x), math.atan2(area.MaxEdge.z - center_2d.z, area.MaxEdge.x - center_2d.x)
		else
			assert(false, "Invalid state")
		end
	end
	assert(false, "Invalid state")
end


RadialNoise = {}
RadialNoise.__index = RadialNoise

-- area: VoxelArea
-- perlin_buf_1, perlin_buf_2: buffers for values and mirrored angle values
function RadialNoise.new(seed, center_2d, r, area, perlin_buf_1, perlin_buf_2)
	local min_r, max_r, min_phi, max_phi = calc_min_max_r_phi(center_2d, area)
	--minetest.debug("center_2d: " .. center_2d.x .. ", " .. center_2d.z)
	--minetest.debug("area: " .. dump(area))
	--minetest.debug("min_r: " .. min_r)
	--minetest.debug("max_r: " .. max_r)
	--minetest.debug("min_phi: " .. min_phi)
	--minetest.debug("max_phi: " .. max_phi)
	local r_ceil = math.ceil(r)
	local x_spread = math.ceil(2 * r^(1/1.8)) + 1 -- multiply by 2, because coordinates are scaled by roughly 0.5 in the interesting area
	local y_spread = math.floor(1/12 * x_spread)
	local octaves = math.min(3, math.floor(math.log(y_spread)))
	assert(octaves >= 1)

	if min_r <= 1E-9 then
		local r_stride = math.ceil(max_r) - math.floor(min_r) + 1
		local phi_stride = 2 * math.ceil(2 * math.pi * r_ceil) + 1
		--minetest.debug("r_stride: " .. r_stride)
		--minetest.debug("phi_stride: " .. phi_stride)
		local perlin_map = minetest.get_perlin_map({
			offset = 0,
			scale = 1,
			spread = {x = x_spread, y = y_spread, z = y_spread},
			seed = seed,
			octaves = octaves,
			persistence = 0.63,
			lacunarity = 2.0,
			flags = "defaults", --, absvalue
			},
			{ x = phi_stride, y = r_stride } -- 3 ~ math.pi
		)
		perlin_map:get_2d_map_flat({ x = - 2 * math.pi * r_ceil, y = math.floor(min_r) }, perlin_buf_1)
		local radial_noise = {
			min_r = min_r,
			max_r = max_r,
			min_phi = -math.pi,
			max_phi = math.pi,
			perlin_buf_1 = perlin_buf_1,
			perlin_buf_2 = perlin_buf_1,
			r_stride = r_stride,
			phi_stride = phi_stride,
			r_ceil = r_ceil
		}
		setmetatable(radial_noise, RadialNoise)
		return radial_noise
	end

	local phi_1_start = math.floor(2 * min_phi * r_ceil)
	local phi_1_end = math.ceil(2 * max_phi * r_ceil)
	local phi_2_start = math.floor(- 2 * max_phi * r_ceil)
	local phi_2_end = math.ceil(- 2 * min_phi * r_ceil)
	if min_phi > max_phi then
		assert(min_phi > 0 and max_phi < 0, "including 0 is not supported by algorithm!")
		local common_phi = math.min(math.abs(min_phi), math.abs(max_phi))
		phi_1_start = math.floor(2 * common_phi * r_ceil)
		phi_1_end = math.ceil(2 * math.pi * r_ceil)
		phi_2_start = math.floor(- 2 * math.pi * r_ceil)
		phi_2_end = math.ceil(- 2 * common_phi * r_ceil)
	end
	assert(phi_1_end - phi_1_start == phi_2_end - phi_2_start)

	local r_stride = math.ceil(max_r) - math.floor(min_r) + 1
	local phi_stride = phi_1_end - phi_1_start + 1
	--minetest.debug("r_stride: " .. r_stride)
	--minetest.debug("phi_stride: " .. phi_stride)
	local perlin_map = minetest.get_perlin_map({
			offset = 0,
			scale = 1,
			spread = {x = x_spread, y = y_spread, z = y_spread},
			seed = seed,
			octaves = octaves,
			persistence = 0.63,
			lacunarity = 2.0,
			flags = "defaults", --, absvalue
		},
		{ x = phi_stride, y = r_stride, z = 100 } -- 3 ~ math.pi
	)
	perlin_map:get_2d_map_flat({ x = phi_1_start, y = math.floor(min_r) }, perlin_buf_1)
	perlin_map:get_2d_map_flat({ x = phi_2_start, y = math.floor(min_r) }, perlin_buf_2)
	local radial_noise = {
		min_r = min_r,
		max_r = max_r,
		min_phi = min_phi,
		max_phi = max_phi,
		perlin_buf_1 = perlin_buf_1,
		perlin_buf_2 = perlin_buf_2,
		r_stride = r_stride,
		phi_stride = phi_stride,
		r_ceil = r_ceil
	}
	setmetatable(radial_noise, RadialNoise)
	return radial_noise
end

function RadialNoise:calc_radial_noise(phi, r)
	assert(phi >= self.min_phi or phi <= self.max_phi)
	assert(r >= self.min_r - 1, "r must be at least " .. self.min_r .. ", but is " .. r .. "!")
	assert(r <= self.max_r + 1, "r must be at most " .. self.max_r .. ", but is " .. r .. "!")
	local ir = math.ceil(r - self.min_r)
	local iphi = 0
	local iphi_inv = 0
	if self.min_phi < self.max_phi then
		iphi = math.ceil(2 * (phi - self.min_phi) * self.r_ceil)
		iphi_inv = math.ceil(2 * (self.max_phi - phi) * self.r_ceil)
	else
		local common_phi = math.min(math.abs(self.min_phi), math.abs(self.max_phi))
		if phi <= self.max_phi then
			-- phi in [-pi, max_phi]
			iphi = math.ceil(2 * (phi + math.pi) * self.r_ceil)
			iphi_inv = math.ceil(2 * (- phi - common_phi) * self.r_ceil)
		elseif phi >= self.min_phi then
			-- phi in [min_phi, pi]
			iphi = math.ceil(2 * (phi - common_phi) * self.r_ceil)
			iphi_inv = math.ceil(2 * (math.pi - phi) * self.r_ceil)
		else
			assert(false, "Invalid state")
		end
	end
	assert(iphi >= 0)
	assert(iphi < self.phi_stride)
	assert(iphi_inv >= 0)
	assert(iphi_inv < self.phi_stride)
	
	local x = 0
	local y = 0
	
	if self.min_r <= 1E-9 then
		x = self.perlin_buf_1[1 + ir * self.phi_stride + iphi]
		y = self.perlin_buf_1[1 + ir * self.phi_stride + iphi_inv]
		if (not x) or (not y) then
			minetest.debug("ir: " .. ir)
			minetest.debug("iphi: " .. iphi)
			minetest.debug("iphi_inv: " .. iphi_inv)
		end
	elseif self.min_phi < self.max_phi then
		x = self.perlin_buf_1[1 + ir * self.phi_stride + iphi]
		y = self.perlin_buf_2[1 + ir * self.phi_stride + iphi_inv]
		if (not x) or (not y) then
			minetest.debug("ir: " .. ir)
			minetest.debug("iphi: " .. iphi)
			minetest.debug("iphi_inv: " .. iphi_inv)
		end
	else
		if phi <= self.max_phi then
			x = self.perlin_buf_2[1 + ir * self.phi_stride + iphi]
			y = self.perlin_buf_1[1 + ir * self.phi_stride + iphi_inv]
			if (not x) or (not y) then
				minetest.debug("ir: " .. ir)
				minetest.debug("iphi: " .. iphi)
				minetest.debug("iphi_inv: " .. iphi_inv)
			end
		elseif phi >= self.min_phi then
			x = self.perlin_buf_1[1 + ir * self.phi_stride + iphi]
			y = self.perlin_buf_2[1 + ir * self.phi_stride + iphi_inv]
			if (not x) or (not y) then
				minetest.debug("ir: " .. ir)
				minetest.debug("iphi: " .. iphi)
				minetest.debug("iphi_inv: " .. iphi_inv)
			end
		end
	end
	local s = phi / math.pi
	assert(s >= -1)
	assert(s <= 1)
	local a = s < 0 and 1 + 0.5 * s or 1 - 0.5 * s
	local b = s < 0 and - 0.5 * s or 0.5 * s
	return (a * x + b * y) / math.sqrt(a * a + b * b)
end


-- phi in [-pi, pi], r in [0, 2 * crater_r]
-- perlin_flat must have shape 2 * crater_r x 12 * crater_r
local function calc_radial_noise(perlin_flat, phi, r, crater_r)
	local ir = math.ceil(r)
	local iphi = math.ceil(2 * 3 * (phi / math.pi + 1) * crater_r)
	assert(iphi >= 0)
	assert(iphi <= 12 * crater_r)
	local x = perlin_flat[ir * 12 * crater_r + iphi]
	local y = perlin_flat[ir * (12 * crater_r + 1) - iphi + 1]
	if not x or not y then
		minetest.debug("r " .. r .. " / " .. crater_r .. " (ir: " .. ir .. ")")
		minetest.debug("phi " .. phi.. " (iphi: " .. iphi .. ")")
		return 0
	end
	local s = phi / math.pi
	assert(s >= -1)
	assert(s <= 1)
	local a = s < 0 and 1 + 0.5 * s or 1 - 0.5 * s
	local b = s < 0 and - 0.5 * s or 0.5 * s
	return (a * x + b * y) / math.sqrt(a * a + b * b) --* r / crater_r
end

-- phi in [-pi, pi]
-- perlin_flat must have shape 1 x 12 * crater_r
local function calc_radial_noise_1d(perlin_flat, phi, crater_r)
	local iphi = math.ceil(2 * 3 * (phi / math.pi + 1) * crater_r)
	assert(iphi >= 0)
	assert(iphi <= 12 * crater_r)
	local x = perlin_flat[iphi]
	local y = perlin_flat[12 * crater_r - iphi + 1]
	if not x or not y then
		minetest.debug("r " .. r .. " / " .. crater_r .. " (ir: " .. ir .. ")")
		minetest.debug("phi " .. phi.. " (iphi: " .. iphi .. ")")
		return 0
	end
	local s = phi / math.pi
	assert(s >= -1)
	assert(s <= 1)
	local a = s < 0 and 1 + 0.5 * s or 1 - 0.5 * s
	local b = s < 0 and - 0.5 * s or 0.5 * s
	return (a * x + b * y) / math.sqrt(a * a + b * b) --* r / crater_r
end

local function initialize_2d_buffer(buf, va)
	-- fill buffer if needed
	--if not buf[va:index(va.MaxEdge.x, 0, va.MaxEdge.z)] then
		for index in va:iter(va.MinEdge.x, 0, va.MinEdge.z, va.MaxEdge.x, 0, va.MaxEdge.z) do
			buf[index] = 0
		end
	--end
end

-- calculate factors for sin, cos
local function angle_to_factors(phi)
	if math.abs(phi) > math.pi / 2 and math.abs(phi) < math.pi * 3/2 then
		local cotangens = math.cos(phi) / math.sin(phi)
		local b = 1 / math.sqrt(1 + cotangens * cotangens)
		return -b * cotangens, b
	else
		local a = 1 / math.sqrt(1 + math.tan(phi) * math.tan(phi))
		return a, -a * math.tan(phi)
	end
end

local function apply_crater(crater, va, height_buf, mean_height)
	local minp = va.MinEdge
	local maxp = va.MaxEdge
	local start_x = math.max(math.floor(crater.x - 2 * crater.r), minp.x)
	local end_x = math.min(math.ceil(crater.x + 2 * crater.r), maxp.x)
	local start_z = math.max(math.floor(crater.z - 2 * crater.r), minp.z)
	local end_z = math.min(math.ceil(crater.z + 2 * crater.r), maxp.z)

	if start_x > end_x or start_z > end_z then return end

	if not mean_height then mean_height = 0 end

	local age_scale = 1 - crater.age / 1.05E9

	local crater_r_ceil = math.ceil(crater.r)

	local rand = PcgRandom(crater.shape)

	local radial_octaves = math.min(7, math.floor(math.log(crater_r_ceil)))

	local radial_distortion_perlin_map = minetest.get_perlin_map({
			offset = 0,
			scale = age_scale,
			spread = {x = 500, y = 2 * 2 * 3 * crater_r_ceil, z = 500},
			seed = rand:next(),
			octaves = radial_octaves,
			persistence = 0.63,
			lacunarity = 2.0,
			flags = "defaults",
		},
		{ x = 1, y = 2 * 2 * 3 * crater_r_ceil } -- 3 ~ math.pi
	)
	radial_distortion_perlin_map:get_2d_map_flat({ x = 0, y = 0 }, radial_distortion_perlin_buf)

	local ring_distortion_perlin_map = minetest.get_perlin_map({
			offset = 0,
			scale = age_scale,
			spread = {x = 500, y = 2 * 2 * 3 * crater_r_ceil, z = 500},
			seed = rand:next(),
			octaves = radial_octaves,
			persistence = 0.63,
			lacunarity = 2.0,
			flags = "defaults, absvalue",
		},
		{ x = 1, y = 2 * 2 * 3 * crater_r_ceil } -- 3 ~ math.pi
	)
	ring_distortion_perlin_map:get_2d_map_flat({ x = 0, y = 0 }, ring_distortion_perlin_buf)

	local perlin_map = minetest.get_perlin_map({
			offset = 0,
			scale = age_scale,
			spread = {x = 14, y = 14, z = 14},
			seed = rand:next(),
			octaves = 3,
			persistence = 0.63,
			lacunarity = 2.0,
			flags = "defaults", --, absvalue
		},
		{ x = end_x - start_x + 1, y = end_z - start_z + 1 } -- 3 ~ math.pi
	)
	perlin_map:get_2d_map_flat({ x = start_x, y = start_z }, perlin_buf)
	local vn = VoxelArea:new({MinEdge={x=start_x, y=0, z=start_z}, MaxEdge={x=end_x, y=0, z=end_z}})

	local radial_seed = rand:next()
	local radial_noise = crater.r > 200 and RadialNoise.new(radial_seed, {x=crater.x, y=0, z=crater.z}, crater.r, vn, perlin_buf_1, perlin_buf_2) or nil

	local phi_1 = rand:next(0, 359) / 360 * math.pi
	local e_1 = 0--rand:rand_normal_dist(-20, 20) / 40
	local phi_2 = rand:next(0, 359) / 360 * math.pi
	local e_2 = rand:rand_normal_dist(-70, 70) / 90
	local a, b = angle_to_factors(phi_1)
	-- the scale to distort the radius with noise
	local r_noise_scale = 0.25

	for z = start_z, end_z do
		for x = start_x, end_x do
			local dx = x - crater.x
			local dz = z - crater.z
			local phi = math.atan2(dz, dx)
			local dr_1 = e_1 * (a * math.sin(.5 * (phi + math.pi) + phi_1) + b * math.cos(.5 * (phi + math.pi) + phi_1))
			local r_noise = r_noise_scale * calc_radial_noise_1d(radial_distortion_perlin_buf, phi, crater_r_ceil)
			local dr_2 = e_2 * math.sin(phi + phi_2)
			local s_r = crater.r * (1 + dr_1 + dr_2 + r_noise) / (1 + e_1 + e_2 + 2 * r_noise_scale)
			local dr = (dx * dx + dz * dz) / s_r
			local another_dr = (dx * dx + dz * dz) / crater.r
			local k = 0
			local height_scale = crater.r / 11 * age_scale

			local height_preserve = 1

			if dr < 1.5 * s_r then
				local ring_width_factor = 0.5 + 0.2 * math.abs(calc_radial_noise_1d(ring_distortion_perlin_buf, phi, crater_r_ceil))
				local a = 1/ring_width_factor^2 * (3 * 2.4 + 2 / ring_width_factor) --4 * (3 * 2.4 + 4)
				local p = 1 - 1 / (3 * 2.4 + 2 / ring_width_factor) --1 - 1 / (3 * 2.4 + 4)
				local rns_a = - (2/(1 + ring_width_factor - 3/4))^2
				local t = dr / s_r -- in [0, 1.5]
				local radial_noise_scale = math.max(0, rns_a * (t - 3/4) * (t - (1 + ring_width_factor) ) )
				local radial_noise_val = radial_noise and 4 * radial_noise_scale * radial_noise:calc_radial_noise(phi, math.sqrt(dx * dx + dz * dz)) or 0
				if dr < s_r then
					k = height_scale * (2.3 * t^2.4 - 1.8) + radial_noise_val
					height_preserve = t^2.7
				else
					local ring_val = t < 1 + ring_width_factor and 0.5 * (1 - (t-1) / ring_width_factor) or 0 --t < 1 + ring_width_factor and (t - (1 + ring_width_factor)) * (t - (1 + ring_width_factor)) * (t - p) * a or 0
					k = height_scale * ring_val + radial_noise_val
				end
			end

			height_buf[va:index(x, 0, z)] = k + mean_height + height_preserve * (height_buf[va:index(x, 0, z)] - mean_height) + perlin_buf[vn:index(x, 0, z)]
		end
	end
	--minetest.debug("applied crater with mean_height: " .. mean_height)
end

-- calculate the height offsets as a flat array
local function apply_craters(craters, va, height_buf)
	for _, crater in ipairs(craters) do
		apply_crater(crater, va, height_buf)
	end
end


-- create a heightmap based on global noise and global craters
local function get_global_craters()
	local test_crater = {
		x = 0,
		z = -60.0,
		r = 2*102.4,
		shape = 0,
		age = 6E8,
		seed = 0,
	}
	local another_crater = {
		x = 333.5,
		z = 245.4,
		r = 561.73388717435,
		shape = 4,
		age = 690181860,
		seed = 1644878644,
	}
	local craters = {}
	craters[1] = test_crater
	return craters
end


local function filter_affecting_craters(craters, va, min_age)
	local filtered_craters = {}
	for _, crater in ipairs(craters) do
		if crater.age > min_age then
			local min_r, max_r, min_phi, max_phi = calc_min_max_r_phi({x = crater.x, y = 0, z = crater.z}, va)
			if min_r < 2 * crater.r then
				table.insert(filtered_craters, crater)
			end
		end
	end
	return filtered_craters
end


local function get_mean_height_at_crater_center(crater, with_regionals)
	local cache_address = crater.x .. "," .. crater.z .. "," .. math.floor(crater.r)
	local cached_crater = cached_craters[cache_address]
	if cached_crater then
		return cached_crater.mean_height
	end

	local center_radius = math.sqrt(crater.r)
	local min_edge = vector.new(math.floor(crater.x - 2*center_radius), 0, math.floor(crater.z - 2*center_radius))
	local max_edge = vector.new(math.ceil(crater.x + 2*center_radius), 0, math.ceil(crater.z + 2*center_radius))
	local va = VoxelArea:new({MinEdge = min_edge, MaxEdge = max_edge})
	local height_buf = {}
	initialize_2d_buffer(height_buf, va)

	local global_craters = filter_affecting_craters(get_global_craters(), va, crater.age)
	local regional_craters = with_regionals and filter_affecting_craters(create_regional_craters_params(min_edge, max_edge), va, crater.age) or {}

	local global_craters_index = 1
	local regional_craters_index = 1
	while global_craters_index <= #global_craters or regional_craters_index <= #regional_craters do
		local next_global = global_craters[global_craters_index]
		local next_regional = regional_craters[regional_craters_index]
		local next_crater = nil
		if not next_global then
			next_crater = next_regional
			regional_craters_index = regional_craters_index + 1
		elseif not next_regional then
			next_crater = next_global
			global_craters_index = global_craters_index + 1
		elseif next_global.age >= next_regional.age then
			next_crater = next_global
			global_craters_index = global_craters_index + 1
		else
			next_crater = next_regional
			regional_craters_index = regional_craters_index + 1
		end
		apply_crater_with_center_calc(next_crater, va, height_buf, true)
	end
	local sum = 0
	local sum_points = 0
	local curvature = 0
	for index in va:iter(va.MinEdge.x, 0, va.MinEdge.z, va.MaxEdge.x, 0, va.MaxEdge.z) do
		-- use round stencil
		local pos = va:position(index)
		local dist = math.sqrt((pos.x - crater.x)^2 + (pos.z - crater.z)^2)
		if dist < 2 * center_radius then
			curvature = curvature + (-dist / (2*center_radius) + math.sqrt(1/2)) * height_buf[index]
			if dist < center_radius then
				sum = sum + height_buf[index]
				sum_points = sum_points + 1
			end
		end
	end
	local mean_height =  1 / sum_points * sum
	local mean_curvature = 1 / (4 * math.pi * center_radius) * curvature
	--minetest.debug("mid: " .. height_buf[va:index(math.floor(0.5*(va.MinEdge.x + va.MaxEdge.x)), 0, math.floor(0.5*(va.MinEdge.z + va.MaxEdge.z)))])
	--minetest.debug("mean: " .. mean_height)
	--minetest.debug("curvature: " .. mean_curvature)
	cached_craters[cache_address] = {
		mean_height = mean_height
	}
	return mean_height + 0 * mean_curvature
end


function apply_crater_with_center_calc(crater, va, height_buf, with_regionals)
	--minetest.debug("apply_crater_with_center_calc--------------------------------")
	--minetest.debug("crater.x: " .. crater.x)
	--minetest.debug("crater.z: " .. crater.z)
	--minetest.debug("crater.r: " .. crater.r)
	--minetest.debug("crater.age: " .. crater.age)
	--minetest.debug("crater.shape: " .. crater.shape)
	--minetest.debug("crater.seed: " .. crater.seed)
	local mean_height = get_mean_height_at_crater_center(crater, with_regionals)
	--minetest.debug("mean_height: " .. mean_height)
	apply_crater(crater, va, height_buf, mean_height)
end


-- filter out smaller craters that are overwritten by a larger, younger one
function filter_overwritten_craters(large_craters, small_craters)
	local new_small_craters = {}
	for _, small_crater in ipairs(small_craters) do
		local is_overwritten = false
		for _, large_crater in ipairs(large_craters) do
			if small_crater.age >= large_crater.age then
				local distance = vector.distance(
					vector.new(small_crater.x, 0, small_crater.z),
					vector.new(large_crater.x, 0, large_crater.z))
				if distance < large_crater.r then
					is_overwritten = true
				end
			end
		end
		if not is_overwritten then table.insert(new_small_craters, small_crater) end
	end
	return new_small_craters
end


local function mg_generate(minp, maxp, emin, emax, vm)
	--minetest.debug("mg_generate for")
	--minetest.debug("minp: " .. dump(minp))
	--minetest.debug("maxp: " .. dump(maxp))
	--minetest.debug("emin: " .. dump(emin))
	--minetest.debug("emax: " .. dump(emax))
	local glob_craters = get_global_craters()
	local reg_craters = create_regional_craters_params(minp, maxp)
	local all_loc_craters = create_local_craters_params(minp, maxp)
	local loc_craters = filter_overwritten_craters(reg_craters, filter_overwritten_craters(get_global_craters(), all_loc_craters))

	local sorted_craters = {}
	for _, crater in ipairs(glob_craters) do table.insert(sorted_craters, crater) end
	for _, crater in ipairs(reg_craters) do table.insert(sorted_craters, crater) end
	for _, crater in ipairs(loc_craters) do table.insert(sorted_craters, crater) end
	
	table.sort(sorted_craters, function (a, b) return a.age > b.age end)
	
	local data = vm:get_data()
	local data_va = VoxelArea:new{
		MinEdge={x=emin.x, y=emin.y, z=emin.z},
		MaxEdge={x=emax.x, y=emax.y, z=emax.z},
	}
	local inner_va = VoxelArea:new({MinEdge={x=minp.x, y=0, z=minp.z}, MaxEdge={x=maxp.x, y=0, z=maxp.z}})
	
	--minetest.debug("local_craters_count: " .. #loc_craters)

	local t1 = os.clock()

	initialize_2d_buffer(height_buf, inner_va)
	for _, crater in ipairs(sorted_craters) do
		apply_crater_with_center_calc(crater, inner_va, height_buf, true)
	end
	
	local t4 = os.clock()
	
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- find highest non-vacuum block
			local height = minp.y
			for y = maxp.y, minp.y, -1 do
				local vi = data_va:index(x, y, z)
				if data[vi] ~= c_vacuum then
					height = y
					break
				end
			end			
			if x == minp.x and z == minp.z then minetest.debug("height: " .. dump(height)) end
			local new_height = height_buf[inner_va:index(x, 0, z)] -- + height_stamp[inner_va:index(x, 0, z)]

			for cur_height = math.min(math.floor(new_height + .5), maxp.y), height, -1 do
				local vi = data_va:index(x, cur_height, z)
				data[vi] = c_dust
			end
			for cur_height = height, math.max(math.ceil(new_height + .5), minp.y), -1 do
				local vi = data_va:index(x, cur_height, z)
				data[vi] = c_vacuum
			end
		end
	end
	
	local t5 = os.clock()

	vm:set_data(data)

	vm:write_to_map()
	
	local t6 = os.clock()
	minetest.debug("Timings --------------------------------------------")
	minetest.debug("apply craters: " .. t4 - t1)
	minetest.debug("insert into data table: " .. t5 - t4)
	minetest.debug("set_data and write_to_map: " .. t6 - t5)
end


minetest.register_on_generated(function(minp, maxp, seed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	--if emin.x > -40 or emax.x < 40 or emin.y > -20 or emax.y < 20 or emin.z > -40 or emax.z < 40 then return end
	mg_generate(minp, maxp, emin, emax, vm)
end)
