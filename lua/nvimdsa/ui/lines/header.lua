local Lines = require("leetcode-ui.lines")

---@class nvimdsa.ui.Header : lc.ui.Lines
local Header = Lines:extend("NvimDSAHeader")

local ascii = {
    [[  _   ___      _____ __  __ ____  ____    _    ]],
    [[ | \ | \ \    / /_ _|  \/  |  _ \/ ___|  / \   ]],
    [[ |  \| |\ \  / / | || |\/| | | | \___ \ / _ \  ]],
    [[ | |\  | \ \/ /  | || |  | | |_| |___) / ___ \ ]],
    [[ |_| \_|  \__/  |___|_|  |_|____/|____/_/   \_\]],
}

function Header:init()
    Header.super.init(self, {}, {
        hl = "Keyword",
    })

    for _, line in ipairs(ascii) do
        self:append(line):endl()
    end
end

---@type fun(): nvimdsa.ui.Header
local NvimDSAHeader = Header

return NvimDSAHeader()
