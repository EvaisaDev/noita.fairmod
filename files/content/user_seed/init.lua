--stylua: ignore start
local user_seeds = {}


--NO RATS ALLOWED, STAY OUT (this means YOU nathan)
local allow_dev_mode = true --set to false to disable dev_mode




local flag = ("edom_repoleved_domriaf"):reverse()

ModSettingRemove(("di_resu.domriaf"):reverse())
ModSettingRemove(("epyt_resu.domriaf"):reverse())

local time = {GameGetDateAndTimeUTC()}
math.randomseed(time[5] * time[6] + time[3] * time[4])
-- SetRandomSeed(time[5] * time[6], time[3] * time[4])

local function GenerateRandomNumber(iterations)
	local number = ""
	for i = 1, iterations do
		number = number .. math.random(0, 9)
	end
	return number
end

local user_seed = ModSettingGet("fairmod.user_seed")

--user_seed = "123456789012345678901234567890" --use this to spoof user_seeds

if not user_seed then
	user_seed = GenerateRandomNumber(30)
	ModSettingSet("fairmod.user_seed", user_seed)
	print("GENERATED USER SEED IS [" .. ModSettingGet("fairmod.user_seed") .. "]")
end

print("USER SEED IS [" .. user_seed .. "]")

local users = {
    --devs
    UserK = {
        seed = "485395615766112676559806489159",
        type = "mod_dev",
    },
    eba = {
        seed = "XXXXXXXX431497468995XXXXXXXXXX",
        type = "mod_dev",
    },
	dexter = {
		seed = "0684181258XXXXXXXXXXXXXXXXXXXX",
		type = "mod_dev",
	},

    --streamers steamid is 765611------------ with dashes being 9-20, pause menu is 1-10
    XaqyzOne = {
        seed = "XXXXXXXX081665557096XXXXXXXXXX",
        type = "streamer",
    },
    LST = {
        seed = "2434295611XXXXXXXXXXXXXXXXXXXX",
        type = "streamer",
    },
    BabaUlai = {
        seed = "XXXXXXXX173447994635XXXXXXXXXX",
        type = "streamer",
    },
    Crimson_Agent = {
        seed = "XXXXXXXX687261862069XXXXXXXXXX",
        type = "streamer",
    },
    DunkOrSlam = {
        seed = "00130639114681086286XXXXXXXXXX",
        type = "streamer",
    },
    chevroletUS = {
        seed = "XXXXXXXX398942599787XXXXXXXXXX",
        type = "streamer",
    },
    xytio = {
        seed = "673499894124810225328899902241",
        type = "streamer",
    },

    --funny numbers
    nearly_nonillionth = { --"wah wah wah these are astronomically unlikely to appear in the lifetime of any human on this earth-" shutup! its funny!
        seed = "999999999999999999999999999999",
        type = "funny_number"
    },
    ["2^99"] = {
        seed = "633825300114114700748351602688",
        type = "funny_number"
    },
    nice = {
        seed = "696969696969696969696969696969",
        type = "funny_number"
    },
    nice_classic = {
        seed = "000000000000000000000000000069",
        type = "funny_number"
    },
    millionth = {
        seed = "000000000000000000000001000000",
        type = "funny_number"
    },

    Daboss = {
        seed = "583423163984904130731284133024",
        type = "other"
    },
}

local function user_seed_match(seed, pattern)
    if seed == pattern then return true end
	if #seed ~= 30 then
		print("Seed: " .. seed .. " not 30 characters")
		return false
	end
	if #pattern ~= 30 then
		print("Pattern: " .. pattern .. " not 30 characters")
		return false
	end

	for i=1,30 do
		local p = pattern:sub(i, i)
		if p ~= "X" and p ~= seed:sub(i, i) then
			return false
		end
	end
	return true
end

local user
for key, value in pairs(users) do
	if user_seed_match(user_seed, value.seed) then
		user = key
		break
	end
end

--if users[user].type == "streamer" and Random(1, 5) == 5 then --20% chance for streamers to not be recognised as a streamer
--    users = nil
--elseif user == nil and Random(1, 30) then --3% chance to play in streamer mode
--    user = { type = "streamer" } --tbh im kinda over the idea of fucking with streamers, it feels funny for a one-time gag, but after discussing it in the thread earlier it feels eh
--end --i kinda only have a streamer type here to begin with cuz i added a mod_dev type so i could have developer cheatcodes, and make the option feel less redundant
--yeah actually im over this, ill re-add it if i actually think of anything funny to attach to this

if user then
	ModSettingSet(("di_resu.domriaf"):reverse(), user)
	ModSettingSet(("epyt_resu.domriaf"):reverse(), users[user].type)
    print(user)
end


user_seeds.OnPlayerSpawned = function(player)
    if ModSettingGet("fairmod.user_id") == "Daboss" then
        local a,b,c,d = EntityGetTransform(player)
        EntitySetTransform(player, a, b, c, d, .8) --lmao short
    end
end

user_seeds.OnWorldInitialized = function() --fairmod.domriaf
	if ModSettingGet(("epyt_resu.domriaf"):reverse()) == "mod_dev" and allow_dev_mode then
		GameAddFlagRun(flag)
	end
end

return user_seeds
--stylua: ignore end
