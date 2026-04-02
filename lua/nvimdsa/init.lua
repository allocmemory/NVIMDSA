---@class nvimdsa
local nvimdsa = {}

function nvimdsa.setup()
    _NVIMDSA_state = { menu = nil }

    vim.api.nvim_create_user_command("NVIMDSA", function()
        nvimdsa.open()
    end, {
        desc = "Open NVIMDSA — Learn DSA & LeetCode",
    })
end

function nvimdsa.open()
    -- If the menu tab is still alive, switch to it.
    local state = _NVIMDSA_state
    if state and state.menu then
        local winid = state.menu.winid
        if winid and vim.api.nvim_win_is_valid(winid) then
            local tabp = vim.api.nvim_win_get_tabpage(winid)
            pcall(vim.api.nvim_set_current_tabpage, tabp)
            return
        end
        -- Window is gone — fall through and remount.
    end

    -- Open a new tab and mount the NVIMDSA menu there.
    vim.cmd("tabnew")
    local Menu = require("nvimdsa.ui.menu")
    Menu():mount()
end

return nvimdsa
