local Page = require("leetcode-ui.group.page")
local Title = require("leetcode-ui.lines.title")
local Buttons = require("leetcode-ui.group.buttons.menu")
local MenuButton = require("leetcode-ui.lines.button.menu")
local Group = require("leetcode-ui.group")

local RoadmapButton = require("nvimdsa.ui.lines.roadmap_button")
local header = require("nvimdsa.ui.lines.header")

local function section(label)
    local g = Group({}, { hl = "Comment", padding = { top = 1 } })
    g:append(("── %s "):format(label))
    g:endgrp()
    return g
end

local page = Page()

page:insert(header)
page:insert(Title({ "Home" }, "Algorithms"))

-- Patterns
page:insert(section("Patterns"))
page:insert(Buttons({
    RoadmapButton("Two Pointers", {
        icon = "■",
        available = true,
        sc = "t",
        on_press = function()
            require("leetcode.learn").open("two_pointers")
        end,
    }),
    RoadmapButton("Sliding Window", {
        icon = "■",
        available = true,
        sc = "s",
        on_press = function()
            require("leetcode.learn").open("sliding_window")
        end,
    }),
    RoadmapButton("Binary Search", {
        icon = "■",
        available = true,
        sc = "b",
        on_press = function()
            require("leetcode.learn").open("binary_search")
        end,
    }),
}))

-- Graph traversal
page:insert(section("Graph"))
page:insert(Buttons({
    RoadmapButton("DFS / BFS", {
        icon = "■",
        available = true,
        sc = "d",
        on_press = function()
            require("leetcode.learn").open("dfs_bfs")
        end,
    }),
}))

-- Dynamic & optimization
page:insert(section("Dynamic"))
page:insert(Buttons({
    RoadmapButton("Dynamic Programming", {
        icon = "■",
        available = true,
        sc = "p",
        on_press = function()
            require("leetcode.learn").open("dynamic_programming")
        end,
    }),
    RoadmapButton("Backtracking", {
        icon = "■",
        available = true,
        sc = "k",
        on_press = function()
            require("leetcode.learn").open("backtracking")
        end,
    }),
    RoadmapButton("Greedy", {
        icon = "■",
        available = true,
        sc = "g",
        on_press = function()
            require("leetcode.learn").open("greedy")
        end,
    }),
}))

page:insert(Buttons({
    MenuButton("Back", {
        icon = "",
        sc = "q",
        on_press = function()
            _NVIMDSA_state.menu:set_page("home")
        end,
    }),
}))

return page
