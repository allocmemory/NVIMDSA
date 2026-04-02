return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GREEDY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A greedy algorithm makes the locally optimal choice at each step, hoping (and
proving) that a sequence of local optima leads to a globally optimal solution.

It never reconsiders past choices — no backtracking, no DP table.

When it works, greedy is usually simpler and faster than DP.
The challenge is proving it works for a given problem.


## When does greedy work?

A greedy algorithm is correct when the problem has the "greedy choice property":
a locally optimal choice is always part of some globally optimal solution.

This is often proved by an "exchange argument":
  Suppose an optimal solution doesn't include our greedy choice.
  Show we can swap it in without making things worse.
  Therefore our greedy choice is safe.


## When to try greedy

→ "Can you reach the end?" — track reachable range
→ Interval scheduling — sort by end time, pick non-overlapping intervals
→ Coin change with certain denominations — pick largest coin that fits
→ Minimise maximum / maximise minimum — often greedy after sorting

Signal: "minimum number of", "maximum possible", problem reduces to a single scan


## Jump Game example

    // nums[i] = max jump from index i
    // Can you reach the last index?

    let maxReach = 0
    for (let i = 0; i < nums.length; i++) {
        if (i > maxReach) return false         // can't reach index i
        maxReach = Math.max(maxReach, i + nums[i])
    }
    return true

Greedy choice: at each index, update the furthest reachable position.
If the current index is already beyond reach, we're stuck.

Why greedy works here: we never need to revisit earlier positions. Moving
maxReach forward is always at least as good as not moving it.


## Greedy vs DP

  DP: considers all subproblems; correct for "how many ways" or "minimum cost"
      when choices interact across positions.

  Greedy: makes one irreversible choice per step; correct only when local = global
          optimal. Much faster when applicable.

Example where greedy FAILS: coin change with denominations [1, 3, 4], target 6.
  Greedy picks 4, then 1+1 = 3 coins.
  Optimal is 3+3 = 2 coins.
  Use DP instead.


## Sorting as a greedy pre-step

Many greedy algorithms start by sorting:
  - Activity selection: sort by end time
  - Interval merging: sort by start time
  - Huffman encoding: sort by frequency

Sorting gives the structure needed to make correct greedy choices.


## Common mistakes

→ Applying greedy without verifying the greedy choice property — can give wrong answers
→ Forgetting to handle the edge case where no solution exists
→ Using greedy for coin change with arbitrary denominations (use DP)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Jump Game  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Jump Game

You are given an integer array nums where nums[i] represents the maximum jump
length from index i.

Return true if you can reach the last index, starting from index 0.

Example:
  canJump([2, 3, 1, 1, 4])  // → true  (0→1→4 or 0→2→3→4)
  canJump([3, 2, 1, 0, 4])  // → false (always land on index 3 which has jump 0)

Constraints:
  - 1 <= nums.length <= 10^4
  - 0 <= nums[i] <= 10^5

Hint: track the maximum index reachable so far. If at any point your current
index exceeds the maximum reachable, return false.]],

        code = [[function canJump(nums: number[]): boolean {
    return false;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: reachable",   canJump([2,3,1,1,4]),   true]);
    results.push(["Test 2: blocked",     canJump([3,2,1,0,4]),   false]);
    results.push(["Test 3: single",      canJump([0]),           true]);
    results.push(["Test 4: two reachable",canJump([1,0]),        true]);
    results.push(["Test 5: two blocked", canJump([0,1]),         false]);
    results.push(["Test 6: all zeros",   canJump([0,0,0]),       false]);

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
