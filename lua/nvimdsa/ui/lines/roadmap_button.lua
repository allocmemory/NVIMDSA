local MenuButton = require("leetcode-ui.lines.button.menu")

---@class nvimdsa.ui.RoadmapButton : lc.ui.Button.Menu
local RoadmapButton = MenuButton:extend("NvimDSARoadmapButton")

---@param text string
---@param opts { available: boolean, icon?: string, sc?: string, on_press?: function }
function RoadmapButton:init(text, opts)
    opts = vim.tbl_deep_extend("force", {
        available = false,
        icon = "■",
    }, opts or {})

    if opts.available then
        RoadmapButton.super.init(self, text, {
            icon = opts.icon,
            sc = opts.sc,
            on_press = opts.on_press or function() end,
            expandable = false,
        })
    else
        -- Build a non-interactive looking button with "coming soon" badge.
        -- Still registered as a button so the cursor can land on it,
        -- but pressing it shows a notification instead of doing anything.
        RoadmapButton.super.init(self, text, {
            icon = opts.icon,
            sc = nil, -- no shortcut shown
            on_press = function()
                vim.notify(
                    ("'%s' is coming soon!"):format(text),
                    vim.log.levels.INFO,
                    { title = "NVIMDSA" }
                )
            end,
            expandable = false,
        })

        -- Override the rendered text: append "coming soon" badge in Comment hl.
        -- The parent already built the line content; append the badge after the padding.
        -- We do this by directly appending to self (which is a Lines/Button).
        self:append("  coming soon", "Comment")
    end
end

---@type fun(text: string, opts: table): nvimdsa.ui.RoadmapButton
local NvimDSARoadmapButton = RoadmapButton

return NvimDSARoadmapButton
