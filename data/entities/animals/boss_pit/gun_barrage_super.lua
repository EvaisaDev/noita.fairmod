-- CONFIGURE VALUES:
local offset_y   = 0   -- y offset from enemy pos
local offset_x   = 0   -- x offset from enemy pos
local fire_rate  = 15  -- frames between each shot
local wavelength = 30/2   -- how long it takes to do one full "sweep"
local amplitude  = 180   -- how many degrees to go left or right
local offset_angle  = -90   -- how offset is this angle
local shot_vel   = math.random(200, 600) -- speed to shoot out at
local file_path  = "data/entities/animals/boss_pit/wand_glock_long.xml"

local entity_id = GetUpdatedEntityID()
local shooter = EntityGetParent( entity_id )
local pos_x, pos_y = EntityGetTransform(shooter)
local now = GameGetFrameNum()
if now%fire_rate == 0 then
    local angle_offset = math.rad(offset_angle+math.sin(now/wavelength)*amplitude)
    local vel_x = math.cos(angle_offset) * shot_vel
    local vel_y = math.sin(angle_offset) * shot_vel

    local created_entity_id = EntityLoad(file_path, pos_x, pos_y)
    local created_projcomp = EntityGetFirstComponent(created_entity_id, "ProjectileComponent") --[[@cast created_projcomp number]]
    local created_velcomp = EntityGetFirstComponent(created_entity_id, "VelocityComponent") --[[@cast created_velcomp number]]

    local genome = EntityGetFirstComponent(shooter, "GenomeDataComponent")
    local herd_id = genome and ComponentGetValue2(genome, "herd_id") or -1
    GameShootProjectile(shooter, pos_x, pos_y, pos_x + vel_x, pos_y + vel_y, created_entity_id, true)
    ComponentSetValue2(created_projcomp, "mWhoShot", shooter)
    ComponentSetValue2(created_projcomp, "mShooterHerdId", herd_id)
    ComponentSetValue2(created_velcomp, "mVelocity", vel_x, vel_y)
end