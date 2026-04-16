local clipboard = {}

function clipboard.OnPlayerSpawned()
	local messages = { --sorry, need access to TL and that isn't available during normal init, and adding in stuff separately would be weird
		"'Unfair Noita community collab™' is my favourite mod!",
		"Hämis",
		"Uhh umm aahh",
		"WUOTEWUOTEWUOTEWUOTEWUOTEWUOTEWUOTE",
		"Beep boop",
		"Noita is just a Terraria clone imo",
		"Password123!",
		"Eba is the best!!",
		"https://github.com/Copious-Modding-Industries/copis_things",
		"I'm using tilt controls!",
		":3",
		"I am a professional hacker. If you are reading this, you have been hacked. Send 500 Hämisket to my hamiswallet or I'll send your friends Unfair Noita community collab",
		"Erm... what the scallop!",
		[[Own a musket for home defense, since that's what the founding fathers intended. Four ruffians break into my house. "What the devil?" As I grab my powdered wig and Kentucky rifle. Blow a golf ball sized hole through the first man, he's dead on the spot. Draw my pistol on the second man, miss him entirely because it's smoothbore and nails the neighbors dog. I have to resort to the cannon mounted at the top of the stairs loaded with grape shot, "Tally ho lads" the grape shot shreds two men in the blast, the sound and extra shrapnel set off car alarms. Fix bayonet and charge the last terrified rapscallion. He Bleeds out waiting on the police to arrive since triangular bayonet wounds are impossible to stitch up. Just as the founding fathers intended.]],
		"This clipboard is sponsored by Hämiscaped",
		"sorry dude I forgot what I copied",
		"I forgor",
		"Whuh",
		"Huh??",
		"Also try Noita Community Rebalance!",
		"Copi stinks", -- D:
		"Copi smells really nice, actually :(",
		"Hydrate yourself, NOW",
		"I love arson!",
		"This person stinks!",
		"It's all a conspiracy! They called me crazy! They called me crazy! I told you all! They put clams in the fucking water supply! The clams control the water supply! I'm not crazy!",
		"To be fair, you have to have a VERY high IQ to understand Boomerang Spells. The mechanics are EXTREMELY complicated, and without a solid grasp of Noita physics, most of the spells will go over a typical user's head. There's also Boomerang Spells damage boost, which is deftly woven into its use, its sheer power draws HEAVILY from Multicast spells, for instance. The boomerang users UNDERSTAND this stuff; they have the intellectual capacity to truly APPRECIATE the perk, to realize that it's not just POWER- It says something deep about TRIGGERS. As a consequence people who dislike Boomerang Spells truly ARE clueless- of COURSE they wouldn't appreciate them, for instance, the humor in Boomerang Spells' iconic interaction with Circle of Vigor which ITSELF is a cryptic reference to old-school Wisp. I'm SMIRKING right now just IMAGINING one of those simpletons are scratching their heads in confusion as a boomerang bomb nuke unfolds itself glory on their screen. What FOOLS... how I pity them.",
		"KILL!! KILL KILL KILL!!!",
		"Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy. Crazy? I was crazy once. They locked me in a room- a rubber room. A rubber room with rats. I hate rats. Rats make me crazy.",
		"Crazy? Me too, buddy, me too.",
		"Chemical Curiosites is good, I swear!",
		"image.png",
		"message.txt",
		'"Why so Jonkler"\n-Sirius Black, from hit-game; LEGO Harry Potter 7',
		"https://discord.gg/noita",
		"https://discord.gg/erHfpxGDq6", --this is another noitacord link, but without "/noita"
		"https://noita.wiki.gg/",
		"Terraria is just a Minecraft clone imo",
		"Minecraft is just a Noita clone imo",
		GameTextGet("$bee_movie_script"), --lmao
		'"Wait a minute, I didn\'t copy this!"\n-You, right now',
		"I wonder what the blacklights are for...",
		"unknown.png",
		"hehe im in your 'puter",
		"This mod is so fair!",
		"",
	}

	if imgui and not GameHasFlagRun("fairmod_developer_mode") then
		SetRandomSeed(123, 456)
		imgui.SetClipboardText(messages[Random(1, #messages)])
	end
end

return clipboard
