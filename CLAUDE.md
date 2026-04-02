# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Formatting

This repo uses **StyLua** for Lua formatting. Config lives in `.stylua.toml`:
- 4-space indentation, 100-column width, double quotes, Unix line endings

```bash
stylua lua/          # format in place
stylua --check lua/  # check without writing
```

There are no automated tests in this repo.

## Module namespaces

All code lives under `lua/`. Three distinct module trees:

- **`nvimdsa/`** — NVIMDSA entry point and all NVIMDSA-specific UI (menu, pages, custom components).
- **`leetcode/`** — pure logic: config, API calls, commands, learn system, runner. No Neovim windows created here.
- **`leetcode-ui/`** — reusable UI primitives: buffers, windows, rendering tree, button base classes.

`lua/nvimdsa/init.lua` is the NVIMDSA public surface — owns `setup()` (registers `:NVIMDSA` command) and `open()` (opens/switches to the menu tab).

## Global state

**Never mix the two state globals.** They are separate systems:

```lua
_NVIMDSA_state.menu   -- nvimdsa.ui.Menu (NvimDSAMenu instance)
_Lc_state.menu        -- leetcode-ui Menu (only set when leetcode.nvim is open)
```

NVIMDSA pages must always use `_NVIMDSA_state.menu:set_page(name)` for navigation. Using `_Lc_state` from NVIMDSA pages crashes when LeetCode has never been opened.

## OOP via `nui.object`

```lua
local Parent = require("some.parent")
local Child = Parent:extend("ChildName")

function Child:init(...)
    Child.super.init(self, ...)
end
```

NVIMDSA inheritance chain:
```
nui.object → Lines → Group → Renderer → NvimDSAMenu
```

## Page routing

Each page is a module at `lua/nvimdsa/ui/pages/<name>.lua` that returns a `Page()` object.
`NvimDSAMenu:set_page(name)` does `require("nvimdsa.ui.pages." .. name)`, replaces the content tree, and redraws.

Navigation between roadmap and home always goes through `_NVIMDSA_state.menu:set_page("home")`. Never use `BackButton` from `leetcode-ui` — it routes through `_Lc_state`.

## UI rendering model

`Renderer` owns `bufnr`/`winid`. `renderer:draw()` clears the buffer and recursively walks `Group → Lines → Line`, writing via `nvim_buf_set_lines` and `nvim_buf_set_extmark`. Button callbacks are tracked in `renderer._.buttons` keyed by line number.

`Group` is the composable unit: `:insert()` adds a pre-built item; `:append()` + `:endgrp()` flush the inline-append buffer.

## Learn system

`lua/leetcode/learn/` implements the two-panel learning UI:

- **`init.lua`** — `learn.open(module_name)`: loads data file, calls `ui.open()`
- **`ui.lua`** — opens a new tab with left (theory) / right (code) split; `<leader>r` runs tests, `q` closes tab
- **`runner.lua`** — writes user code + test harness to `/tmp/leet_learn_<module>.<ext>`, runs via `jobstart`, shows results in a popup
- **`data/init.lua`** — registry list; add a module name here to make it discoverable
- **`data/<name>.lua`** — each lesson module

### Learn data file structure

```lua
return {
    content = [=[...theory text...]=],  -- MUST use level-1 [=[ ]=] — code examples contain ]]
    exercise = {
        lang = "typescript",
        ext  = "ts",
        problem = [[...problem statement...]],
        code    = [[...starter code...]],
        tests   = [[...test harness appended after user code...]],
    },
}
```

**Critical:** always use `[=[...]=]` (level-1 long strings) for `content`. Level-0 `[[...]]` terminates on the first `]]` inside code examples.

### Runner interpreter map

| `exercise.ext` | interpreter |
|---|---|
| `ts` / `typescript` | `bun` |
| `js` / `javascript` | `node` |
| `py` / `python` | `python3` |

Python and JS entries are intentionally kept — they are planned future exercise languages alongside C. See `doc/future-ideas.md`.

## RoadmapButton

`lua/nvimdsa/ui/lines/roadmap_button.lua` wraps `MenuButton`:
- `available = true` — interactive button with `on_press` callback
- `available = false` — grayed out with a "coming soon" badge; shows a notification on press

## LeetCode integration

The NVIMDSA home page launches leetcode.nvim in a separate tab via:
```lua
require("leetcode").setup({ lang = "typescript", plugins = { non_standalone = true } })
require("leetcode").start(false)
```
The `non_standalone` plugin allows leetcode.nvim to run alongside other buffers (NVIMDSA menu stays open in tab 1).

## Terminal launcher

`~/.local/bin/nvimdsa` — shell wrapper that opens NVIMDSA directly from the terminal:
```bash
#!/bin/bash
exec nvim -c 'lua require("nvimdsa").open()' "$@"
```
The `-c` flag (not `--cmd`) runs after plugins load, making `require("nvimdsa")` available.
