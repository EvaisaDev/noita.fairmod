--- Hardcoded world width for scripts that don't have access to BiomeMapGetSize.
WORLD_WIDTH_HARDCODED = 70 * 512

---@vararg table
---@return table
function MergeTables(...)
	local tables = { ... }
	local out = {}
	for _, t in ipairs(tables) do
		for k, v in pairs(t) do
			out[k] = v
		end
	end
	return out
end

---@return table
function GetPlayers()
	return MergeTables(EntityGetWithTag("player_unit") or {}, EntityGetWithTag("polymorphed_player") or {}) or {}
end

---@param x number
---@param y number
---@param radius number
---@return entity_id[]
function GetEnemiesInRadius(x, y, radius)
	local entities = MergeTables(EntityGetInRadiusWithTag(x, y, radius, "enemy"), EntityGetInRadiusWithTag(x, y, radius, "boss"))

	return entities
end

local banned_tags = {
	["[box2d]"] = true,
	["[catastrophic]"] = true,
	["[NO_FUNGAL_SHIFT]"] = true,
}

function MaterialsFilter(mats)
	for i = #mats, 1, -1 do
		local mat = mats[i]

		if mat:find("fading") or mat:find("molten") then
			table.remove(mats, i)
			goto continue
		end

		local tags = CellFactory_GetTags(CellFactory_GetType(mat)) or {}
		for _, tag in ipairs(tags) do
			if banned_tags[tag] then
				table.remove(mats, i)
				goto continue
			end
		end
		::continue::
	end

	return mats
end

---@return entity_id[]
function GetInventoryItems()
	local player_entity = GetPlayers()[1]
	if player_entity ~= nil then return GameGetAllInventoryItems(player_entity) or {} end
	return {}
end

---@param tag string
---@return boolean
function HasInventoryItemTag(tag)
	for _, item in ipairs(GetInventoryItems()) do
		if EntityHasTag(item, tag) then return true end
	end
	return false
end

---@param x number
---@param y number
---@return string|nil
function GetBiomeId(x, y)
	local filename = DebugBiomeMapGetFilename(x, y)
	for name in filename:gmatch("/([%w_ ]+).xml") do
		return name
	end
	return nil
end

---@return string|nil
function GetCurrentBiomeId()
	local plyr = GetPlayers()[1]
	if plyr == nil then return nil end

	local x, y = EntityGetTransform(plyr)
	return GetBiomeId(x, y)
end

---@param entity entity_id
---@param item_entity entity_id
function EntityDropItem(entity, item_entity)
	EntityRemoveFromParent(item_entity)
	EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_hand", false)
	EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_world", true)
	EntitySetComponentsWithTagEnabled(item_entity, "item_unidentified", false)



	local inventory_comp = EntityGetFirstComponentIncludingDisabled(entity, "Inventory2Component")
	if inventory_comp ~= nil then
		ComponentSetValue2(inventory_comp, "mActiveItem", 0)
		ComponentSetValue2(inventory_comp, "mActualActiveItem", 0)
		ComponentSetValue2(inventory_comp, "mForceRefresh", true)
	end
end

---Replaces the image at `destination` with `image`
---@param destination string
---@param image string
function ImageReplace(destination, image)
	if not ModDoesFileExist(image) then print("image was not valid for image replacement") return end

	local dest_data = {}
	local img_data = {}
	img_data.id,img_data.w,img_data.h = ModImageMakeEditable(image, 0, 0)
	dest_data.id,dest_data.w,dest_data.h = ModImageMakeEditable(destination, img_data.w, img_data.h)

	local w = math.max(img_data.w, dest_data.w)
	local h = math.max(img_data.h, dest_data.h)

	for y = 0, h - 1 do
		for x = 0, w - 1 do
			ModImageSetPixel(dest_data.id, x, y, ModImageGetPixel(img_data.id, x, y))
		end
	end
end

---Split abgr
---@param abgr_int integer
---@return number red, number green, number blue, number alpha
function abgr_split(abgr_int)
    local r = bit.band(abgr_int, 0xFF)
    local g = bit.band(bit.rshift(abgr_int, 8), 0xFF)
    local b = bit.band(bit.rshift(abgr_int, 16), 0xFF)
    local a = bit.band(bit.rshift(abgr_int, 24), 0xFF)

    return r, g, b, a
end

---Merge rgb
---@param r number
---@param g number
---@param b number
---@param a number
---@return integer color
function abgr_merge(r, g, b, a)
    return bit.bor(bit.band(r, 0xFF), bit.lshift(bit.band(g, 0xFF), 8), bit.lshift(bit.band(b, 0xFF), 16), bit.lshift(bit.band(a, 0xFF), 24))
end

math.clamp = function(val, lower, upper)
	return math.min(math.max(lower, val), upper)
end

---Overlays a target `image` over a target `destination`, accounting for alpha and the such
---@param destination string
---@param image string
---@param offset_x int? `0` - x offset for the overlay's location on the destination image
---@param offset_y int? `0` - y offset for the overlay's location on the destination image
---@param alpha_multiplier number? `1` - multiplier for the alpha value of the overlay image
function ImageOverlay(destination, image, offset_x, offset_y, alpha_multiplier)
	if not ModDoesFileExist(destination) then print("destination was not valid for image overlay") return end
	if not ModDoesFileExist(image) then print("image was not valid for image overlay") return end

	offset_x = offset_x or 0
	offset_y = offset_y or 0
	local logging
	if offset_x ~= 0 then logging = true end
	alpha_multiplier = alpha_multiplier or 1

	local dest_data = {}
	local img_data = {}
	img_data.id,img_data.w,img_data.h = ModImageMakeEditable(image, 0, 0)
	dest_data.id,dest_data.w,dest_data.h = ModImageMakeEditable(destination, 0, 0)

	local w = img_data.w
	local h = img_data.h

	for y = 0, h - 1 do
		for x = 0, w - 1 do
			local dest_pixel = {abgr_split(ModImageGetPixel(dest_data.id, x + offset_x, y + offset_y))}
			local img_pixel = {abgr_split(ModImageGetPixel(img_data.id, x, y))}
			for i = 1, 4 do
				local difference = (img_pixel[i] - dest_pixel[i]) * (img_pixel[4]/255) * alpha_multiplier
				if difference == 0 then goto continue end
				dest_pixel[i] = math.clamp(dest_pixel[i] + difference, 0, 255)
			end

			--if logging then print(x + offset_x .. ", " .. y + offset_y) end
			ModImageSetPixel(dest_data.id, x + offset_x, y + offset_y, abgr_merge(unpack(dest_pixel)))
			::continue::
		end
	end
end

---Sets the alpha channel of all pixels (except empty ones) to the designated value
---@param image string
---@param value int [0-255]
---@param set_empty bool? if true, will also set empty pixels
function ImageSetOpacity(image, value, set_empty)
	local img,w,h = ModImageMakeEditable(image, 0, 0)
	local a = value
	for y = 0, h-1 do
		for x = 0, w-1 do
			local r,g,b,a2 = abgr_split(ModImageGetPixel(img, x, y))
			if a2 ~= 0 or set_empty then
				ModImageSetPixel(img, x, y, abgr_merge(r,g,b,a))
			end
		end
	end
end