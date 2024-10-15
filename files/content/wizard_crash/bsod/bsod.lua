dofile("data/scripts/lib/coroutines.lua")

local entity_id = GetUpdatedEntityID()
local children = EntityGetAllChildren(entity_id)
local static = children[2]
local completed = children[3]
local qr_code = children[4]
local stop_code = children[5]

local static_sprite = EntityGetFirstComponentIncludingDisabled(
        static, 'SpriteComponent')

local completed_sprite = EntityGetFirstComponentIncludingDisabled(
        completed, 'SpriteComponent')

local qr_code_sprite = EntityGetFirstComponentIncludingDisabled(
        qr_code, 'SpriteComponent')

local stop_code_sprite = EntityGetFirstComponentIncludingDisabled(
        stop_code, 'SpriteComponent')

function animate_completed()
    local wait_times = {20, 14, 17, 60, 50, 30, 22, 15, 33, 60, 20, 70, 130}
    for index, wait_time in ipairs(wait_times) do
        local animation_name = tostring(index - 1)
        ComponentSetValue2(completed_sprite, 'rect_animation', animation_name)
        wait(wait_time)
    end
end

function random_animation(sprite_component, max_anim_number)
    ComponentSetValue2(
        sprite_component,
        'rect_animation',
        tostring(Random(0, max_anim_number - 1))
    )
end

function set_visible(sprite_component, visible)
    if visible == nil then
        visible = true
    end

    ComponentSetValue2(sprite_component, 'visible', visible)
end

random_animation(stop_code_sprite, 9)
random_animation(qr_code_sprite, 25)

async(function()
    wait(5)
    set_visible(qr_code_sprite)

    wait(10)
    set_visible(static_sprite)

    wait(15)
    set_visible(stop_code_sprite)

    wait(40)
    set_visible(completed_sprite)

    animate_completed()
end)
