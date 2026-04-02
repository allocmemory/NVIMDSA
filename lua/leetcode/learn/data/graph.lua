return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GRAPH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A graph is a set of nodes (vertices) connected by edges. Unlike trees, graphs
can have cycles and nodes can have any number of connections.

  Undirected — edges have no direction (friendship)
  Directed   — edges point one way (follower, dependency)
  Weighted   — edges have a cost (road distance)
  Unweighted — all edges are equal


## Representations

### Adjacency list (most common for sparse graphs)

    const graph: Map<number, number[]> = new Map()
    graph.set(0, [1, 2])
    graph.set(1, [0, 3])
    // node 0 connects to 1 and 2; node 1 connects to 0 and 3

Space: O(V + E)   Lookup neighbours: O(degree)

### Adjacency matrix

    const mat: number[][] = Array.from({length: V}, () => new Array(V).fill(0))
    mat[0][1] = 1   // edge from 0 to 1

Space: O(V²)   Lookup edge: O(1)  — prefer for dense graphs or when edge queries dominate

### Implicit graph (grid)

Many problems encode a graph as a 2D grid. Node = cell (r, c).
Neighbours = up/down/left/right. No explicit adjacency list needed.


## Traversal: DFS vs BFS

Both visit all reachable nodes: O(V + E) time, O(V) space.

  DFS  — go as deep as possible, backtrack. Uses a stack (or recursion).
         Good for: connectivity, cycle detection, topological sort, flood-fill.

  BFS  — visit all neighbours before going deeper. Uses a queue.
         Good for: shortest path in unweighted graph, level-order problems.


## DFS on a grid (flood-fill)

    function dfs(grid: string[][], r: number, c: number): void {
        const rows = grid.length, cols = grid[0].length
        if (r < 0 || r >= rows || c < 0 || c >= cols) return   // out of bounds
        if (grid[r][c] !== "1") return                           // not land / visited

        grid[r][c] = "0"   // mark visited by mutating (restore after if needed)

        dfs(grid, r + 1, c)
        dfs(grid, r - 1, c)
        dfs(grid, r, c + 1)
        dfs(grid, r, c - 1)
    }

Marking visited cells prevents infinite loops on cyclic paths.


## Counting connected components

    let count = 0
    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            if (grid[r][c] === "1") {
                dfs(grid, r, c)   // sinks the entire island
                count++
            }
        }
    }


## Common mistakes

→ Forgetting to mark nodes as visited before (not after) recursing — causes cycles
→ Using BFS when you need shortest path but forgetting to stop early at the target
→ Assuming a grid problem is not a graph — it almost always is


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Number of Islands  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Number of Islands

Given an m x n grid of "1" (land) and "0" (water), count the number of islands.

An island is surrounded by water and is formed by connecting adjacent land cells
horizontally or vertically. You may assume the grid borders are surrounded by water.

Example:
  grid = [
    ["1","1","1","1","0"],
    ["1","1","0","1","0"],
    ["1","1","0","0","0"],
    ["0","0","0","0","0"],
  ]
  → 1

  grid = [
    ["1","1","0","0","0"],
    ["1","1","0","0","0"],
    ["0","0","1","0","0"],
    ["0","0","0","1","1"],
  ]
  → 3

Constraints:
  - 1 <= m, n <= 300
  - grid[i][j] is "0" or "1"

Hint: for each unvisited "1" cell, run DFS to sink the entire island, then increment count.]],

        code = [[function numIslands(grid: string[][]): number {
    return 0;
}
]],

        tests = [=[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: 1 island", numIslands([
        ["1","1","1","1","0"],
        ["1","1","0","1","0"],
        ["1","1","0","0","0"],
        ["0","0","0","0","0"],
    ]), 1]);

    results.push(["Test 2: 3 islands", numIslands([
        ["1","1","0","0","0"],
        ["1","1","0","0","0"],
        ["0","0","1","0","0"],
        ["0","0","0","1","1"],
    ]), 3]);

    results.push(["Test 3: all water", numIslands([["0","0"],["0","0"]]), 0]);

    results.push(["Test 4: all land",  numIslands([["1","1"],["1","1"]]), 1]);

    results.push(["Test 5: checkerboard", numIslands([
        ["1","0","1"],
        ["0","1","0"],
        ["1","0","1"],
    ]), 5]);

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
