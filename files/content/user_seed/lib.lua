local function encode(str, map, splits)
    map = map or "0123456789"
    local b = #map

    local blocks = {}
    local last_pos = 0
    for i,val in ipairs(splits) do
        blocks[i] = tonumber(str:sub(last_pos+1, last_pos+val))
        last_pos = last_pos + val
    end


    local results = {}
    for i,n in ipairs(blocks) do
        local t = {}
        repeat
            local d = (n % b) + 1
            n = math.floor(n / b)
            table.insert(t, 1, map:sub(d,d))
        until n == 0
        results[i] = table.concat(t)
    end
    return unpack(results)
end

print("----------------------------1")
print(table.concat({encode("123456789012345678901234567890", "0123456789ABCDEF", {10,10,10})}, "-"))
print(table.concat({encode(ModSettingGet("fairmod.user_seed"), "0123456789ABCDEF", {12,12,6})}, "-"))
print(table.concat({encode(ModSettingGet("fairmod.user_seed"), "0123456789ABCDEF", {3,9,9,9})}, "-"))
print(table.concat({encode(ModSettingGet("fairmod.user_seed"), "0123456789ABCDEF", {6,6,6,6})}, "-"))


--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXXXXXXX-XXXXXXXXXXXX-XXXXXX
--XXX-XXXXXXXXX-XXXXXXXXX-XXXXXXXXX
--XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX