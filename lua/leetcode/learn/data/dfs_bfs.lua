return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DFS / BFS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What are they?

DFS (Depth-First Search) and BFS (Breadth-First Search) are the two fundamental
strategies for exploring every node in a graph or tree.

Both visit all reachable nodes: O(V + E) time, O(V) space.

The only difference is the data structure used to track the frontier:
  DFS → stack   (call stack via recursion, or explicit stack)
  BFS → queue   (always iterative)


## DFS — go deep first

DFS dives as far as possible along one branch before backtracking.

Recursive (implicit stack):

    function dfs(node: Node, visited: Set<number>): void {
        visited.add(node.id)
        for (const neighbour of node.neighbours) {
            if (!visited.has(neighbour.id)) {
                dfs(neighbour, visited)
            }
        }
    }

Iterative (explicit stack):

    const stack = [start]
    const visited = new Set<number>()
    while (stack.length) {
        const node = stack.pop()!
        if (visited.has(node.id)) continue
        visited.add(node.id)
        for (const n of node.neighbours) stack.push(n)
    }

On a grid, neighbours = up / down / left / right.


## BFS — go wide first

BFS explores all nodes at distance d before any node at distance d+1.
This guarantees the SHORTEST PATH in an unweighted graph.

    const queue = [start]
    const visited = new Set<number>([start.id])
    let steps = 0

    while (queue.length) {
        const size = queue.length       // process one level at a time
        for (let i = 0; i < size; i++) {
            const node = queue.shift()!
            if (node === target) return steps
            for (const n of node.neighbours) {
                if (!visited.has(n.id)) {
                    visited.add(n.id)
                    queue.push(n)
                }
            }
        }
        steps++
    }


## When to prefer each

  DFS  → connectivity, cycle detection, topological sort, tree traversal,
          flood-fill, backtracking (undoes state on return)

  BFS  → shortest path in unweighted graph, level-by-level processing,
          finding nearest neighbour


## DFS on a grid

4-directional neighbours:

    const dirs = [[1,0],[-1,0],[0,1],[0,-1]]

    function dfs(grid: number[][], r: number, c: number): void {
        const rows = grid.length, cols = grid[0].length
        if (r < 0 || r >= rows || c < 0 || c >= cols) return
        if (grid[r][c] === 0) return          // water or visited
        grid[r][c] = 0                         // mark visited
        for (const [dr, dc] of dirs) dfs(grid, r+dr, c+dc)
    }


## Common mistakes

→ Not marking nodes as visited BEFORE pushing to the queue in BFS — leads to
  visiting the same node multiple times (or infinite loops on cyclic graphs)
→ Using DFS and expecting shortest-path semantics — only BFS guarantees that
→ Forgetting bounds checks on grid problems


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Max Area of Island  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Max Area of Island

You are given an m x n binary matrix grid. 0 represents water, 1 represents land.

An island is a group of 1s connected 4-directionally (up, down, left, right).

Return the maximum area of an island in the grid. If there are no islands, return 0.

Example:
  grid = [
    [0,0,1,0,0,0,0,1,0,0,0,0,0],
    [0,0,0,0,0,0,0,1,1,1,0,0,0],
    [0,1,1,0,1,0,0,0,0,0,0,0,0],
    [0,1,0,0,1,1,0,0,1,0,1,0,0],
    [0,1,0,0,1,1,0,0,1,1,1,0,0],
    [0,0,0,0,0,0,0,0,0,0,1,0,0],
    [0,0,0,0,0,0,0,1,1,1,0,0,0],
    [0,0,0,0,0,0,0,1,1,0,0,0,0],
  ]
  → 6

Constraints:
  - 1 <= m, n <= 50
  - grid[i][j] is 0 or 1

Hint: DFS from each unvisited land cell. Return the cell count; track the global max.]],

        code = [[function maxAreaOfIsland(grid: number[][]): number {
    return 0;
}
]],

        tests = [=[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: example", maxAreaOfIsland([
        [0,0,1,0,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,0,1,1,1,0,0,0],
        [0,1,1,0,1,0,0,0,0,0,0,0,0],
        [0,1,0,0,1,1,0,0,1,0,1,0,0],
        [0,1,0,0,1,1,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,0,0,0,1,0,0],
        [0,0,0,0,0,0,0,1,1,1,0,0,0],
        [0,0,0,0,0,0,0,1,1,0,0,0,0],
    ]), 6]);

    results.push(["Test 2: all water",      maxAreaOfIsland([[0,0,0],[0,0,0]]),           0]);
    results.push(["Test 3: all land",       maxAreaOfIsland([[1,1],[1,1]]),                4]);
    results.push(["Test 4: single cell",    maxAreaOfIsland([[1]]),                        1]);
    results.push(["Test 5: two islands",    maxAreaOfIsland([[1,0,1],[0,0,0],[1,0,1]]),   1]);

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
]=],
    },
}
