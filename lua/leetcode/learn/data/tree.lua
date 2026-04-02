return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TREE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A tree is a hierarchical data structure of nodes connected by edges, with no cycles.
Each node has zero or more children; there is exactly one root.

A binary tree limits each node to at most two children: left and right.

          4
         / \
        2   7
       / \ / \
      1  3 6  9

Terminology:
  Root    — top node (no parent)
  Leaf    — node with no children
  Height  — longest path from root to a leaf (tree above: height = 2)
  Depth   — distance from root to a node


## Core traversals

All traversals visit every node: O(n) time, O(h) space (call stack), where h
is the height (O(log n) balanced, O(n) worst-case skewed).

  Inorder   (left, root, right)  → sorted output for BSTs
  Preorder  (root, left, right)  → copy a tree, serialise
  Postorder (left, right, root)  → delete a tree, evaluate expressions
  BFS       (level by level)     → shortest path, level sums

### Recursive DFS template

Every recursive tree problem follows this skeleton:

    function solve(node: TreeNode | null): ReturnType {
        if (!node) return BASE_CASE          // null check first
        const left  = solve(node.left)
        const right = solve(node.right)
        return COMBINE(left, right, node.val)
    }

For max depth:
    if (!node) return 0
    return 1 + Math.max(solve(node.left), solve(node.right))


## Binary Search Tree (BST)

A BST adds the invariant: left subtree < node < right subtree.
This makes search, insert, and delete O(log n) on a balanced tree.

    function search(node: TreeNode | null, val: number): boolean {
        if (!node) return false
        if (val === node.val) return true
        return val < node.val ? search(node.left, val) : search(node.right, val)
    }


## BFS with a queue

BFS is iterative (use an explicit queue, not the call stack):

    const queue: TreeNode[] = [root]

    while (queue.length) {
        const node = queue.shift()!
        // process node
        if (node.left)  queue.push(node.left)
        if (node.right) queue.push(node.right)
    }

Process all nodes at depth d before any node at depth d+1.


## Common mistakes

→ Forgetting the null base case — always handle null/undefined first
→ Mixing up traversal orders (preorder visits root BEFORE children)
→ Using BFS (queue) when DFS (recursion) is simpler, or vice versa
→ Assuming the tree is balanced — a skewed tree has O(n) height


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Maximum Depth of Binary Tree  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Maximum Depth of Binary Tree

Given the root of a binary tree, return its maximum depth.

The maximum depth is the number of nodes along the longest path from the root
down to the farthest leaf node.

Example:
          3          → depth 3
         / \
        9  20
          /  \
         15   7

  maxDepth(root)  // → 3
  maxDepth(null)  // → 0
  maxDepth(single node)  // → 1

Constraints:
  - 0 <= number of nodes <= 10^4
  - -100 <= node.val <= 100

Hint: 1 + max(depth of left subtree, depth of right subtree).]],

        code = [[class TreeNode {
    val: number;
    left: TreeNode | null;
    right: TreeNode | null;
    constructor(val: number, left: TreeNode | null = null, right: TreeNode | null = null) {
        this.val = val; this.left = left; this.right = right;
    }
}

function maxDepth(root: TreeNode | null): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function build(vals: (number | null)[]): TreeNode | null {
    if (!vals.length || vals[0] === null) return null;
    const root = new TreeNode(vals[0]!);
    const queue: (TreeNode | null)[] = [root];
    let i = 1;
    while (i < vals.length) {
        const node = queue.shift()!;
        if (vals[i] !== null) { node.left = new TreeNode(vals[i]!); queue.push(node.left); }
        i++;
        if (i < vals.length && vals[i] !== null) { node.right = new TreeNode(vals[i]!); queue.push(node.right); }
        i++;
    }
    return root;
}

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: depth 3",    maxDepth(build([3,9,20,null,null,15,7])), 3]);
    results.push(["Test 2: depth 2",    maxDepth(build([1,null,2])),              2]);
    results.push(["Test 3: null root",  maxDepth(null),                           0]);
    results.push(["Test 4: single",     maxDepth(build([1])),                     1]);
    results.push(["Test 5: skewed (4)", maxDepth(build([1,2,null,3,null,4])),     4]);

    let passed = 0;
    const lines: string[] = [];

    for (const [name, got, expected] of results) {
        if (JSON.stringify(got) === JSON.stringify(expected)) {
            lines.push(`✓ ${name}`);
            passed++;
        } else {
            lines.push(`✗ ${name}`);
            lines.push(`  expected: ${JSON.stringify(expected)}`);
            lines.push(`  got:      ${JSON.stringify(got)}`);
        }
    }

    lines.push("");
    lines.push(`[${passed}/${results.length}] passed`);
    console.log(lines.join("\n"));
}

runTests();
]],
    },
}
