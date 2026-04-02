return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ARRAY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

An array stores elements in contiguous memory, indexed from 0. It is the most
fundamental data structure — most others are built on top of it.

Two flavours:
  Static array  — fixed size, allocated once (C-style)
  Dynamic array — resizes automatically (JS/TS Array, Python list, Java ArrayList)


## Core operations

  Access     arr[i]          O(1)  — direct offset calculation
  Search     linear scan     O(n)  — worst case checks every element
  Insert     at end          O(1)  amortised (dynamic arrays double capacity)
             at index i      O(n)  — must shift elements right
  Delete     at index i      O(n)  — must shift elements left


## When to use

→ You need O(1) random access by index
→ You iterate over elements in order
→ Memory locality matters (arrays are cache-friendly)

Avoid when you need frequent insert/delete in the middle — use a Linked List.


## Key patterns

### 1. Single-pass with a running variable

Track a minimum, maximum, or sum as you scan once. Eliminates the need for
a second loop.

    let min = prices[0]
    let maxProfit = 0

    for (const price of prices) {
        maxProfit = Math.max(maxProfit, price - min)
        min = Math.min(min, price)
    }

Time: O(n)   Space: O(1)

### 2. Two-pointer (same array)

Use indices i and j (start and end) moving toward each other. Useful for
palindrome checks, pair sums in sorted arrays, and partitioning.

    let l = 0, r = arr.length - 1
    while (l < r) {
        // compare arr[l] and arr[r], then advance
        l++; r--
    }

### 3. Prefix sum

Precompute cumulative sums so any range sum [i, j] becomes O(1).

    const prefix = [0]
    for (const x of arr) prefix.push(prefix.at(-1)! + x)
    const rangeSum = prefix[j + 1] - prefix[i]  // sum of arr[i..j]


## Common mistakes

→ Off-by-one: for (let i = 0; i <= arr.length; i++) — will index out of bounds
→ Mutating an array while iterating over it — use a copy or iterate backwards
→ Forgetting to handle the empty array (length 0) as a special case


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Best Time to Buy and Sell Stock  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Best Time to Buy and Sell Stock

You are given an array prices where prices[i] is the price of a stock on day i.

You want to maximise your profit by choosing a single day to buy and a single
day to sell AFTER the buy day.

Return the maximum profit. If no profit is possible, return 0.

Example:
  maxProfit([7, 1, 5, 3, 6, 4])  // → 5  (buy on day 1, sell on day 4)
  maxProfit([7, 6, 4, 3, 1])     // → 0  (prices only fall)
  maxProfit([1])                  // → 0

Constraints:
  - 1 <= prices.length <= 10^5
  - 0 <= prices[i] <= 10^4

Hint: a single pass tracking the running minimum is all you need.]],

        code = [[function maxProfit(prices: number[]): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    // Test 1: standard case
    results.push(["Test 1: standard", maxProfit([7, 1, 5, 3, 6, 4]), 5]);

    // Test 2: always decreasing — no profit possible
    results.push(["Test 2: no profit", maxProfit([7, 6, 4, 3, 1]), 0]);

    // Test 3: single element
    results.push(["Test 3: single element", maxProfit([1]), 0]);

    // Test 4: two elements, profit exists
    results.push(["Test 4: two elements up", maxProfit([1, 5]), 4]);

    // Test 5: buy at start, sell at end
    results.push(["Test 5: buy low sell high", maxProfit([1, 2, 3, 4, 5]), 4]);

    // Test 6: peak in middle
    results.push(["Test 6: peak in middle", maxProfit([3, 1, 4]), 3]);

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
