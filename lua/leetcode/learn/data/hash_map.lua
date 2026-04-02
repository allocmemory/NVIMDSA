return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 HASH MAP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A hash map (also called hash table or dictionary) stores key-value pairs and
provides O(1) average-case lookup, insert, and delete.

Internally, a hash function converts the key into an array index. Collisions
(two keys mapping to the same index) are resolved by chaining or open addressing.

In TypeScript:
  const map = new Map<string, number>()
  map.set("a", 1)       // insert / update
  map.get("a")          // → 1
  map.has("b")          // → false
  map.delete("a")       // remove
  map.size              // number of entries


## Core operations (average case)

  Get     O(1)
  Set     O(1)
  Delete  O(1)
  Has     O(1)

Worst case is O(n) when every key collides, but this is extremely rare with a
good hash function and is not tested in interviews.


## When to use

→ Counting frequencies: map each element to its count
→ Two-pass pair problems: first pass builds a map, second pass queries it
→ Grouping: map a key to a list of associated values
→ Memoisation: map inputs to previously computed outputs


## Key pattern: complement lookup (Two Sum)

Instead of a nested loop (O(n²)), scan once and check if the complement exists.

    const map = new Map<number, number>()  // value → index

    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i]
        if (map.has(complement)) return [map.get(complement)!, i]
        map.set(nums[i], i)
    }

O(n) time, O(n) space.


## Key pattern: frequency count

    const freq = new Map<string, number>()

    for (const ch of s) {
        freq.set(ch, (freq.get(ch) ?? 0) + 1)
    }

Use (map.get(key) ?? 0) to avoid undefined when a key hasn't been seen yet.


## Key pattern: grouping

    const groups = new Map<string, string[]>()

    for (const word of words) {
        const key = word.split("").sort().join("")  // canonical form
        if (!groups.has(key)) groups.set(key, [])
        groups.get(key)!.push(word)
    }


## Common mistakes

→ Using an object {} as a map — object keys are always strings; Map handles any type
→ Forgetting map.get() returns undefined if the key is absent — use ?? 0 as fallback
→ Iterating with for...in on a Map — use map.forEach() or for...of map.entries()


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Two Sum  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Two Sum

Given an array of integers nums and an integer target, return the indices of the
two numbers that add up to target.

You may assume exactly one solution exists and you may not use the same element twice.
The answer can be returned in any order.

Example:
  twoSum([2, 7, 11, 15], 9)  // → [0, 1]  (2 + 7 = 9)
  twoSum([3, 2, 4], 6)       // → [1, 2]  (2 + 4 = 6)
  twoSum([3, 3], 6)           // → [0, 1]

Constraints:
  - 2 <= nums.length <= 10^4
  - -10^9 <= nums[i] <= 10^9
  - Exactly one valid answer exists

Hint: for each element, check if its complement (target - element) is already in a Map.]],

        code = [[function twoSum(nums: number[], target: number): number[] {
    return [];
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function check(got: number[], expected: number[]): boolean {
    const g = [...got].sort((a, b) => a - b);
    const e = [...expected].sort((a, b) => a - b);
    return JSON.stringify(g) === JSON.stringify(e);
}

function runTests(): void {
    type Result = [string, boolean];
    const results: Result[] = [];

    results.push(["Test 1: [2,7,11,15] target=9",  check(twoSum([2,7,11,15], 9),  [0,1])]);
    results.push(["Test 2: [3,2,4] target=6",       check(twoSum([3,2,4], 6),      [1,2])]);
    results.push(["Test 3: [3,3] target=6",         check(twoSum([3,3], 6),        [0,1])]);
    results.push(["Test 4: negative numbers",       check(twoSum([-1,-2,-3,-4,-5], -8), [2,4])]);
    results.push(["Test 5: larger array",           check(twoSum([1,5,3,7,2,4,6], 9),   [1,3])]);

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
