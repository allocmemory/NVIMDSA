return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SLIDING WINDOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A sliding window maintains a contiguous subarray (or substring) and slides it
across the input by expanding the right edge and shrinking the left edge.

It avoids recomputing from scratch on every step — instead it updates
incrementally, giving O(n) time instead of O(n²) or O(n·k).


## When to use

→ Longest/shortest subarray or substring satisfying a condition
→ Maximum/minimum sum of a subarray of fixed size k
→ Any problem asking about a contiguous range

Signal words: "subarray", "substring", "window", "contiguous", "longest", "shortest"


## Pattern 1: Fixed-size window

Window always has exactly k elements.

    let sum = 0
    for (let i = 0; i < k; i++) sum += nums[i]   // initial window

    let max = sum
    for (let i = k; i < nums.length; i++) {
        sum += nums[i] - nums[i - k]              // slide: add right, remove left
        max = Math.max(max, sum)
    }
    return max

O(n) time, O(1) space.


## Pattern 2: Variable-size window (expand/shrink)

Expand the right pointer; when the window becomes invalid, shrink from the left.

    let l = 0
    const seen = new Set<string>()
    let maxLen = 0

    for (let r = 0; r < s.length; r++) {
        while (seen.has(s[r])) {
            seen.delete(s[l])  // shrink from left until window is valid again
            l++
        }
        seen.add(s[r])
        maxLen = Math.max(maxLen, r - l + 1)
    }
    return maxLen

The right pointer advances n times and the left pointer advances at most n times —
O(n) amortised.


## Why not brute force?

Brute force for "longest substring without repeating characters":
  For every pair (i, j) check if the substring is valid → O(n²) or O(n³).

Sliding window:
  Each character is added once (right++) and removed at most once (left++) → O(n).


## Window size formula

Current window = s[l..r] (inclusive)
  Length: r - l + 1
  When to shrink: when the window violates the constraint (e.g., duplicate found)


## Common mistakes

→ Using l++ when the inner while loop is necessary — use while, not if, when
  there could be multiple invalid characters to remove
→ Off-by-one: window length is r - l + 1, not r - l
→ Not resetting the window state (e.g., Set) properly when shrinking


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Longest Substring Without Repeating Characters  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Longest Substring Without Repeating Characters

Given a string s, return the length of the longest substring that contains
no repeating characters.

Example:
  lengthOfLongestSubstring("abcabcbb")  // → 3  ("abc")
  lengthOfLongestSubstring("bbbbb")     // → 1  ("b")
  lengthOfLongestSubstring("pwwkew")    // → 3  ("wke")
  lengthOfLongestSubstring("")          // → 0

Constraints:
  - 0 <= s.length <= 5 * 10^4
  - s consists of English letters, digits, symbols and spaces

Hint: variable-size sliding window. Use a Set to track characters in the current window.
Shrink from the left whenever a duplicate is about to enter the window.]],

        code = [[function lengthOfLongestSubstring(s: string): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: abcabcbb",  lengthOfLongestSubstring("abcabcbb"), 3]);
    results.push(["Test 2: bbbbb",     lengthOfLongestSubstring("bbbbb"),    1]);
    results.push(["Test 3: pwwkew",    lengthOfLongestSubstring("pwwkew"),   3]);
    results.push(["Test 4: empty",     lengthOfLongestSubstring(""),         0]);
    results.push(["Test 5: all unique",lengthOfLongestSubstring("abcdef"),   6]);
    results.push(["Test 6: single",    lengthOfLongestSubstring("a"),        1]);

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
