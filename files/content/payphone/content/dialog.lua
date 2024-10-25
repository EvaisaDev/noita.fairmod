return {
    {
        name = "Unknown Caller",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "default",
        text = [[Hello!! Is your refrigerator running?]],
        options = {
            {
                text = "I.. Think so?",
                func = function(dialog)
                    dialog.show({
                        text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
                        options = {
                            {
                                text = "...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Who is this?",
                func = function(dialog)
                    dialog.show({
                        text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
                        options = {
                            {
                                text = "...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "I'm calling the police.",
                func = function(dialog)
                    dialog.show({
                        text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
                        options = {
                            {
                                text = "...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Goodbye",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Unknown Caller",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound_interval = 5,
        typing_sound = "pop",
        text = [[Hello.. Is this that, witch..? \\*blub\\*]],
        can_call = function() -- optional
            return tonumber(GlobalsGetValue("loan_shark_debt", "0")) >= 50
        end,
        options = {
            {
                text = "Uhh, yes..? Who is this?",
                func = function(dialog)
                    dialog.show({
                        text = [[\\*blub\\* Just reminding you, you should pay off your debts,
or {@color b82318}#you will regret it.#{@func disconnected}]],
                        options = {
                            {
                                text = "...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "You got the wrong number.",
                func = function(dialog)
                    dialog.show({
                        text = [[Oh.. I'm sorry. \\*blub\\* {@func disconnected}]],
                        options = {
                            {
                                text = "...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Goodbye",
                func = function(dialog)
                    hangup()
                end,
            },
        }
    },
    {
        name = "Telemarketer",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "two",
        text = [[
		Hello! I'm calling from Wand Insurance Co. 
		Do you have a moment to talk about your wand's extended 
		warranty?
		]],
        options = {
            {
                text = "I'm not interested.",
                func = function(dialog)
                    dialog.show({
                        text = [[Oh, but this is a limited time offer! 
						You don't want to miss out right?]],
                        options = {
                            {
                                text = "No, thanks.",
                                func = function(dialog)
                                    dialog.show({
                                        text = [[Alright, have a magical day! {@func disconnected}]],
                                        options = {
                                            {
                                                text = "...",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })
                                end,
                            },
                            {
                                text = "Goodbye.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Tell me more.",
                func = function(dialog)
                    dialog.show({
                        text = [[Wonderful! 
						For just 600 gold, you can extend your wand's
						warranty for another year.]],
                        options = {
                            {
                                text = "Sign me up! (600 gold)",
                                enabled = function(stats)
                                    return stats.gold >= 600
                                end,
                                func = function(dialog)
                                    dialog.show({
                                        text = [[Great! Your wand is now covered. 
										Thank you for your business! {@func disconnected}]],
                                        options = {
                                            {
                                                text = "...",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })

                                    -- remove gold
                                    local players = EntityGetWithTag("player_unit") or {}

                                    if(players == nil or #players == 0) then
                                        return
                                    end

                                    local player = players[1]

                                    local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
                                    local gold = ComponentGetValue2(wallet_component, "money")

                                    ComponentSetValue2(wallet_component, "money", gold - 600)
                                end,
                            },
                            {
                                text = "On second thought, nevermind.",
                                func = function(dialog)
                                    dialog.show({
                                        text = [[No problem! Have a magical day! {@func disconnected}]],
                                        options = {
                                            {
                                                text = "...",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Suspicious Caller",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "three",
        text = [[We have detected unusual activity on your bank account.
Please provide your account number to verify your
identity.]],
		func = function(dialog)
			dialog_system.dialog_box_height = 100
		end,
        options = {
            {
                text = "Sure, it's "..Random(100000, 999999)..".",
                func = function(dialog)
                    dialog.show({
                        text = [[Thank you. Your account has been secured. {@func disconnected}]],
                        options = {
                            {
                                text = "Wait...",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })

                    -- remove all gold
                    local players = EntityGetWithTag("player_unit") or {}

                    if(players == nil or #players == 0) then
                        return
                    end

                    local player = players[1]

                    local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")

                    ComponentSetValue2(wallet_component, "money", 0)
                end,
            },
            {
                text = "I don't have a bank account.",
                func = function(dialog)
                    dialog.show({
                        text = [[Oh, my mistake. Have a good day. {@func disconnected}]],
                        options = {
                            {
                                text = "Hmm.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Nice try, scammer.",
                func = function(dialog)
                    dialog.show({
                        text = [[You can't blame me for trying!! {@func disconnected}]],
                        options = {
                            {
                                text = "Unbelievable.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Heavy Breather",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "breathing",
        typing_sound_interval = 5,
        text = [[...]],
        options = {
            {
                text = "Hello?",
                func = function(dialog)
                    dialog.show({
                        text = [[\\*heavy breathing\\*]],
                        options = {
                            {
                                text = "Who is this?",
                                func = function(dialog)
                                    dialog.show({
                                        text = [[...{@func disconnected}]],
                                        options = {
                                            {
                                                text = "Creepy.",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })
                                end,
                            },
                            {
                                text = "I'm calling the authorities.",
                                func = function(dialog)
                                    dialog.show({
                                        text = [[\\*gasp\\* {@func disconnected}]],
                                        options = {
                                            {
                                                text = "Good riddance.",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Wrong Number",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "default",
        text = [[Hey, is this Bob?]],
        options = {
            {
                text = "No, you have the wrong number.",
                func = function(dialog)
                    dialog.show({
                        text = [[Oh, sorry about that! Have a good day! {@func disconnected}]],
                        options = {
                            {
                                text = "You too.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Yes, this is Bob.",
                func = function(dialog)
                    dialog.show({
                        text = [[Great! About that gold you owe me...]],
                        options = {
                            {
                                text = "Uh, gotta go!",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                            {
                                text = "Sorry, wrong Bob.",
                                func = function(dialog)
                                    dialog.show({
                                        text = [[Dang.. {@func disconnected}]],
                                        options = {
                                            {
                                                text = "Phew.",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Survey Taker",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "gibberish",
        text = [[Hello! Would you like to participate in a short survey about
your recent cave-dwelling experiences?]],
		func = function(dialog)
			dialog_system.dialog_box_height = 100
		end,
        options = {
            {
                text = "Sure, why not.",
                func = function(dialog)

                    -- Define survey functions
                    local function survey_end(dialog, reward_final)
                        local players = EntityGetWithTag("player_unit") or {}
                        if players == nil or #players == 0 then
                            return
                        end
                        local player = players[1]
                        local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
                        local gold = ComponentGetValue2(wallet_component, "money")
                        ComponentSetValue2(wallet_component, "money", gold + 500)
                        local x, y = EntityGetTransform(player)


                        dialog.show({
                            text = [[Thank you for participating in our survey! As a token of our
appreciation, please accept 500 gold! {@func disconnected}]],
                            options = {
                                {
                                    text = "Thank you!",
                                    func = function(dialog)
                                        if(reward_final == "nuke")then
                                            local x, y = EntityGetTransform(player)
                                            EntityLoad("data/entities/projectiles/deck/nuke.xml", x, y)
                                        elseif(reward_final == "snails")then
                                            for i = 1, 100 do
                                                -- get a random angle radian
                                                local angle = math.rad(Random(0, 360))
                                                -- get a random direction vector
                                                local dx = math.cos(angle)
                                                local dy = math.sin(angle)

                                                local distance = Random(100, 250)

                                                local target_x = x + (dx * distance)
                                                local target_y = y + (dy * distance)

                                                local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

                                                if(not hit)then
                                                    EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
                                                end
                                            end
                                        elseif(reward_final == "liminal")then
                                            EntityApplyTransform(player, 1547, 14900)
                                        end
                                        hangup()
                                    end,
                                },
                            },
                        })

                    end

                    -- Add 500 gold
                    local function survey_question4(dialog)
                        dialog.show({
                            text = [[Any suggestions for improving the experience?]],
                            options = {
                                {
                                    text = "Nope, it is perfect!",
                                    func = function(dialog)
                                        survey_end(dialog)
                                    end,
                                },
                                {
                                    text = "More explosions!!",
                                    func = function(dialog)
                                        survey_end(dialog, "nuke")
                                    end,
                                },
                                {
                                    text = "Additional snails.",
                                    func = function(dialog)
                                        survey_end(dialog, "snails")
                                    end,
                                },
                                {
                                    text = "Make it liminal.",
                                    func = function(dialog)
                                        survey_end(dialog, "liminal")
                                    end,
                                },
                            },
                        })
                    end

                    local function survey_question3(dialog)
                        dialog.show({
                            text = [[Interesting.. Have you experienced any glitches, strange
							spells, or other anomalies?]],
                            options = {
                                {
                                    text = "A lot of them.",
                                    func = survey_question4,
                                },
                                {
                                    text = "Can.. You be more specific?",
                                    func = survey_question4,
                                },
                                {
                                    text = "Rarely",
                                    func = survey_question4,
                                },
                                {
                                    text = "Never",
                                    func = survey_question4,
                                },
                            },
                        })
                    end

                    local function survey_question2(dialog)
                        dialog.show({
                            text = [[Have you seen a snail?]],
                            options = {
                                {
                                    text = "A.. A snail?",
                                    func = survey_question3,
                                },
                                {
                                    text = "N.. No?",
                                    func = survey_question3,
                                },
                                {
                                    text = "Oh yes, that fucker has been chasing me.",
                                    func = survey_question3,
                                }
                            },
                        })
                    end

                    local function survey_question1(dialog)
                        dialog.show({
                            text = [[Great! On a scale of 1 to 5, how would you rate your recent
							exploration experience?]],
                            options = {
                                {
                                    text = "1",
                                    func = survey_question2,
                                },
                                {
                                    text = "2",
                                    func = survey_question2,
                                },
                                {
                                    text = "3",
                                    func = survey_question2,
                                },
                                {
                                    text = "4",
                                    func = survey_question2,
                                },
                                {
                                    text = "5",
                                    func = survey_question2,
                                },
                            },
                        })
                    end

                    -- Start the survey
                    survey_question1(dialog)
                end,
            },
            {
                text = "No, thanks.",
                func = function(dialog)
                    dialog.show({
                        text = [[No problem! Have a great day! {@func disconnected}]],
                        options = {
                            {
                                text = "You too.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
    {
        name = "Game Show Host",
        portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
        typing_sound = "four",
        text = [[Congratulations! You've been selected to answer a question
			for a chance to win 1000 gold coins! 
			Are you ready to play?]],
        options = {
            {
                text = "Yes!",
                func = function(dialog)
                    dialog.show({
                        text = [[Fantastic! Here is your question:
								What are the 3 numbers on the back of your credit card?]],
                        options = {
                            {
                                text = tostring(Random(100, 999)),
                                func = function(dialog)
                                    dialog.show({
                                        text = [[Correct! You've won 1000 gold! {@func disconnected}]],
                                        options = {
                                            {
                                                text = "Wait, what?",
                                                func = function(dialog)
                                                    hangup()
                                                end,
                                            },
                                        },
                                    })

                                    -- add gold
                                    local players = EntityGetWithTag("player_unit") or {}

                                    if(players == nil or #players == 0) then
                                        return
                                    end

                                    local player = players[1]

                                    local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
                                    local gold = ComponentGetValue2(wallet_component, "money")

                                    ComponentSetValue2(wallet_component, "money", gold + 1000)
                                end,
                            },
                            {
                                text = "I don't think so.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "No, thanks.",
                func = function(dialog)
                    dialog.show({
                        text = [[Alright, maybe next time! {@func disconnected}]],
                        options = {
                            {
                                text = "Goodbye.",
                                func = function(dialog)
                                    hangup()
                                end,
                            },
                        },
                    })
                end,
            },
            {
                text = "Hang up.",
                func = function(dialog)
                    hangup()
                end,
            },
        },
    },
}
