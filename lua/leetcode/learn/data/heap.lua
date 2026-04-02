return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 HEAP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A heap is a complete binary tree that satisfies the heap property:

  Min-heap: every parent ≤ its children  (root = minimum)
  Max-heap: every parent ≥ its children  (root = maximum)

Heaps are stored as arrays — no pointers needed.
For node at index i:
  parent:       Math.floor((i - 1) / 2)
  left child:   2 * i + 1
  right child:  2 * i + 2


## Core operations

  peek / top    O(1)       — read root (min or max)
  insert        O(log n)   — add to end, bubble up (sift up)
  extract-min   O(log n)   — remove root, replace with last, sift down
  heapify       O(n)       — build heap from unsorted array


## When to use

→ You repeatedly need the smallest (or largest) element
→ k-th largest / k-th smallest problems
→ Merge k sorted arrays
→ Running median (two heaps)
→ Dijkstra's shortest path (priority queue)

The pattern: "top k elements" or "k-th element" → think heap.


## Key technique: k-th largest with a min-heap of size k

Maintain a min-heap of the k largest elements seen so far.
When you encounter a new element larger than the heap minimum, swap it in.
The heap root is always the k-th largest.

    const heap: number[] = []

    for (const n of nums) {
        heap.push(n)
        heap.sort((a, b) => a - b)        // simulate min-heap (O(n log n) total)
        if (heap.length > k) heap.shift() // evict smallest — keeps top-k
    }
    return heap[0]  // k-th largest

Note: JavaScript has no built-in heap. In interviews you either:
  1. Simulate with a sorted array (acceptable for small k)
  2. Import a library
  3. Implement a binary heap class


## Implementing a min-heap (interview skeleton)

    class MinHeap {
        private data: number[] = []

        push(val: number): void {
            this.data.push(val)
            this._siftUp(this.data.length - 1)
        }

        pop(): number | undefined {
            if (!this.data.length) return undefined
            const top = this.data[0]
            const last = this.data.pop()!
            if (this.data.length) { this.data[0] = last; this._siftDown(0) }
            return top
        }

        peek(): number | undefined { return this.data[0] }
        size(): number { return this.data.length }

        private _siftUp(i: number): void {
            while (i > 0) {
                const p = Math.floor((i - 1) / 2)
                if (this.data[p] <= this.data[i]) break
                [this.data[p], this.data[i]] = [this.data[i], this.data[p]]
                i = p
            }
        }

        private _siftDown(i: number): void {
            const n = this.data.length
            while (true) {
                let min = i, l = 2*i+1, r = 2*i+2
                if (l < n && this.data[l] < this.data[min]) min = l
                if (r < n && this.data[r] < this.data[min]) min = r
                if (min === i) break
                [this.data[min], this.data[i]] = [this.data[i], this.data[min]]
                i = min
            }
        }
    }


## Common mistakes

→ Confusing min-heap and max-heap — decide which you need before coding
→ Forgetting to sift down after extracting the root
→ Using array.sort() in a tight loop — O(n log n) per call, not O(log n)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Kth Largest Element in an Array  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Kth Largest Element in an Array

Given an integer array nums and an integer k, return the k-th largest element
in the array (not the k-th distinct element).

Example:
  findKthLargest([3,2,1,5,6,4], 2)  // → 5
  findKthLargest([3,2,3,1,2,4,5,5,6], 4)  // → 4

Constraints:
  - 1 <= k <= nums.length <= 10^4
  - -10^4 <= nums[i] <= 10^4

Hint: maintain a min-heap of exactly k elements. After processing all numbers,
the root of the heap is the k-th largest.]],

        code = [[function findKthLargest(nums: number[], k: number): number {
    return 0;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: k=2",          findKthLargest([3,2,1,5,6,4], 2),          5]);
    results.push(["Test 2: k=4",          findKthLargest([3,2,3,1,2,4,5,5,6], 4),    4]);
    results.push(["Test 3: k=1 (max)",    findKthLargest([1,2,3], 1),                 3]);
    results.push(["Test 4: k=n (min)",    findKthLargest([1,2,3], 3),                 1]);
    results.push(["Test 5: single",       findKthLargest([7], 1),                     7]);
    results.push(["Test 6: duplicates",   findKthLargest([5,5,5,5], 2),              5]);

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
