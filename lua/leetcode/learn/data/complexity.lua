return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 COMPLEXITY ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

Big O notation describes how the runtime or memory usage of an algorithm SCALES
as the input size grows. It answers: "if the input doubles, what happens to the
cost?"

We always analyse the WORST CASE unless told otherwise. We also drop constants
and lower-order terms — O(2n + 5) is written O(n) because the shape of growth
is what matters, not the exact multiplier.


## Common complexities (fast → slow)

  O(1)        Constant    — does not depend on input size
                            array index lookup, hash map get/set

  O(log n)    Logarithmic — input is halved on each step
                            binary search, balanced BST operations

  O(n)        Linear      — one pass through the input
                            linear search, counting elements

  O(n log n)  Linearithmic — n passes, each O(log n)
                            merge sort, heap sort, most good sorting algorithms

  O(n²)       Quadratic   — nested loops over the same input
                            bubble sort, brute-force pair search

  O(2ⁿ)       Exponential — all subsets / recursive without memoisation
                            naive Fibonacci, power-set generation

  O(n!)       Factorial   — all permutations
                            brute-force TSP, permutation generation


## How to read code and find complexity

Step 1: identify what "n" is (array length? number of nodes? string length?).

Step 2: count loops.

    for i in range(n):          # O(n)
        for j in range(n):      # O(n) inside → O(n²) total
            pass

Step 3: recognise "halving" patterns.

    lo, hi = 0, n - 1
    while lo <= hi:             # halves each iteration → O(log n)
        mid = (lo + hi) // 2
        ...

Step 4: add sequential blocks, multiply nested blocks.

    for x in arr:   pass        # O(n)
    for y in arr:   pass        # O(n)  → total O(n) + O(n) = O(n)  (drop constant)

    for x in arr:               # O(n)
        for y in arr:   pass    #   × O(n) → O(n²)


## Time vs Space tradeoff

Many problems let you trade one for the other.

Example: "does the array contain a duplicate?"

  Brute force (O(n²) time, O(1) space):
    Compare every pair → two nested loops.

  Hash set (O(n) time, O(n) space):
    Store each element in a set; if you see it again, it's a duplicate.

The hash-set approach is faster but uses extra memory. Knowing complexity lets
you make this tradeoff consciously.


## Key rules

  → Ignore constants:      O(3n) → O(n)
  → Drop lower terms:      O(n² + n) → O(n²)
  → Sequential = add:      O(n) + O(n) → O(n)
  → Nested = multiply:     O(n) × O(n) → O(n²)
  → log n usually means:   something is being halved each step


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Contains Duplicate  →  press <C-l> to switch to the code panel, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Contains Duplicate

Given an integer array nums, return true if any value appears
more than once, false if all elements are distinct.

Implement it in O(n) time and O(n) space.

Example:
  hasDuplicate([1, 2, 3, 1])   // → true
  hasDuplicate([1, 2, 3, 4])   // → false
  hasDuplicate([1, 1, 1, 3, 3, 4, 3, 2, 4, 2])  // → true

Constraints:
  - 1 <= nums.length <= 10^5
  - -10^9 <= nums[i] <= 10^9

Hint: a Set lets you check membership in O(1).]],

        code = [[function hasDuplicate(nums: number[]): boolean {
    return false;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    // Test 1: duplicate present
    results.push(["Test 1: has duplicate", hasDuplicate([1, 2, 3, 1]), true]);

    // Test 2: all distinct
    results.push(["Test 2: all distinct", hasDuplicate([1, 2, 3, 4]), false]);

    // Test 3: multiple duplicates
    results.push(["Test 3: multiple duplicates", hasDuplicate([1, 1, 1, 3, 3, 4, 3, 2, 4, 2]), true]);

    // Test 4: single element (no duplicate possible)
    results.push(["Test 4: single element", hasDuplicate([99]), false]);

    // Test 5: two identical elements
    results.push(["Test 5: two identical", hasDuplicate([7, 7]), true]);

    // Test 6: two distinct elements
    results.push(["Test 6: two distinct", hasDuplicate([7, 8]), false]);

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
