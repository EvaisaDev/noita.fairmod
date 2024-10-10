local clipboard = {}

local messages = {
	"'Unfair Noita community collab™' is my favourite mod!",
	"Hämis",
	"Uhh umm aahh",
	"WUOTEWUOTEWUOTEWUOTEWUOTEWUOTEWUOTE",
	"Beep boop",
	"Noita is just a Terraria clone imo",
	"Password123!",
}

function clipboard.OnPlayerSpawned()
	if imgui then
		SetRandomSeed(123, 456)
		imgui.SetClipboardText(messages[Random(1, #messages)])
	end
end

return clipboard
