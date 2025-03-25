local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
dialog = dialog or nil
dialog_system = dialog_system or dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35


local function get_mail()
	local mail_str = ModSettingGet("noita.fairmod.mail") or ""

	print(mail_str)

	-- split mail by comma
	local mail = {}
	for str in string.gmatch(mail_str, "([^,]+)") do
		table.insert(mail, str)
	end
	return mail
end

local has_mail = #get_mail() > 0
EntitySetComponentsWithTagEnabled(entity_id, "has_mail", has_mail)
EntitySetComponentsWithTagEnabled(entity_id, "no_mail", not has_mail)


function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local mail_list = dofile("mods/noita.fairmod/files/content/mailbox/mail_list.lua")
	local mail = get_mail()

	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") or GameHasFlagRun("holding_interactible") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")

	GamePlaySound("mods/noita.fairmod/fairmod.bank", "mailbox/open", x, y)

	if #mail == 0 then
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
		dialog = dialog_system.open_dialog({
			name = "Mailbox",
			portrait = "mods/noita.fairmod/files/content/mailbox/portrait.png",
			typing_sound = "default",
			text = string.format("There %s %d piece%s of mail.", #mail == 1 and "is" or "are", #mail, #mail == 1 and "" or "s"),
			options = {
				{
					text = "Empty the mailbox.",
					func = function(dialog)

						-- loop through mail and call the function
						for i, mail_id in ipairs(mail) do
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
									wait(30)
									mail_data.func(x, y - 17)
								end
							end

							wait(30)
						end


						ModSettingSet("noita.fairmod.mail", "")
						dialog.close()
					end,
				},
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

				GameRemoveFlagRun("fairmod_dialog_interacting")
			end,
		})
	end


end
