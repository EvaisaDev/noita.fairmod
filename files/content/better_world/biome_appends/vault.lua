function safe( x, y ) return true end --there is no safety.

for _, target_table in ipairs({g_small_enemies, g_big_enemies, g_props, g_hanging_props, g_turret, g_machines}) do --goes through these tables in the vault.lua script and removes null spawns
    for target, value in pairs(target_table) do
        if type(value) == "table" then
            local is_nil
            for key, contents in pairs(value) do
                if type(contents) == "string" and contents ~= "" then
                    is_nil = false
                end
            end
            if is_nil ~= false then
                value = nil
            end
        end
    end
end

