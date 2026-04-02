-- Module registry for :Leet learn <module>.
-- Each entry maps a module name to the path of its data file.
-- learn/init.lua loads them individually via pcall(require, "leetcode.learn.data." .. name).

return {
    "complexity",
    "stack",
}
