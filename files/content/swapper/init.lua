local swapper = {}

local material_clone_values = {
    ui_name = true,
    density = true,
    liquid_gravity = true,
    gfx_glow = true,
}

function nxml_first_of(target, element_name)
    for k, v in ipairs(target.children) do
        if v.name == element_name then return v, k end
    end
end




function swapper.OnMagicNumbersAndWorldSeedInitialized()
    print("===================================================================================================")
    local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
    local files = ModMaterialFilesGet() -- get all modded material files
    files[#files+1] = "data/materials.xml" -- get vanilla
    local materials = {}
    for index, file in ipairs(files) do
        materials[file] = {}
        local xml = nxml.parse_file(file)
        for child in xml:each_child() do
            local tags = child.attr.tags or ""
            if string.find(tags, "%[magic_liquid%]") and not string.find(tags, "%[catastrophic%]") then --filter to non-[catastrophic] [magic_liquid]s
                materials[file][#materials[file] + 1] = child -- add the material to the list of swappables
            end
        end
    end


    for index, A in ipairs(materials) do
        local sum = 0
        for index, value in ipairs(materials) do
            sum = sum + #value
        end

        local B
        local rnd = Random(1, sum)
        for index, value in ipairs(materials) do
            if #value <= rnd then
                B = value[rnd]
                break
            else
                rnd = rnd - #value
            end
        end

        local C = {}
        for key, value in pairs(B.attr) do
            if material_clone_values[key] then
                C[key] = value
            end
        end

        for key, value in pairs(B.attr) do
            if material_clone_values[key] then
                B.attr[key] = A.attr[key]
            end
        end

        for key, value in pairs(C) do
            A.attr[key] = C[key]
        end


        local a_graphics = A:first_of("Graphics") -- check if Graphics Component exists on material A
        local b_graphics = B:first_of("Graphics") -- check if Graphics Component exists on material B

        if b_graphics then -- if B exists, replace with A, even if A is nil
            local storage = {} -- create storage table
            for key, value in pairs(b_graphics) do
                storage[key] = value -- clone table b onto storage
            end
            b_graphics = a_graphics
            a_graphics =  storage -- copy storage onto table a
        elseif a_graphics then -- if B does not exist but A does exist, add A to B
            B.children[#B.children + 1] = a_graphics
        end


        local a_effect = A:first_of("ParticleEffect") -- check if Particle Effect exists on material A
        local b_effect = B:first_of("ParticleEffect") -- check if Particle Effect exists on material B

        if b_effect then -- if B exists, replace with A, even if A is nil
            local storage = {} -- create storage table
            for key, value in pairs(b_effect) do
                storage[key] = value -- clone table b onto storage
            end
            b_effect = a_effect
            a_effect =  storage -- copy storage onto table a
        elseif a_effect then -- if B does not exist but A does exist, add A to B
            B.children[#B.children + 1] = a_effect
        end


    end

    print("a")
    for index, file in ipairs(materials) do
        print("b")
        for index, material in ipairs(file) do
            print("[" .. material.attr.name .. "] -> [" .. material.attr.ui_name .. "]")
        end
    end

end



return swapper