local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
dialog = dialog or nil
dialog_system = dialog_system or dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local function get_mail()
	local mail_str = ModSettingGet("noita.fairmod.mail") or ""


	-- split mail by comma
	local mail = {}
	for str in string.gmatch(mail_str, "([^,]+)") do
		table.insert(mail, str)
	end

	return mail
end

local function get_sudo_mail()
	local mail_str = GlobalsGetValue("noita.fairmod.sudo_mail", "") or ""

	-- split mail by \n
	local mail = {}
	for str in string.gmatch(mail_str, "([^\n]+)") do
		table.insert(mail, str)
	end
	return mail
end


-- helper function to split the message
local function split_message(msg)
	local words = {}
	for word in string.gmatch(msg, "%S+") do
		table.insert(words, word)
	end

	local lines = {}
	local line = ""
	local space_count = 0

	for i, word in ipairs(words) do
		if #line > 0 then
			line = line .. " "
		end
		line = line .. word
		space_count = space_count + 1

		local ends_with_punct = string.match(word, "[%.!?]$")

		if space_count >= 14 or ends_with_punct then
			table.insert(lines, line)
			line = ""
			space_count = 0
		end
	end

	if #line > 0 then
		table.insert(lines, line)
	end

	return table.concat(lines, "\n")
end


local has_mail = #get_mail() + (#get_sudo_mail() / 2) > 0
EntitySetComponentsWithTagEnabled(entity_id, "has_mail", has_mail)
EntitySetComponentsWithTagEnabled(entity_id, "no_mail", not has_mail)


function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local mail_list = dofile("mods/noita.fairmod/files/content/mailbox/mail_list.lua")
	local mail = get_mail()
	local sudo_mail = get_sudo_mail()

	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") or GameHasFlagRun("holding_interactible") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")

	GamePlaySound("mods/noita.fairmod/fairmod.bank", "mailbox/open", x, y)

	if #mail == 0 and #sudo_mail == 0 then
		dialog = dialog_system.open_dialog({
			name = "Mailbox",
			portrait = "mods/noita.fairmod/files/content/mailbox/portrait.png",
			typing_sound = "default",
			text = "The mailbox is empty.",
			options = {
				{
					text = "Close the mailbox.",
					func = function(dialog)
						dialog.close()
					end,
				},
			},
			on_closed = function()
				dialog = nil
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "mailbox/open", x, y)
			end,
		})
	else
		local to_call = {}
		dialog = dialog_system.open_dialog({
			name = "Mailbox",
			portrait = "mods/noita.fairmod/files/content/mailbox/portrait.png",
			typing_sound = "default",
			text = string.format("There %s %d piece%s of mail.", (#mail + (#sudo_mail / 2)) == 1 and "is" or "are", (#mail + (#sudo_mail / 2)), (#mail + (#sudo_mail / 2)) == 1 and "" or "s"),
			options = {
				{
					text = "Empty the mailbox.",
					func = function(dialog)

						

						-- loop through mail and call the function
						for i, mail_id in ipairs(mail) do
							local delay = math.max(20 - i, 1)

							local mail_data = mail_list[mail_id]
							if(mail_data)then
								if(mail_data.create_letter)then
									local letter_entity = EntityLoad("mods/noita.fairmod/files/content/mailbox/letter.xml", x, y - 17)
									local ui_info_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "UIInfoComponent")
									if(ui_info_component)then
										ComponentSetValue2(ui_info_component, "name", mail_data.letter_title or "Letter")
									end

									local ability_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "AbilityComponent")
									if(ability_component)then
										ComponentSetValue2(ability_component, "ui_name", mail_data.letter_title or "Letter")
									end
									
									local velocity_comp = EntityGetFirstComponentIncludingDisabled(letter_entity, "VelocityComponent")
									if(velocity_comp)then
										local vel_x = math.random(-100, 100)
										local vel_y = -100
										ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
									end

									local item_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "ItemComponent")
									if(item_component)then
										ComponentSetValue2(item_component, "item_name", mail_data.letter_title or "Letter")

										if(mail_data.letter_content and not mail_data.trimmed)then
											local lines = {}
											for str in string.gmatch(mail_data.letter_content, "([^\n]+)") do
												table.insert(lines, str)
											end

											-- trim empty space around lines
											for i, line in ipairs(lines) do
												lines[i] = string.gsub(line, "^%s*(.-)%s*$", "%1")
											end	

											-- set letter content
											mail_data.letter_content = table.concat(lines, "\n")
											mail_data.trimmed = true
										end
										ComponentSetValue2(item_component, "ui_description", mail_data.letter_content or "Letter")
										if(mail_data.letter_sprite)then
											ComponentSetValue2(item_component, "ui_sprite", mail_data.letter_sprite)
											local sprite_components = EntityGetComponentIncludingDisabled(letter_entity, "SpriteComponent")
											if(sprite_components)then
												for i, sprite_component in ipairs(sprite_components) do
													ComponentSetValue2(sprite_component, "image_file", mail_data.letter_sprite)
												end
											end
										end

										if(mail_data.letter_func)then
											mail_data.letter_func(letter_entity)
										end
									end
				
								end

								if mail_data.func ~= nil then
									wait(delay)
									mail_data.func(x, y - 17, i)
								end

								if(mail_data.post_func)then
									table.insert(to_call, function() 
										mail_data.post_func(x, y - 17, i)
									end)
								end
							end

							wait(delay)
						end


						-- loop through sudo_mail
						for i = 1, #sudo_mail, 2 do
							local delay = math.max(20 - i, 1)
							local sender = sudo_mail[i]
							local message = sudo_mail[i + 1]

							-- split message
							message = split_message(message)

							local letter_entity = EntityLoad("mods/noita.fairmod/files/content/mailbox/letter.xml", x, y - 17)
							local ui_info_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "UIInfoComponent")
							if(ui_info_component)then
								ComponentSetValue2(ui_info_component, "name", sender and "From "..sender or "Letter")
							end

							local ability_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "AbilityComponent")
							if(ability_component)then
								ComponentSetValue2(ability_component, "ui_name", sender and "From "..sender or "Letter")
							end

							local item_component = EntityGetFirstComponentIncludingDisabled(letter_entity, "ItemComponent")
							if(item_component)then
								ComponentSetValue2(item_component, "ui_description", message or "???")
								ComponentSetValue2(item_component, "item_name", sender and "From "..sender or "Letter")
							end

							local velocity_comp = EntityGetFirstComponentIncludingDisabled(letter_entity, "VelocityComponent")
							if(velocity_comp)then
								local vel_x = math.random(-100, 100)
								local vel_y = -100
								ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
							end

							wait(delay)

						end

						ModSettingSet("noita.fairmod.mail", "")
						GlobalsSetValue("noita.fairmod.sudo_mail", "")

						GameRemoveFlagRun("fairmod_interacted_with_anything_this_frame")
						GameRemoveFlagRun("fairmod_dialog_interacting")
					
						dialog.close()
					end,
				},
				{
					text = "Close the mailbox.",
					func = function(dialog)
						GameRemoveFlagRun("fairmod_interacted_with_anything_this_frame")
						GameRemoveFlagRun("fairmod_dialog_interacting")
						dialog.close()
					end,
				},
			},
			on_closed = function()
				dialog = nil
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "mailbox/open", x, y)

				GameRemoveFlagRun("fairmod_dialog_interacting")
				GameRemoveFlagRun("fairmod_interacted_with_anything_this_frame")

				-- run post_funcs 
				for i, func in ipairs(to_call) do
					func()
				end
			end,
		})
	end


end
