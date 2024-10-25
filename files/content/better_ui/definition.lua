--- @meta

--- @class display_entry
--- @field text string|string[]|nil
--- @field color? {[1]:number, [2]:number, [3]:number, [4]:number}
--- @field tooltip? string
--- @field on_click? function

--- @alias display_text display_entry|string|nil

--- @class ui_display
--- @field text display_text|fun():display_text
--- @field condition? fun():boolean
