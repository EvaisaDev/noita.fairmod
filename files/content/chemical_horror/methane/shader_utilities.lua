postfx = {
    append = function(code, insert_after_line)
        if(insert_after_line ~= nil)then
            if(type(code) ~= "string")then
                error("append argument has to be a string!")
            else
                local post_final = ModTextFileGetContent("data/shaders/post_final.frag")
                if(post_final ~= nil)then
        
                    lines = {}
                    for s in post_final:gmatch("[^\r\n]+") do
                        table.insert(lines, s)
                    end
                
                    content = ""

                    for i, line in ipairs(lines) do

                        if(string.match(line, insert_after_line))then
                            line = line..string.char(10)..code
                        end
                        content = content..line..string.char(10)
                    end
                    ModTextFileSetContent("data/shaders/post_final.frag", content)
                end
                
            end
        else
            error("no insert line given!")
        end
    end,
}
