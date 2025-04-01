local init_old = init

function init(x, y, ...)
	local ray_hit, ray_x, ray_y = RaytracePlatforms(x + 128, y + 256, x, y + 1024)

	if ray_hit then EntityLoadCameraBound("mods/noita.fairmod/files/content/pixelscenes/zote/entity.xml", ray_x, ray_y - 10) end
	init_old(x, y, ...)
end
