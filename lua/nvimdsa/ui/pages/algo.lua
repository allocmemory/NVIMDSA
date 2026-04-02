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
    RoadmapButton("Two Pointers",   { icon = "■", available = false }),
    RoadmapButton("Sliding Window", { icon = "■", available = false }),
    RoadmapButton("Binary Search",  { icon = "■", available = false }),
}))

-- Graph traversal
page:insert(section("Graph"))
page:insert(Buttons({
    RoadmapButton("DFS / BFS", { icon = "■", available = false }),
}))

-- Dynamic & optimization
page:insert(section("Dynamic"))
page:insert(Buttons({
    RoadmapButton("Dynamic Programming", { icon = "■", available = false }),
    RoadmapButton("Backtracking",        { icon = "■", available = false }),
    RoadmapButton("Greedy",              { icon = "■", available = false }),
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
