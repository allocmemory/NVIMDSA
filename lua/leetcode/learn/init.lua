local log = require("leetcode.logger")

---@class lc.learn
local learn = {}

---Open the learn interface for the named module.
---Called by the command routing in lua/leetcode/command/init.lua.
---@param module_name string  e.g. "stack"
function learn.open(module_name)
    local mod_path = "leetcode.learn.data." .. module_name
    local ok, data = pcall(require, mod_path)
    if not ok then
        -- Clear Lua's failure cache so the next call retries instead of
        -- showing the opaque "loop or previous error loading" message.
        package.loaded[mod_path] = nil
        log.error(("learn: failed to load '%s': %s"):format(module_name, data))
        return
    end

    local UI_PATH = "leetcode.learn.ui"
    local ui_ok, ui = pcall(require, UI_PATH)
    if not ui_ok then
        package.loaded[UI_PATH] = nil
        log.error(("learn: failed to load ui: %s"):format(ui))
        return
    end

    ui.open(module_name, data)
end

return learn
