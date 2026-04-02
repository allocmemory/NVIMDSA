return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 BINARY SEARCH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

Binary search finds a target in a sorted array by repeatedly halving the search
space. At each step it compares the target to the middle element and discards
the half that cannot contain the target.

  O(log n) time   O(1) space

A linear scan through n = 10^9 elements would take a billion comparisons.
Binary search takes at most 30.


## Prerequisite: sorted order (or a monotonic condition)

Binary search only works when you can definitively say "the answer is to the
left of this point" or "to the right". This requires the array to be sorted,
or the problem to have some monotonic property.


## Standard template

    let lo = 0, hi = nums.length - 1

    while (lo <= hi) {
        const mid = lo + Math.floor((hi - lo) / 2)  // avoids integer overflow
        if (nums[mid] === target) return mid          // found
        if (nums[mid] < target) lo = mid + 1         // target is to the right
        else hi = mid - 1                            // target is to the left
    }
    return -1  // not found

Loop invariant: if target exists, it is within [lo, hi].
When lo > hi the search space is empty — target is absent.


## Finding the insertion point

When target is not found, lo is the index where it would be inserted to keep
the array sorted. This is the "lower bound" pattern.

    // After the loop above:
    return lo  // insertion index (also: first index >= target)


## Off-by-one guide

  lo = 0, hi = n - 1, condition lo <= hi
  → Search space includes both ends. Loop exits when lo > hi.

  lo = 0, hi = n (open right end), condition lo < hi
  → Used for "find leftmost position" variants (left bisect).

Stick to one template consistently to avoid bugs.


## Binary search on the answer space

Many problems that don't look like binary search can be solved by searching over
the answer directly. If a predicate f(x) is monotonic (false...false, true...true),
binary search finds the boundary.

Example: "what is the minimum capacity k such that we can ship all packages in D days?"

    lo = max(weights), hi = sum(weights)
    while (lo < hi) {
        const mid = Math.floor((lo + hi) / 2)
        if (canShip(mid, D)) hi = mid   // feasible — try smaller
        else lo = mid + 1               // not feasible — need larger
    }
    return lo


## Common mistakes

→ Using mid = (lo + hi) / 2 — overflows for large integers in some languages
→ Infinite loop: forgetting to advance lo or hi (hi = mid instead of mid - 1)
→ Applying binary search to an unsorted array


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Search Insert Position  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Search Insert Position

Given a sorted array of distinct integers and a target value, return the index
if the target is found. If not, return the index where it would be inserted to
keep the array sorted.

You must achieve O(log n) runtime.

Example:
  searchInsert([1, 3, 5, 6], 5)  // → 2  (found at index 2)
  searchInsert([1, 3, 5, 6], 2)  // → 1  (insert between 1 and 3)
  searchInsert([1, 3, 5, 6], 7)  // → 4  (insert at end)
  searchInsert([1, 3, 5, 6], 0)  // → 0  (insert at start)

Constraints:
  - 1 <= nums.length <= 10^4
  - -10^4 <= nums[i] <= 10^4
  - nums has distinct values sorted in ascending order
  - -10^4 <= target <= 10^4

Hint: standard binary search — when target is not found, lo is the insertion index.]],

        code = [[function searchInsert(nums: number[], target: number): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: found",          searchInsert([1,3,5,6], 5), 2]);
    results.push(["Test 2: insert middle",  searchInsert([1,3,5,6], 2), 1]);
    results.push(["Test 3: insert at end",  searchInsert([1,3,5,6], 7), 4]);
    results.push(["Test 4: insert at start",searchInsert([1,3,5,6], 0), 0]);
    results.push(["Test 5: single match",   searchInsert([1], 1),       0]);
    results.push(["Test 6: single no match",searchInsert([1], 2),       1]);

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
