# NVIMDSA

An interactive Data Structures and Algorithms learning environment inside Neovim.

Built on top of [leetcode.nvim](https://github.com/kawre/leetcode.nvim) by kawre.

## What is it

NVIMDSA turns Neovim into a structured DSA course. You navigate a roadmap of topics, open a lesson, read the theory, and solve a TypeScript exercise without leaving your editor. Tests run instantly via bun and results appear in a popup.

## Design

Two module trees handle distinct concerns:

- `nvimdsa/` — menu, page routing, roadmap UI. Owns the `_NVIMDSA_state` global and all navigation logic.
- `leetcode/learn/` — lesson engine: loads data files, opens the two-panel view, runs tests.

A lesson data file (`lua/leetcode/learn/data/<name>.lua`) contains a `content` field (theory text) and an `exercise` table (problem statement, starter code, test harness). The lesson engine renders theory on the left and the code buffer on the right.

## How it works

1. Run `nvimdsa` from the terminal (or `:NVIMDSA` inside Neovim)
2. Select Data Structures or Algorithms from the home menu
3. Press a lesson shortcut on the roadmap
4. Read the theory panel on the left
5. Switch to the code panel (`<C-l>`), implement the solution
6. Press `<leader>r` to run tests via bun
7. Press `q` to close and return to the roadmap

## Requirements

- Neovim >= 0.9
- [bun](https://bun.sh) — TypeScript test runner
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

leetcode.nvim is bundled — no separate install needed.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "allocmemory/NVIMDSA",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("nvimdsa").setup()
    end,
}
```

## Terminal launcher

Create a shell script to open NVIMDSA directly from your terminal:

```bash
cat > ~/.local/bin/nvimdsa << 'EOF'
#!/bin/bash
exec nvim -c 'lua require("nvimdsa").open()' "$@"
EOF
chmod +x ~/.local/bin/nvimdsa
```

Make sure `~/.local/bin` is on your `PATH`.

## Keymaps

Inside a lesson:

| Key | Action |
|---|---|
| `<C-l>` | Focus code panel |
| `<C-h>` | Focus theory panel |
| `<leader>r` | Run tests |
| `q` | Close lesson |

On roadmap pages, each available topic has a single-letter shortcut shown next to it. `q` always goes back.

## Credits

- [leetcode.nvim](https://github.com/kawre/leetcode.nvim) by kawre — the underlying plugin that powers the UI primitives and LeetCode integration
- NVIMDSA by [allocmemory](https://github.com/allocmemory)
