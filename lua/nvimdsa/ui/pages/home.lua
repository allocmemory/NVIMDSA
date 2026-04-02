local Page = require("leetcode-ui.group.page")
local Title = require("leetcode-ui.lines.title")
local Buttons = require("leetcode-ui.group.buttons.menu")
local MenuButton = require("leetcode-ui.lines.button.menu")
local ExitButton = require("leetcode-ui.lines.button.menu.exit")

local header = require("nvimdsa.ui.lines.header")

local page = Page()

page:insert(header)
page:insert(Title({}, "Home"))

-- ── LeetCode launcher ──────────────────────────────────────────────────────
-- Called when user picks "LeetCode" from the home menu.
-- Opens a fresh tab so the NVIMDSA menu is preserved, then boots the full
-- leetcode.nvim flow (cookie auth, problem list, etc.).
local function launch_leetcode()
    vim.cmd("tabnew")
    -- setup() registers :Leet and the VimEnter autocmd; safe to call multiple times.
    require("leetcode").setup({
        lang = "typescript",
        plugins = { non_standalone = true },
    })
    require("leetcode").start(false)
end

local ds_btn = MenuButton("Learn Data Structures", {
    icon = "󰙱",
    sc = "d",
    expandable = true,
    on_press = function()
        _NVIMDSA_state.menu:set_page("ds")
    end,
})

local algo_btn = MenuButton("Learn Algorithms", {
    icon = "",
    sc = "a",
    expandable = true,
    on_press = function()
        _NVIMDSA_state.menu:set_page("algo")
    end,
})

local lc_btn = MenuButton("LeetCode", {
    icon = "",
    sc = "l",
    expandable = false,
    on_press = launch_leetcode,
})

local exit_btn = ExitButton()

page:insert(Buttons({ ds_btn, algo_btn, lc_btn, exit_btn }))

return page
