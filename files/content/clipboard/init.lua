local clipboard = {}

local messages = {
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
	"I am a professional hacker. If you are reading this, you have been hacked. Send 500 Hamisket to my hamiswallet or I'll send your friends Unfair Noita community collab",
	"Erm... what the scallop!",
	[[Own a musket for home defense, since that's what the founding fathers intended. Four ruffians break into my house. "What the devil?" As I grab my powdered wig and Kentucky rifle. Blow a golf ball sized hole through the first man, he's dead on the spot. Draw my pistol on the second man, miss him entirely because it's smoothbore and nails the neighbors dog. I have to resort to the cannon mounted at the top of the stairs loaded with grape shot, "Tally ho lads" the grape shot shreds two men in the blast, the sound and extra shrapnel set off car alarms. Fix bayonet and charge the last terrified rapscallion. He Bleeds out waiting on the police to arrive since triangular bayonet wounds are impossible to stitch up. Just as the founding fathers intended.]],
	"This clipboard is sponsored by Hämiscaped",
	"sorry dude I forgot what I copied",
	"I forgor",
	"Whuh",
	"Huh??",
	"Also try Noita Community Rebalance!",
	"Copi stinks",
	"Hydrate yourself, NOW",
}

function clipboard.OnPlayerSpawned()
	if imgui then
		SetRandomSeed(123, 456)
		imgui.SetClipboardText(messages[Random(1, #messages)])
	end
end

return clipboard
