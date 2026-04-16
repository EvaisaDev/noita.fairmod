local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.dialog_box_width = 400

local reward_to_load = "data/entities/items/wand_level_10.xml" -- TODO maybe add something custom

local bad_choice
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local hamis_killed = GlobalsGetValue("FAIRMOD_HAMIS_KILLED", "0") ~= "0"

local function shuffle(text)
	if not hamis_killed then return text end
	SetRandomSeed(x + GameGetFrameNum(), y)
	local length = #text
	local letters = {}
	for i = 1, length do
		letters[i] = text:sub(i, i)
	end

	for i = 1, length do
		local rand = Random(1, length)
		letters[i], letters[rand] = letters[rand], letters[i]
	end
	return table.concat(letters)
end

local function its_mad()
	GameAddFlagRun("fairmod_longest_disappointed")
	EntityAddComponent2(entity_id, "LifetimeComponent", { lifetime = 60, fade_sprites = true })
	GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/orb_distant_monster/create", x, y)
	GamePrintImportant(
		"I    D  I  D    N  O  T    F  I  N  I  S  H",
		"..whoops",
		"mods/noita.fairmod/files/content/pixelscenes/longest_leg/3piece_important_msg.png"
	)
	EntityLoad("mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_angry_entity.xml", x, y - 20)
end

local dialogue_did_i_stutter = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		portrait = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_portrait_angry.xml",
		text = "#D  I  D      I      S  T  U  T  T  E  R    ?#",
	})
end

local dialogue_read_the_words_8 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("And so, from the fires of the Hämis Lord")
			.. "\n"
			.. shuffle("the world was made whole and its purpose set aflame.")
			.. "\n"
			.. shuffle("Hope you learned something from this story."),
		options = {
			{
				text = "I believe in Hämis now",
				func = function(dialogue_finish)
					bad_choice = false
					GameAddFlagRun("fairmod_longest_content")
					local interactable_component = EntityGetFirstComponent(entity_id, "InteractableComponent")
					if interactable_component then EntityRemoveComponent(entity_id, interactable_component) end
					EntityLoad(reward_to_load, x, y)
					dialogue_finish.close()
				end,
			},
			{
				text = "What a bullshit",
				func = function(dialogue_finish)
					dialogue_finish.show({
						name = shuffle("Longest Hämis"),
						text = shuffle("#   .   .   .   .   .   .   .   .   .#"),
						options = {
							{
								text = "?",
							},
						},
					})
				end,
			},
		},
	})
end

local dialogue_read_the_words_7 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Seventh Day, the Hämis Lord looked upon the world it had made,") .. "\n" .. shuffle(
			"saw the fires leaping in each heart, and was pleased."
		) .. "\n" .. shuffle("It withdrew to the depths, hidden but ever watching.") .. "\n" .. shuffle(
			"And so the world was set ablaze, forever marked by its creator's hand."
		),
		options = {
			{
				text = "Beautiful!",
				func = dialogue_read_the_words_8,
			},
		},
	})
end

local dialogue_read_the_words_6 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Sixth Day, the Hämis Lord reached out to its kin,") .. "\n" .. shuffle(
			"bestowing upon them the gifts of cunning and wrath."
		) .. "\n" .. shuffle('"Take the flames within you," it spoke, "and let them burn in every breath."') .. "\n" .. shuffle(
			"Thus, the Hämis learned to guard the fires as their lord commanded."
		),
		options = {
			{
				text = "Listen",
				func = dialogue_read_the_words_7,
			},
		},
	})
end

local dialogue_read_the_words_5 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Fifth Day, the Hämis Lord forged the deep tunnels") .. "\n" .. shuffle(
			"and winding veins that lie hidden beneath stone."
		) .. "\n" .. shuffle("There, it whispered secrets into the rock, ancient words of power and flame.") .. "\n" .. shuffle(
			"The earth pulsed with these sacred fires, unseen but always felt."
		),
		options = {
			{
				text = "How?",
				func = dialogue_did_i_stutter,
			},
			{
				text = "...",
				func = dialogue_read_the_words_6,
			},
		},
	})
end

local dialogue_read_the_words_4 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Fourth Day, the Hämis Lord raised a mighty claw,") .. "\n" .. shuffle(
			"and the skies were kindled with storm and fury. Smoke gathered,"
		) .. "\n" .. shuffle("thick and unyielding, cloaking the heavens in darkness.") .. "\n" .. shuffle(
			"Sparks fell as stars, guiding the faithful in the shadows."
		),
		options = {
			{
				text = "Wow.",
				func = dialogue_read_the_words_5,
			},
		},
	})
end

local dialogue_read_the_words_3 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Third Day, with a voice like crackling coals,") .. "\n" .. shuffle(
			"the Hämis Lord called forth the lava spirits and creatures of flame."
		) .. "\n" .. shuffle("From its own burning essence, it shaped the Hämiskin, the first of its kindred.") .. "\n" .. shuffle(
			"In their glowing eyes was a reflection of the Lord’s eternal blaze."
		),
		options = {
			{
				text = "And?",
				func = dialogue_read_the_words_4,
			},
			{
				text = "Sorry, can you repeat?",
				func = dialogue_did_i_stutter,
			},
		},
	})
end

local dialogue_read_the_words_2 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the Second Day, the Hämis Lord commanded magma to rise from the depths,")
			.. "\n"
			.. shuffle("rivers of molten stone spilling forth.")
			.. "\n"
			.. shuffle("These rivers carved the bones of mountains")
			.. "\n"
			.. shuffle("and filled the earth with the scent of brimstone.")
			.. "\n"
			.. shuffle("Thus, the land was seared with the mark of its fiery birth."),
		options = {
			{
				text = "Okay.",
				func = dialogue_read_the_words_3,
			},
		},
	})
end

local dialogue_read_the_words_1 = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("On the First Day, the Hämis Lord raised its many-fingered hand,") .. "\n" .. shuffle(
			"and from its breath of fire, the first sparks of flame were cast across the void."
		) .. "\n" .. shuffle("The world took its shape in the light of embers and ash.") .. "\n" .. shuffle(
			"Heat and shadow mingled, forming the realm that would be."
		),
		options = {
			{
				text = "Okay",
				func = dialogue_read_the_words_2,
			},
		},
	})
end

local dialogue_hear_the_words = function(dialogue)
	dialogue.show({
		name = shuffle("Longest Hämis"),
		text = shuffle("Was your journey hard so far?") .. "\n" .. shuffle("I may propose you to hear the words of our Savior."),
		options = {
			{
				text = "Okay?",
				func = dialogue_read_the_words_1,
			},
			{
				text = "What do you mean?",
				func = dialogue_did_i_stutter,
			},
		},
	})
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")
	GameAddFlagRun("fairmod_longest_hamis_interacted")
	bad_choice = true
	dialog_system.open_dialog({
		name = shuffle("Longest Hämis"),
		portrait = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_portrait.xml",
		animation = "stand",
		text = shuffle("Good evening, Mina.") .. "\n" .. shuffle("Do you have a time to speak about our Lord and Savior - Lord Hämis?"),
		options = {
			{
				text = "Uh, sure?",
				func = dialogue_hear_the_words,
			},
			{
				text = "Huh?",
				func = dialogue_did_i_stutter,
			},
		},
		on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
			if bad_choice then its_mad() end
		end,
	})
end
