-- Module registry for :Leet learn <module>.
-- Each entry maps a module name to the path of its data file.
-- learn/init.lua loads them individually via pcall(require, "leetcode.learn.data." .. name).

return {
    "complexity",
    "stack",
    "array",
    "queue",
    "linked_list",
    "hash_map",
    "tree",
    "heap",
    "graph",
    "trie",
    "two_pointers",
    "sliding_window",
    "binary_search",
    "dfs_bfs",
    "dynamic_programming",
    "backtracking",
    "greedy",
}
