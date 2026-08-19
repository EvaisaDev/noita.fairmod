local multiplier = tonumber( GlobalsGetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" ) )
if multiplier <= 1 then return end


local entity = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(entity, "SpriteComponent")

if comp ~= nil then
	ComponentSetValue2(comp, "image_file", "mods/noita.fairmod/files/content/better_perks/stronger_hearts/buff_heart_extrahp.xml")
end
