local Page = require("leetcode-ui.group.page")
local Title = require("leetcode-ui.lines.title")
local Buttons = require("leetcode-ui.group.buttons.menu")
local MenuButton = require("leetcode-ui.lines.button.menu")
local Group = require("leetcode-ui.group")
local Lines = require("leetcode-ui.lines")

local RoadmapButton = require("nvimdsa.ui.lines.roadmap_button")
local header = require("nvimdsa.ui.lines.header")

-- ── Section label helper ───────────────────────────────────────────────────
local function section(label)
    local g = Group({}, { hl = "Comment", padding = { top = 1 } })
    g:append(("── %s "):format(label))
    g:endgrp()
    return g
end

-- ── Page ──────────────────────────────────────────────────────────────────
local page = Page()

page:insert(header)
page:insert(Title({ "Home" }, "Data Structures"))

-- Foundations
page:insert(section("Foundations"))
page:insert(Buttons({
    RoadmapButton("Complexity", {
        icon = "■",
        available = true,
        sc = "c",
        on_press = function()
            require("leetcode.learn").open("complexity")
        end,
    }),
    RoadmapButton("Stack", {
        icon = "■",
        available = true,
        sc = "s",
        on_press = function()
            require("leetcode.learn").open("stack")
        end,
    }),
    RoadmapButton("Array", {
        icon = "■",
        available = true,
        sc = "a",
        on_press = function()
            require("leetcode.learn").open("array")
        end,
    }),
    RoadmapButton("Queue", {
        icon = "■",
        available = true,
        sc = "u",
        on_press = function()
            require("leetcode.learn").open("queue")
        end,
    }),
    RoadmapButton("Linked List", {
        icon = "■",
        available = true,
        sc = "l",
        on_press = function()
            require("leetcode.learn").open("linked_list")
        end,
    }),
}))

-- Intermediate
page:insert(section("Intermediate"))
page:insert(Buttons({
    RoadmapButton("Hash Map", {
        icon = "■",
        available = true,
        sc = "h",
        on_press = function()
            require("leetcode.learn").open("hash_map")
        end,
    }),
    RoadmapButton("Tree", {
        icon = "■",
        available = true,
        sc = "t",
        on_press = function()
            require("leetcode.learn").open("tree")
        end,
    }),
    RoadmapButton("Heap", {
        icon = "■",
        available = true,
        sc = "e",
        on_press = function()
            require("leetcode.learn").open("heap")
        end,
    }),
}))

-- Advanced
page:insert(section("Advanced"))
page:insert(Buttons({
    RoadmapButton("Graph", {
        icon = "■",
        available = true,
        sc = "g",
        on_press = function()
            require("leetcode.learn").open("graph")
        end,
    }),
    RoadmapButton("Trie", {
        icon = "■",
        available = true,
        sc = "r",
        on_press = function()
            require("leetcode.learn").open("trie")
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
