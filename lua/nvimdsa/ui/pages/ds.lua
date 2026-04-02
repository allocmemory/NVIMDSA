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
    RoadmapButton("Array",       { icon = "■", available = false }),
    RoadmapButton("Queue",       { icon = "■", available = false }),
    RoadmapButton("Linked List", { icon = "■", available = false }),
}))

-- Intermediate
page:insert(section("Intermediate"))
page:insert(Buttons({
    RoadmapButton("Hash Map", { icon = "■", available = false }),
    RoadmapButton("Tree",     { icon = "■", available = false }),
    RoadmapButton("Heap",     { icon = "■", available = false }),
}))

-- Advanced
page:insert(section("Advanced"))
page:insert(Buttons({
    RoadmapButton("Graph", { icon = "■", available = false }),
    RoadmapButton("Trie",  { icon = "■", available = false }),
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
