
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/noita.fairmod/files/content/loan_shark/append_hm.lua")
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/noita.fairmod/files/content/loan_shark/append_hm.lua")
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local module = {}

local debt_timer = 0

local lerp = function(a, b, t)
	return a + (b - a) * t
end

local loan_shark_goons = {
	{
		debt = 0,
		entity = "data/entities/animals/rat.xml",
		count = {1, 3},
	},
	{
		debt = 200,
		entity = "data/entities/animals/shotgunner.xml",
		count = {1, 2},
	},
	{
		debt = 500,
		entity = "data/entities/animals/scavenger_smg.xml",
		count = {1, 3},
	},
	{
		debt = 2000,
		entity = "data/entities/animals/necromancer_shop.xml",
		count = {1},
	},
	{
		debt = 6000,
		entity = "data/entities/animals/necromancer_super.xml",
		count = {1},
	},
}

local function GetGoon(debt)
	-- get goon with highest debt that is less than the player's debt
	local goon = nil
	for i, g in ipairs(loan_shark_goons) do
		if(g.debt <= debt)then
			goon = g
		end
	end

	return goon
end

module.update = function()
	local players = GetPlayers()

	if(#players == 0)then
		return
	end

	local player = players[1]

	local debt = tonumber(GlobalsGetValue("loan_shark_debt", "0"))

	if(debt > 0)then
		debt_timer = debt_timer + 1
		local max_interval = 5 * 60 * 60
		local min_interval = 10 * 60

		local interval = lerp(min_interval, max_interval, 1 - math.min(1, debt / 10000))

		if(debt_timer > interval)then
			debt_timer = 0
			local x, y = EntityGetTransform(player)

			SetRandomSeed( GameGetFrameNum() + x, y )
			
			-- get correct goon
			local goon = GetGoon(debt)
			if(goon == nil)then
				GamePrint("No goon found for debt: " .. debt)
				return
			end

			GamePrint("The Loanprey has sent some goons after you!")

			local count = Random(goon.count[1], goon.count[2])

			for i=1,count do
				-- get random direction
				local random_x = Random(-1, 1)
				local random_y = Random(-1, 1)

				local hit, x, y = Raytrace(x, y, x + random_x * 100, y + random_y * 100)
				
				EntityLoad(goon.entity, x, y)
			end
		end
	else
		debt_timer = 0
	end

end

return module