--stylua: ignore start
local user_seeds = {}



local allow_dev_mode = true --set to false to disable dev_mode




local flag = ("edom_repoleved_domriaf"):reverse()

user_seeds.OnWorldInitialized = function()
	if ModSettingGet(("epyt_resu"):reverse()) == "mod_dev" then
		GameAddFlagRun(flag)
	end
end
ModSettingRemove(("di_resu"):reverse())
ModSettingRemove(("epyt_resu"):reverse())


local time = {GameGetDateAndTimeUTC()}
SetRandomSeed(time[5] * time[6], time[3] * time[4])

local function GenerateRandomNumber(iterations)
	local number = ""
	for i = 1, iterations do
		number = number .. Random(0, 9)
	end
	return number
end

local user_seed = ModSettingGet("user_seed")
if not user_seed then
	user_seed = GenerateRandomNumber(30)
	ModSettingSet("user_seed", user_seed)
	print("GENERATED USER SEED IS [" .. ModSettingGet("user_seed") .. "]")
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

    --streamers (steamid 765611------------)
    XaqyzOne = {
        seed = "XXXXXXXX081665557096XXXXXXXXXX",
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


if user then
	ModSettingSet(("di_resu"):reverse(), user)
	ModSettingSet(("epyt_resu"):reverse(), users[user].type)
end


return user_seeds
--stylua: ignore end
