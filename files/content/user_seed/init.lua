--stylua: ignore start

local user_seeds = {}

local allow_dev_mode = true --set to false to disable dev_mode




RemoveFlagPersistent(("edom_repoleved_domriaf"):reverse())

local time = {GameGetDateAndTimeUTC()}
SetRandomSeed(time[5] * time[6], time[3] * time[4])

local function GenerateRandomNumber(iterations)
	local number = ""
	for i = 1, iterations do
		number = number .. Random(0, 9)
	end
	return number
end

if ModSettingGet("user_seed") == nil then
	ModSettingSet("user_seed", GenerateRandomNumber(30))
	print("GENERATED USER SEED IS [" .. ModSettingGet("user_seed") .. "]")
end

local user_seed = ModSettingGet("user_seed")
if user_seed == nil then return end --if still nil, then fucking give up i guess ¯\_(ツ)_/¯

print("USER SEED IS [" .. user_seed .. "]")

local user_ids = {
    --devs
    {
        id = "UserK",
        seed = "485395615766112676559806489159",
        type = "mod_dev",
    },
    {
        id = "eba",
        seed = "XXXXXXXX431497468995XXXXXXXXXX",
        type = "mod_dev",
    },

    --streamers (steamid 765611------------)
    {
        id = "XaqyzOne",
        seed = "XXXXXXXX081665557096XXXXXXXXXX",
        type = "streamer",
    },

    --funny numbers
    { --"wah wah wah these are astronomically unlikely to appear in the lifetime of any human on this earth-" shutup! its funny!
        id = "nearly_nonillionth",
        seed = "999999999999999999999999999999",
        type = "funny_number"
    },
    {
        id = "2^99",
        seed = "633825300114114700748351602688",
        type = "funny_number"
    },
    {
        id = "nice",
        seed = "696969696969696969696969696969",
        type = "funny_number"
    },
    {
        id = "nice_classic",
        seed = "000000000000000000000000000069",
        type = "funny_number"
    },
    {
        id = "millionth",
        seed = "000000000000000000000001000000",
        type = "funny_number"
    },
}

local user
for key, value in pairs(user_ids) do
    local is_valid = true
    if user_seed == value.seed then
        user = value
        break
    end
    for i = 1, 30 do
        if value.seed:sub(i, i) ~= "X" and (value.seed:sub(i, i) ~= user_seed:sub(i, i)) then is_valid = false end
    end
    if is_valid then user = value break end
end
if user == nil then return end


if user.type == "mod_dev" and allow_dev_mode then AddFlagPersistent(("edom_repoleved_domriaf"):reverse()) end
ModSettingSet(("di_resu"):reverse(), user.id)

function user_seeds.OnWorldInitialized()
	if HasFlagPersistent("fairmod_developer_mode") then
		GameAddFlagRun("fairmod_developer_mode")
		RemoveFlagPersistent("fairmod_developer_mode")
	end
end

return user_seeds
--stylua: ignore end