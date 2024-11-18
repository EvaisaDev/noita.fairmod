dofile("data/scripts/gun/gun.lua")

local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()

local chaotic = {

	NORMAL = {
		PROJECTILES = {},

		STATIC_PROJECTILES = {},

		MODIFIERS = {},

		MATERIALS = {},

		UTILITY = {},

		GLIMMERS = {},
	},

	TMTRAINER = {
		PROJECTILES = {},

		STATIC_PROJECTILES = {},

		MODIFIERS = {},

		probability = 0,
	},

	data = {
		month = month,
		day = day,
	},
}

function IsValidProjectile(spell)
	--if true then return true end --crying and shaking rn, this line of code stumped me for like an hour cuz i forgot it existed :sob:

	if ("," .. spell.spawn_level .. ","):find(",[012456],") then --[[print(spell.id .. " IS VALID")]]
		return true --fancy string shenanigans here and in the modifier script grabbed from Nathan and other lovel ppl from noitacord
	end

	return false
end

function IsValidModifier(spell)
	if ("," .. spell.spawn_level .. ","):find(",[0123456],") then --[[print(spell.id .. " IS VALID")]]
		return true
	end

	return false
end


local tmtrainer
local pandorium_safety = true
for k, data in pairs(actions) do
	--for key, value in pairs(data) do print(key .. ": " .. tostring(value)) end --helpful line that prints out every spell in the game
	if data.pandorium_ignore then goto continue end
	if pandorium_safety and (data.ai_never_uses or data.recursive) then goto continue end

	if data.tm_trainer then --It's a surprise tool that will helps us later!
		if data.type == 0 then
			table.insert(chaotic.TMTRAINER.PROJECTILES, data.id)
		elseif data.type == 1 then
			table.insert(chaotic.TMTRAINER.STATIC_PROJECTILES, data.id)
		elseif data.type == 2 then
			table.insert(chaotic.TMTRAINER.MODIFIERS, data.id)
		elseif data.type == 4 then
			table.insert(chaotic.TMTRAINER.STATIC_PROJECTILES, data.id)
		end
		tmtrainer = true
		goto continue
	end

	if data.id:find("NUKE") then goto continue end
	if data.type == 0 and IsValidProjectile(data) then
		table.insert(chaotic.NORMAL.PROJECTILES, data.id)
	elseif data.type == 1 and IsValidProjectile(data) then
		table.insert(chaotic.NORMAL.STATIC_PROJECTILES, data.id)
	elseif data.type == 2 and IsValidModifier(data) then
		table.insert(chaotic.NORMAL.MODIFIERS, data.id)
	elseif data.type == 4 and IsValidProjectile(data) then
		table.insert(chaotic.NORMAL.STATIC_PROJECTILES, data.id)
	end
	--if data.type == 6 and IsValidProjectile(data) then table.insert(chaotic.UTILITY, data.id) end
	if string.find(data.id, "COLOUR") then table.insert(chaotic.NORMAL.GLIMMERS, data.id) end
	::continue::
end

if tmtrainer then chaotic.TMTRAINER.probability = ModSettingGet("noita.fairmod.cpand_tmtrainer_chance") or 0 end --caching probability here so i dont have to call ModSettingGet a bajillion times in random_spell_chaotic

--unused funni stuff
-- please use the funni stuff -c

local include = {
	COPITH_SUMMON_HAMIS = true,
}

local exclude = {
	ALL_NUKES = true,
	ALL_DISCS = true,
	ALL_ROCKETS = true,
	ALL_DEATHCROSSES = true,
	RANDOM_MODIFIER = true,
}

return chaotic
