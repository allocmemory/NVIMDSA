return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 BACKTRACKING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

Backtracking is a DFS over a decision tree. At each node you make a choice,
recurse, then UNDO the choice before trying the next option.

  make choice → recurse → undo choice (backtrack)

Unlike brute force (generate all then filter), backtracking prunes the search
tree early — it abandons a path as soon as it violates a constraint.


## When to use

→ Generate all combinations, permutations, or subsets
→ Solve constraint satisfaction problems (Sudoku, N-Queens)
→ Word search in a grid

Signal words: "all possible", "generate all", "find all combinations/permutations"


## Template

    function backtrack(state: State, choices: Choice[]): void {
        if (isSolution(state)) {
            results.push(clone(state))   // collect result
            return
        }
        for (const choice of choices) {
            if (isValid(state, choice)) {
                applyChoice(state, choice)          // choose
                backtrack(state, nextChoices(...))   // explore
                undoChoice(state, choice)           // un-choose
            }
        }
    }


## Generate Parentheses example

State: a string built so far.
Choices: add "(" or ")".
Constraints:
  - Can add "(" only if open < n
  - Can add ")" only if close < open (more open than close brackets so far)

    function generate(
        n: number, open: number, close: number, current: string, result: string[]
    ): void {
        if (current.length === 2 * n) {
            result.push(current)
            return
        }
        if (open < n) generate(n, open + 1, close, current + "(", result)
        if (close < open) generate(n, open, close + 1, current + ")", result)
    }

No explicit undo needed here because strings are immutable — a new string is
created at each step. For mutable state (arrays), explicit undo is required.


## Pruning

Pruning avoids exploring paths that cannot lead to a valid solution.

  if (current.length > 2 * n) return  // too long — prune immediately

Good pruning dramatically reduces the number of nodes explored.


## Backtracking vs DP

  DP stores subproblem results — used when the SAME subproblem recurs.
  Backtracking explores the full tree — used when you need ALL solutions.

If you need just one solution (or a count), DP is usually better.
If you need to enumerate all solutions, backtracking is the tool.


## Common mistakes

→ Forgetting to undo state changes before trying the next choice
→ Not cloning the result before pushing (array reference would mutate later)
→ Missing pruning — correct but slow; add constraint checks early in the loop


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Generate Parentheses  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Generate Parentheses

Given n pairs of parentheses, generate all combinations of well-formed parentheses.

Example:
  generateParenthesis(1)  // → ["()"]
  generateParenthesis(2)  // → ["(())", "()()"]
  generateParenthesis(3)  // → ["((()))", "(()())", "(())()", "()(())", "()()()"]

The order within the result does not matter for the tests.

Constraints:
  - 1 <= n <= 8

Hint: track open and close counts. Add "(" when open < n; add ")" when close < open.
No undo needed — strings are immutable, so each recursive call gets a new string.]],

        code = [[function generateParenthesis(n: number): string[] {
    return [];
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function sameSet(a: string[], b: string[]): boolean {
    return JSON.stringify([...a].sort()) === JSON.stringify([...b].sort());
}

function runTests(): void {
    type Result = [string, boolean];
    const results: Result[] = [];

    results.push(["Test 1: n=1", sameSet(generateParenthesis(1), ["()"])]);
    results.push(["Test 2: n=2", sameSet(generateParenthesis(2), ["(())", "()()"])]);
    results.push(["Test 3: n=3", sameSet(generateParenthesis(3),
        ["((()))", "(()())", "(())()", "()(())", "()()()"])]);
    results.push(["Test 4: n=1 length", generateParenthesis(1).length === 1]);
    results.push(["Test 5: n=4 count", generateParenthesis(4).length === 14]);

    let passed = 0;
    const lines: string[] = [];

    for (const [name, ok] of results) {
        if (ok) { lines.push(`✓ ${name}`); passed++; }
        else    { lines.push(`✗ ${name}`); }
    }

    lines.push("");
    lines.push(`[${passed}/${results.length}] passed`);
    console.log(lines.join("\n"));
}

runTests();
]],
    },
}
