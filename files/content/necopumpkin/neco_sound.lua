local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
if (Random(1,3)==3) then
    GamePlaySound( "mods/noita.fairmod/fairmod.bank", "necoarc/noises", pos_x, pos_y );
end