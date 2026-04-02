return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUEUE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A queue is a First-In First-Out (FIFO) data structure. Elements enter at the
back (enqueue) and leave from the front (dequeue). Think of a checkout line —
the first person in is the first served.

Contrast with Stack (LIFO): in a stack the most recent item leaves first.


## Core operations

  Enqueue   add to back    O(1)
  Dequeue   remove front   O(1)
  Peek      read front     O(1)
  isEmpty   check length   O(1)

A JavaScript array supports this pattern:
  - push()    → enqueue
  - shift()   → dequeue  (but O(n) — shifts all elements)

For O(1) dequeue, use a doubly-linked list or a circular buffer.
In interview problems you can use array.shift() unless told otherwise.


## When to use

→ BFS (level-order traversal of trees and graphs)
→ Sliding window problems (dequeue elements outside the window)
→ Task scheduling / rate limiting
→ Any problem where order of arrival matters


## Key pattern: dequeue stale entries

A common pattern: maintain a queue that only holds items within a valid window.
On each operation, dequeue from the front until the front is inside the window.

    const q: number[] = []

    function ping(t: number): number {
        q.push(t)
        while (q[0] < t - 3000) q.shift()
        return q.length
    }

This is O(1) amortised — each element is pushed once and shifted at most once.


## Key pattern: BFS with a queue

    const queue: TreeNode[] = [root]

    while (queue.length > 0) {
        const node = queue.shift()!
        // process node
        if (node.left)  queue.push(node.left)
        if (node.right) queue.push(node.right)
    }

BFS guarantees level-by-level traversal. DFS (stack) goes deep first.


## Common mistakes

→ Using array.shift() in performance-critical code — it is O(n) in JS
→ Forgetting to handle an empty queue before peeking or dequeuing
→ Confusing queue (FIFO) and stack (LIFO) — the word "next in line" → queue


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Number of Recent Calls  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Number of Recent Calls

Implement a RecentCounter class that counts recent requests within a 3000ms
sliding window.

  new RecentCounter()       — initialises the counter
  ping(t: number): number   — records a call at time t (milliseconds) and
                              returns the number of calls in [t-3000, t]

Calls to ping are always in strictly increasing order of t.

Example:
  const rc = new RecentCounter()
  rc.ping(1)     // → 1   window [0..1]      calls: [1]
  rc.ping(100)   // → 2   window [0..100]    calls: [1, 100]
  rc.ping(3001)  // → 3   window [1..3001]   calls: [1, 100, 3001]
  rc.ping(3002)  // → 3   window [2..3002]   calls: [100, 3001, 3002]

Hint: keep a queue, dequeue calls older than t-3000 on each ping.]],

        code = [[class RecentCounter {
    constructor() {}

    ping(t: number): number {
        return 0;
    }
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    // Test 1: sequence from the problem example
    const rc1 = new RecentCounter();
    results.push(["Test 1a: ping(1)",    rc1.ping(1),    1]);
    results.push(["Test 1b: ping(100)",  rc1.ping(100),  2]);
    results.push(["Test 1c: ping(3001)", rc1.ping(3001), 3]);
    results.push(["Test 1d: ping(3002)", rc1.ping(3002), 3]);

    // Test 2: single call is always 1
    const rc2 = new RecentCounter();
    results.push(["Test 2: single call", rc2.ping(500), 1]);

    // Test 3: all calls expire except the last
    const rc3 = new RecentCounter();
    rc3.ping(1);
    rc3.ping(2);
    results.push(["Test 3: old calls expire", rc3.ping(5000), 1]);

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
