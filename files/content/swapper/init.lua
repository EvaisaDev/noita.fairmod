local swapper = {}

local material_clone_values = {
    ui_name = true,
    density = true,
    liquid_gravity = true,
    gfx_glow = true,
}



--this mostly works, just need to get graphics and particles to work


function swapper.OnMagicNumbersAndWorldSeedInitialized()
    print("===================================================================================================")
    local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
    local files = ModMaterialFilesGet() -- get all modded material files
    local materials = {}
    for index, file in ipairs(files) do
        local xml = nxml.parse_file(file)
        materials[file] = {}
        for child in xml:each_child() do
            local tags = child.attr.tags or ""
            if string.find(tags, "%[magic_liquid%]") and not string.find(tags, "%[catastrophic%]") then --filter to non-[catastrophic] [magic_liquid]s
                --print("adding material [" .. child.attr.name .. "] to materials -> \"" .. file .. "\"")
                materials[file][#materials[file] + 1] = child -- add the material to the list of swappables
            end
        end

        if #materials[file] == 0 then materials[file] = nil goto continue end

        print("Materials under \"" .. file .. "\":")
        for index, value in ipairs(materials[file]) do
            --print("    " .. value.attr.name)
        end
        ::continue::
    end


    local val = 0
    for key, file in pairs(materials) do
        for index, value in ipairs(file) do
            val = val + 1
            print(val .. ": " .. value.attr.name)
        end
    end


    local num = 22
    for index, file in pairs(materials) do
        if #file >= num then
            print(file[num].attr.name)
            break
        else
            num = num - #file
        end
    end

    local sum = 0
    for index, value in pairs(materials) do
        sum = sum + #value
    end

    for index, _file in pairs(materials) do
        for index, A in ipairs(_file) do
            print("Material A is " .. A.attr.name)

            local B
            local rnd = Random(1, sum)
            for index, file in pairs(materials) do
                if #file >= rnd then
                    B = file[rnd]
                    print("  Material B is " .. file[rnd].attr.name)
                    break
                else
                    rnd = rnd - #file
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

            if b_graphics ~= nil then -- if B exists, replace with A, even if A is nil
                local storage = {} -- create storage table
                for key, value in pairs(b_graphics) do
                    storage[key] = value -- clone table b onto storage
                end
                b_graphics = a_graphics
                a_graphics = storage -- copy storage onto table a
            elseif a_graphics ~= nil then -- if B does not exist but A does exist, add A to B
                B.children[#B.children + 1] = a_graphics
            end


            local a_effect = A:first_of("ParticleEffect") -- check if Particle Effect exists on material A
            local b_effect = B:first_of("ParticleEffect") -- check if Particle Effect exists on material B

            if b_effect ~= nil then -- if B exists, replace with A, even if A is nil
                local storage = {} -- create storage table
                for key, value in pairs(b_effect) do
                    storage[key] = value -- clone table b onto storage
                end
                b_effect = a_effect
                a_effect = storage -- copy storage onto table a
            elseif a_effect ~= nil then -- if B does not exist but A does exist, add A to B
                B.children[#B.children + 1] = a_effect
            end
        end
    end

    for filepath, file in pairs(materials) do
        local xml = nxml.parse_file(filepath)
        for index, material in ipairs(file) do
            xml:add_child(material)
        end
        ModTextFileSetContent(filepath, tostring(xml))
    end

end



return swapper