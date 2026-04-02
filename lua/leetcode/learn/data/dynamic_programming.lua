return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DYNAMIC PROGRAMMING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

Dynamic programming (DP) solves problems by breaking them into overlapping
subproblems, solving each subproblem once, and storing the result so it is
never recomputed.

Two necessary conditions:
  1. Optimal substructure — the optimal solution contains optimal solutions
     to its subproblems.
  2. Overlapping subproblems — naive recursion solves the same subproblem
     many times.

If condition 2 is missing (subproblems are independent), use divide & conquer
instead (merge sort, binary search).


## Two approaches

### Top-down (Memoisation)

Start with recursion. Cache results so each subproblem is solved once.

    const memo = new Map<number, number>()

    function fib(n: number): number {
        if (n <= 1) return n
        if (memo.has(n)) return memo.get(n)!
        const result = fib(n - 1) + fib(n - 2)
        memo.set(n, result)
        return result
    }

Time: O(n)   Space: O(n)  (call stack + memo)


### Bottom-up (Tabulation)

Start from the base cases, fill a table iteratively.

    const dp = new Array(n + 1).fill(0)
    dp[0] = 0; dp[1] = 1

    for (let i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2]
    }
    return dp[n]

Time: O(n)   Space: O(n)  (reducible to O(1) by keeping only last 2 values)


## The DP thought process

Step 1: Define the state.
  dp[i] = "what does this cell mean?"
  For climbing stairs: dp[i] = number of ways to reach step i.

Step 2: Find the recurrence (transition).
  dp[i] = dp[i-1] + dp[i-2]
  You can reach step i from step i-1 (one step) or step i-2 (two steps).

Step 3: Identify base cases.
  dp[0] = 1 (one way to be at the start — do nothing)
  dp[1] = 1 (one way to reach step 1)

Step 4: Determine iteration order.
  Fill the table in the order that ensures dependencies are computed first.


## Recognising DP problems

→ "How many ways to..."
→ "Maximum/minimum cost/profit to..."
→ "Can you reach..." with choices at each step
→ Subproblems defined by a prefix or suffix of the input


## Common mistakes

→ Not defining the state clearly — a vague state leads to a wrong recurrence
→ Wrong base cases — off-by-one errors are extremely common
→ Space: O(n) table is fine, but many 1D DP can be reduced to O(1)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Climbing Stairs  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Climbing Stairs

You are climbing a staircase with n steps. Each time you can climb 1 or 2 steps.
Return the number of distinct ways to reach the top.

Example:
  climbStairs(1)  // → 1   (1)
  climbStairs(2)  // → 2   (1+1, 2)
  climbStairs(3)  // → 3   (1+1+1, 1+2, 2+1)
  climbStairs(4)  // → 5
  climbStairs(5)  // → 8

Constraints:
  - 1 <= n <= 45

Hint: the number of ways to reach step n equals the sum of ways to reach
step n-1 (then take 1 step) and step n-2 (then take 2 steps). This is Fibonacci.]],

        code = [[function climbStairs(n: number): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: n=1",  climbStairs(1),  1]);
    results.push(["Test 2: n=2",  climbStairs(2),  2]);
    results.push(["Test 3: n=3",  climbStairs(3),  3]);
    results.push(["Test 4: n=4",  climbStairs(4),  5]);
    results.push(["Test 5: n=5",  climbStairs(5),  8]);
    results.push(["Test 6: n=10", climbStairs(10), 89]);

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
