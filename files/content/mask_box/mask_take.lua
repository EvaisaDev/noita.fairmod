dofile_once("mods/noita.fairmod/files/content/mask_box/mask_list.lua")

function interacting( player_id, shrine_id, interactable_name )
    local x,y = EntityGetTransform(shrine_id)
    local mask_option = ChooseRandomMask()

    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/pick_item_generic/create", x, y )

    local comp = EntityGetFirstComponentIncludingDisabled(player_id,"SpriteComponent","i_am_mask")
    ComponentSetValue2(comp,"image_file",mask_option)
    EntitySetComponentIsEnabled( player_id, comp, true )
    EntityRefreshSprite( player_id, comp )
    --ComponentSetValue2(comp,"rect_animation","stand")
end