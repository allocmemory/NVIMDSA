local ui_utils = require("leetcode-ui.utils")
local runner = require("leetcode.learn.runner")

local api = vim.api

---@class lc.learn.UI
local ui = {}

-- Global state for the currently open learn session.
-- Stored on the module table so it survives across require() calls.
-- Set to nil when the tab is closed.
_Lc_learn_state = nil ---@type { tabpnr: integer, left_winid: integer, right_winid: integer, tmp_path: string, module_name: string } | nil

-- Comment character per language extension.
local COMMENT_CHAR = {
    py = "#",
    python = "#",
    ts = "//",
    typescript = "//",
    js = "//",
    javascript = "//",
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

---Return the comment prefix for a given exercise (e.g. "# " or "// ").
---@param exercise table
---@return string
local function comment_prefix(exercise)
    return (COMMENT_CHAR[exercise.ext] or "#") .. " "
end

---Build the right-panel buffer lines from exercise data.
---Layout:
---  <comment> ──────────────────────────────────────
---  <comment> EXERCISE: <title>
---  <comment> <problem lines>
---  <comment> ──────────────────────────────────────
---  <comment> @learn start
---  <blank line>
---  <starter code>
---@param exercise table
---@return string[]
local function build_right_lines(exercise)
    local cp = comment_prefix(exercise)
    local divider = cp .. ("─"):rep(76)
    local marker = cp .. "@learn start"

    local lines = {}

    table.insert(lines, divider)

    for i, raw_line in ipairs(vim.split(exercise.problem, "\n")) do
        if i == 1 then
            table.insert(lines, cp .. "EXERCISE: " .. raw_line)
        else
            table.insert(lines, cp .. raw_line)
        end
    end

    table.insert(lines, divider)
    table.insert(lines, marker)
    table.insert(lines, "")

    for _, code_line in ipairs(vim.split(exercise.code, "\n")) do
        table.insert(lines, code_line)
    end

    return lines
end

---Find the 1-based line number of the @learn start marker in a buffer.
---Matches any comment style: "# @learn start" or "// @learn start" etc.
---@param bufnr integer
---@return integer? line_nr  nil if not found
local function find_marker_line(bufnr)
    local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("@learn start") then
            return i
        end
    end
end

---Set common read-only display options on a window + buffer.
---@param winid integer
---@param bufnr integer
local function apply_readonly_opts(winid, bufnr)
    ui_utils.buf_set_opts(bufnr, {
        modifiable = false,
        buflisted = false,
        buftype = "nofile",
        bufhidden = "wipe",
        swapfile = false,
        matchpairs = "",
        synmaxcol = 0,
    })
    ui_utils.win_set_opts(winid, {
        wrap = true,
        linebreak = true,
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        cursorcolumn = false,
        colorcolumn = "",
        list = false,
        spell = false,
        winhighlight = "Normal:NormalFloat",
    })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Results popup
-- ─────────────────────────────────────────────────────────────────────────────

---Display test output in a floating nui popup at the bottom-center of the editor.
---@param output_lines string[]
function ui.show_results(output_lines)
    local NuiPopup = require("nui.popup")
    local event = require("nui.utils.autocmd").event

    local height = math.min(#output_lines + 2, 18)
    local width = 60

    local popup = NuiPopup({
        relative = "editor",
        position = { row = "88%", col = "50%" },
        size = { width = width, height = height },
        border = {
            style = "rounded",
            text = {
                top = " Test Results ",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            wrap = false,
        },
        buf_options = {
            modifiable = true,
            readonly = false,
        },
        focusable = true,
        enter = true,
    })

    popup:mount()

    api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, output_lines)
    api.nvim_set_option_value("modifiable", false, { buf = popup.bufnr })

    -- q or the toggle key closes the popup.
    popup:map("n", "q", function()
        popup:unmount()
    end, { noremap = true })

    popup:on(event.BufLeave, function()
        vim.schedule(function()
            popup:unmount()
        end)
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────────────────────

---Register buffer-local keymaps on both learn panels.
---@param left_winid integer
---@param right_winid integer
---@param left_bufnr integer
---@param right_bufnr integer
---@param exercise table
---@param module_name string
local function set_keymaps(left_winid, right_winid, left_bufnr, right_bufnr, exercise, module_name)
    local opts_left = { noremap = true, silent = true, buffer = left_bufnr }
    local opts_right = { noremap = true, silent = true, buffer = right_bufnr }

    -- q: close the entire learn tab from either panel.
    vim.keymap.set("n", "q", ui.close, opts_left)
    vim.keymap.set("n", "q", ui.close, opts_right)

    -- <C-h>: focus left panel.
    local function focus_left()
        if api.nvim_win_is_valid(left_winid) then
            api.nvim_set_current_win(left_winid)
        end
    end
    vim.keymap.set("n", "<C-h>", focus_left, opts_left)
    vim.keymap.set("n", "<C-h>", focus_left, opts_right)

    -- <C-l>: focus right panel.
    local function focus_right()
        if api.nvim_win_is_valid(right_winid) then
            api.nvim_set_current_win(right_winid)
        end
    end
    vim.keymap.set("n", "<C-l>", focus_right, opts_left)
    vim.keymap.set("n", "<C-l>", focus_right, opts_right)

    -- <leader>r: run tests (operates on the right buffer).
    local function run_tests()
        local buf_lines = api.nvim_buf_get_lines(right_bufnr, 0, -1, false)
        runner.run(module_name, exercise, buf_lines, function(output)
            ui.show_results(output)
        end)
    end
    vim.keymap.set("n", "<leader>r", run_tests, opts_left)
    vim.keymap.set("n", "<leader>r", run_tests, opts_right)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Lock guard for the problem-statement section of the right buffer
-- ─────────────────────────────────────────────────────────────────────────────

---Attach an InsertEnter autocmd that prevents editing above the @learn start marker.
---@param bufnr integer
local function attach_lock_guard(bufnr)
    local group = api.nvim_create_augroup("leetcode_learn_lock_" .. bufnr, { clear = true })

    api.nvim_create_autocmd("InsertEnter", {
        group = group,
        buffer = bufnr,
        callback = function()
            local marker_line = find_marker_line(bufnr)
            if not marker_line then
                return
            end
            local row = api.nvim_win_get_cursor(0)[1]
            if row <= marker_line then
                vim.cmd("stopinsert")
                vim.notify(
                    "This section is read-only. Edit below the ─── @learn start ─── marker.",
                    vim.log.levels.WARN,
                    { title = "leetcode.nvim" }
                )
            end
        end,
    })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────────

---Close the learn tab.
function ui.close()
    if not _Lc_learn_state then
        return
    end
    -- Switch to the learn tab first, then close it, so we don't accidentally
    -- close whatever tab the user happens to be on.
    local tabpnr = _Lc_learn_state.tabpnr
    if tabpnr and pcall(api.nvim_set_current_tabpage, tabpnr) then
        vim.cmd("tabclose")
    end
    _Lc_learn_state = nil
end

---Open the learn interface for the given module.
---If a learn tab is already open, switch to it instead of opening a duplicate.
---@param module_name string
---@param data table  full module data from data/<module_name>.lua
function ui.open(module_name, data)
    -- ── Guard: switch to existing learn tab if already open ───────────────
    if _Lc_learn_state then
        local tabpnr = _Lc_learn_state.tabpnr
        local ok = pcall(api.nvim_set_current_tabpage, tabpnr)
        if ok then
            return
        end
        -- Tab no longer valid; fall through to open a fresh one.
        _Lc_learn_state = nil
    end

    local exercise = data.exercise

    -- ── Open a new tab ────────────────────────────────────────────────────
    -- Position 0 keeps it before the menu tab's questions.
    vim.cmd("0tabnew")
    local tabpnr = api.nvim_get_current_tabpage()

    -- ── Left panel: scratch buffer with theory content ────────────────────
    local left_winid = api.nvim_get_current_win()
    local left_bufnr = api.nvim_get_current_buf() -- reuse tabnew's buffer, no orphan

    local content_lines = vim.split(data.content, "\n", { plain = true })
    -- nvim_buf_set_lines needs modifiable; it is true on a fresh buf.
    api.nvim_buf_set_lines(left_bufnr, 0, -1, false, content_lines)
    apply_readonly_opts(left_winid, left_bufnr)
    -- keep theory buffer alive if user navigates the left window away
    api.nvim_set_option_value("bufhidden", "hide", { buf = left_bufnr })

    -- ── Right panel: temp file with problem statement + starter code ───────
    vim.cmd("vsplit")
    local right_winid = api.nvim_get_current_win()

    local right_lines = build_right_lines(exercise)
    local tmp_path = ("/tmp/leet_learn_%s.%s"):format(module_name, exercise.ext)

    local f, err = io.open(tmp_path, "w")
    if not f then
        vim.notify("learn ui: could not write temp file: " .. (err or "?"), vim.log.levels.ERROR)
        vim.cmd("tabclose")
        return
    end
    f:write(table.concat(right_lines, "\n"))
    f:write("\n")
    f:close()

    vim.cmd("edit " .. vim.fn.fnameescape(tmp_path))
    local right_bufnr = api.nvim_get_current_buf()

    -- Set filetype so LSP and treesitter activate.
    api.nvim_set_option_value("filetype", exercise.lang, { buf = right_bufnr })

    ui_utils.win_set_opts(right_winid, {
        number = true,
        relativenumber = false,
        signcolumn = "yes:1",
        foldcolumn = "0",
        wrap = false,
        list = false,
        spell = false,
        colorcolumn = "",
        cursorline = true,
    })

    -- ── Set 40/60 split ───────────────────────────────────────────────────
    local left_width = math.floor(vim.o.columns * 0.40)
    api.nvim_win_set_width(left_winid, left_width)

    -- ── Lock guard for the problem-statement header ────────────────────────
    attach_lock_guard(right_bufnr)

    -- ── Keymaps ───────────────────────────────────────────────────────────
    set_keymaps(left_winid, right_winid, left_bufnr, right_bufnr, exercise, module_name)

    -- ── State ─────────────────────────────────────────────────────────────
    _Lc_learn_state = {
        tabpnr = tabpnr,
        left_winid = left_winid,
        right_winid = right_winid,
        tmp_path = tmp_path,
        module_name = module_name,
    }

    -- Clean up state when the tab is closed (user :tabclose, ZQ, etc.)
    local group = api.nvim_create_augroup("leetcode_learn_tab_" .. tabpnr, { clear = true })
    api.nvim_create_autocmd("TabClosed", {
        group = group,
        callback = function(ev)
            -- ev.file is the tab number that was closed (as a string).
            if _Lc_learn_state and tonumber(ev.file) == tabpnr then
                _Lc_learn_state = nil
                api.nvim_del_augroup_by_id(group)
            end
        end,
    })

    -- Move cursor to just below the @learn start marker in the right panel.
    vim.schedule(function()
        if not api.nvim_win_is_valid(right_winid) then
            return
        end
        local marker = find_marker_line(right_bufnr)
        if marker then
            -- +2: skip the marker line itself and the blank line after it.
            pcall(api.nvim_win_set_cursor, right_winid, { marker + 2, 0 })
        end
        api.nvim_set_current_win(right_winid)

        -- Open cheatsheet in a separate tab if one exists for this language.
        local cs_ok, cs_lines = pcall(require, "leetcode.learn.cheatsheets." .. exercise.ext)
        if cs_ok then
            vim.cmd("tabnew")
            local cs_bufnr = api.nvim_get_current_buf()
            local cs_winid = api.nvim_get_current_win()
            api.nvim_buf_set_lines(cs_bufnr, 0, -1, false, cs_lines)
            apply_readonly_opts(cs_winid, cs_bufnr)
            vim.keymap.set("n", "q", function()
                pcall(api.nvim_set_current_tabpage, tabpnr)
            end, { noremap = true, silent = true, buffer = cs_bufnr })
            pcall(api.nvim_set_current_tabpage, tabpnr)
        end
    end)
end

return ui
