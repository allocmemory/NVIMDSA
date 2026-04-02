return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 STACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A stack is a LIFO (Last In, First Out) data structure. Think of a stack of
plates: you always add to the top and remove from the top. Whatever you put on
last is the first thing you take off.

In Python, a plain list works perfectly as a stack:

    stack = []
    stack.append(x)   # push
    stack.pop()        # pop (returns and removes last element)
    stack[-1]          # peek (look at top without removing)


## When to use it

Reach for a stack when you notice:

  - You need to process things in reverse order of arrival
  - You need to "undo" or "backtrack" (e.g. browser history, undo operations)
  - The problem involves matching pairs (parentheses, tags, brackets)
  - The phrase "nearest", "previous greater/smaller", or "next greater/smaller"
    appears — these almost always map to a monotonic stack
  - Depth-first traversal of a tree or graph (iterative version uses a stack)

Signal words in problem descriptions:
  → "valid parentheses"        → "daily temperatures"
  → "largest rectangle"        → "trapping rain water"
  → "evaluate expression"      → "decode string"


## Core operations & complexity

  push(x)    →  O(1)   add element to top
  pop()      →  O(1)   remove and return top element
  peek()     →  O(1)   view top element without removing
  isEmpty()  →  O(1)   check if stack has no elements

Space complexity: O(n) where n is the number of elements stored.


## Key techniques

────────────────────────────────────────────────────────
1. Monotonic Stack
────────────────────────────────────────────────────────

Keep the stack always sorted (increasing or decreasing) by popping elements
that violate the order before pushing the new one.

Use case: find the NEXT or PREVIOUS GREATER (or smaller) element for each
element in an array in O(n) total time.

Pattern (next greater element):

    result = [-1] * len(nums)
    stack = []  # stores indices

    for i, val in enumerate(nums):
        while stack and nums[stack[-1]] < val:
            idx = stack.pop()
            result[idx] = val       # val is the next greater for nums[idx]
        stack.append(i)

    # anything left in stack has no next greater → result stays -1

Key insight: each element is pushed once and popped once → O(n) total.

────────────────────────────────────────────────────────
2. Min Stack
────────────────────────────────────────────────────────

Track the current minimum alongside every element. When you push, also record
what the minimum WAS at that point. When you pop, the minimum is restored.

Two approaches:

  A) Two stacks: one for values, one tracking min-so-far at each level.
     push(-2): val_stack=[-2],    min_stack=[-2]
     push(0):  val_stack=[-2,0],  min_stack=[-2,-2]
     push(-3): val_stack=[-2,0,-3], min_stack=[-2,-2,-3]
     pop():    val_stack=[-2,0],  min_stack=[-2,-2]  → get_min = -2 ✓

  B) Single stack of tuples: stack = [(value, min_at_this_point), ...]

────────────────────────────────────────────────────────
3. Stack for DFS (iterative)
────────────────────────────────────────────────────────

Replace recursion with an explicit stack to avoid call-stack overflow on deep
trees or to have finer control over traversal state.

    stack = [root]
    while stack:
        node = stack.pop()
        # process node
        if node.right: stack.append(node.right)
        if node.left:  stack.append(node.left)   # left pushed last → visited first


## Annotated example — Valid Parentheses

Problem: given a string of brackets, return True if every opener is closed
in the correct order.

    Input:  "({[]})"  →  True
    Input:  "([)]"    →  False
    Input:  "{[]"     →  False

Approach: push opening brackets onto the stack. When you see a closing bracket,
the top of the stack must be its matching opener — pop and check. If it doesn't
match, or the stack is empty when you need to pop, return False. At the end the
stack must be empty (all openers were matched).

    def isValid(s: str) -> bool:
        stack = []
        pairs = {')': '(', '}': '{', ']': '['}

        for ch in s:
            if ch in '({[':
                stack.append(ch)           # push opener
            else:
                if not stack or stack[-1] != pairs[ch]:
                    return False           # no match
                stack.pop()                # matched — consume

        return len(stack) == 0             # all openers closed?

Trace for "({[]})":

    ch='('  opener → push        stack: ['(']
    ch='{'  opener → push        stack: ['(', '{']
    ch='['  opener → push        stack: ['(', '{', '[']
    ch=']'  closer → pop '[' ✓  stack: ['(', '{']
    ch='}'  closer → pop '{' ✓  stack: ['(']
    ch=')'  closer → pop '(' ✓  stack: []

    len(stack) == 0  →  True ✓

Why it works: LIFO order means the most recently opened bracket is always on
top. Closing brackets must close the innermost open bracket first — exactly
what LIFO enforces.


## Common mistakes

  ✗ Forgetting to check `if not stack` before peeking or popping
    (popping from an empty stack raises IndexError in Python)

  ✗ In monotonic stack problems, confusing "strictly greater" vs
    "greater or equal" — this changes whether duplicates get correct answers

  ✗ Not realising the stack stores INDICES not values when you need to
    compute distances (e.g. "how far back is the previous greater element?")


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Min Stack  →  press <C-l> to switch to the code panel, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        -- Problem description stored without comment characters.
        -- ui.lua prefixes each line with "// " and wraps it with a divider.
        problem = [[EXERCISE: Min Stack

Design a stack that supports push, pop, top, and retrieving
the minimum element — all in O(1) time.

Implement the MinStack class:
  new MinStack()       initialise the stack
  push(val: number)    push val onto the stack
  pop()                remove the top element
  top(): number        return the top element
  getMin(): number     return the minimum element

Example:
  const s = new MinStack()
  s.push(-2)
  s.push(0)
  s.push(-3)
  s.getMin()   // → -3
  s.pop()
  s.top()      // → 0
  s.getMin()   // → -2

Constraints:
  - pop / top / getMin are always called on a non-empty stack
  - -2^31 <= val <= 2^31 - 1
  - At most 3 * 10^4 calls total]],

        -- Starter code — only the implementation skeleton.
        -- Placed below the problem comment block in the right buffer.
        code = [[class MinStack {
    constructor() {

    }

    push(val: number): void {

    }

    pop(): void {

    }

    top(): number {
        return 0;
    }

    getMin(): number {
        return 0;
    }
}
]],

        -- Test harness — appended to the temp file, never shown to the user.
        -- Run with: bun /tmp/leet_learn_stack.ts
        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    // Test 1: getMin after three pushes
    const s = new MinStack();
    s.push(-2); s.push(0); s.push(-3);
    results.push(["Test 1: getMin after push -3", s.getMin(), -3]);

    // Test 2: top after one pop
    s.pop();
    results.push(["Test 2: top after pop", s.top(), 0]);

    // Test 3: getMin restored after pop
    results.push(["Test 3: getMin restored after pop", s.getMin(), -2]);

    // Test 4: single element getMin
    const s2 = new MinStack();
    s2.push(5);
    results.push(["Test 4: single element getMin", s2.getMin(), 5]);

    // Test 5: getMin tracks new minimum
    s2.push(3);
    results.push(["Test 5: getMin tracks new minimum", s2.getMin(), 3]);

    // Test 6: getMin restored after popping the minimum
    s2.pop();
    results.push(["Test 6: getMin restored to 5", s2.getMin(), 5]);

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
