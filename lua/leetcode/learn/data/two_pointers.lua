return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TWO POINTERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

Two pointers is a pattern where two indices traverse a data structure — often
from opposite ends, or at different speeds — to reduce an O(n²) brute force to O(n).

The key insight: instead of checking every pair (O(n²)), we exploit a constraint
(sorted order, or some monotonic property) to skip pairs we know won't work.


## When to use

→ Pair / triplet problems on a sorted array
→ Palindrome checks (characters must match at symmetric positions)
→ Removing duplicates in-place
→ Fast & slow pointer for cycle detection in linked lists

Signal words: "sorted", "palindrome", "two numbers that sum to", "in-place"


## Pattern 1: Converging (left & right from ends)

Start l at 0, r at n-1. Move inward based on some condition.

    function isPalindrome(s: string): boolean {
        let l = 0, r = s.length - 1
        while (l < r) {
            if (s[l] !== s[r]) return false
            l++; r--
        }
        return true
    }

The loop terminates in at most n/2 iterations — O(n) time, O(1) space.


## Pattern 2: Same direction (fast & slow)

Both pointers start at the beginning. The fast pointer advances on every step;
the slow pointer advances only when a condition is met.

Used to remove duplicates in-place from a sorted array:

    let slow = 0
    for (let fast = 1; fast < nums.length; fast++) {
        if (nums[fast] !== nums[slow]) {
            slow++
            nums[slow] = nums[fast]
        }
    }
    return slow + 1  // new length


## Pattern 3: Two-sum on a sorted array

    let l = 0, r = nums.length - 1
    while (l < r) {
        const sum = nums[l] + nums[r]
        if (sum === target) return [l, r]
        if (sum < target) l++   // need larger sum, move left pointer right
        else r--                // need smaller sum, move right pointer left
    }

Why this works: if the sum is too small, moving l right increases it (sorted array).
If too large, moving r left decreases it. We never miss the valid pair.


## Common mistakes

→ Forgetting to skip non-alphanumeric characters in palindrome problems
→ Using two pointers on an unsorted array when the sorted property is required
→ Moving both pointers at once instead of only one per iteration


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Valid Palindrome  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Valid Palindrome

A phrase is a palindrome if, after converting all uppercase letters to lowercase
and removing all non-alphanumeric characters, it reads the same forward and backward.

Given a string s, return true if it is a palindrome, false otherwise.

Example:
  isPalindrome("A man, a plan, a canal: Panama")  // → true
  isPalindrome("race a car")                       // → false
  isPalindrome(" ")                                // → true  (empty after filtering)

Constraints:
  - 1 <= s.length <= 2 * 10^5
  - s consists only of printable ASCII characters

Hint: use two pointers from each end, skip non-alphanumeric characters,
compare case-insensitively.]],

        code = [[function isPalindrome(s: string): boolean {
    return false;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: classic",          isPalindrome("A man, a plan, a canal: Panama"), true]);
    results.push(["Test 2: not palindrome",   isPalindrome("race a car"),                     false]);
    results.push(["Test 3: space only",       isPalindrome(" "),                              true]);
    results.push(["Test 4: single char",      isPalindrome("a"),                              true]);
    results.push(["Test 5: simple palindrome",isPalindrome("abcba"),                          true]);
    results.push(["Test 6: even length",      isPalindrome("abba"),                           true]);
    results.push(["Test 7: not palindrome 2", isPalindrome("hello"),                          false]);

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
