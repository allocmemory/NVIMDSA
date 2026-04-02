return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 LINKED LIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A linked list is a sequence of nodes where each node holds a value and a pointer
to the next node. Unlike arrays, nodes are NOT stored contiguously — they can be
anywhere in memory, linked by references.

  Singly linked:   head → [1] → [2] → [3] → null
  Doubly linked:   null ← [1] ↔ [2] ↔ [3] → null


## Core operations

  Access     walk from head   O(n)  — no index; must follow pointers
  Search     linear scan      O(n)
  Insert     at head          O(1)  — update one pointer
             at tail*         O(1)  if tail pointer is maintained
             after node p     O(1)  — update two pointers
  Delete     given node p     O(1)  — update predecessor's next pointer
             by value         O(n)  — must search first

*Arrays have O(1) access, linked lists have O(1) insert/delete. That is the
fundamental tradeoff.


## When to use

→ Frequent insert/delete at the front (stack, queue implementations)
→ You don't need random access by index
→ Implementing other structures: LRU cache, deque, adjacency lists


## Key techniques

### 1. Dummy head node

Avoids special-casing an empty list or operations on the head node.

    const dummy = new ListNode(0)
    dummy.next = head
    let cur = dummy
    // operate on cur.next instead of head
    return dummy.next

### 2. Two-pointer (fast & slow)

Detects cycles, finds the middle, finds the k-th node from the end.

    let slow = head, fast = head
    while (fast && fast.next) {
        slow = slow.next!
        fast = fast.next.next!
    }
    // slow is now at the middle

### 3. Iterative reversal (three pointers)

    let prev: ListNode | null = null
    let cur: ListNode | null  = head

    while (cur) {
        const next = cur.next   // save next before overwriting
        cur.next = prev         // reverse the link
        prev = cur              // advance prev
        cur = next              // advance cur
    }
    return prev  // new head

Trace on [1 → 2 → 3]:
  Step 1: prev=null,  cur=1  → 1.next=null,  prev=1, cur=2
  Step 2: prev=1,     cur=2  → 2.next=1,     prev=2, cur=3
  Step 3: prev=2,     cur=3  → 3.next=2,     prev=3, cur=null
  Return: 3 → 2 → 1 → null


## Common mistakes

→ Losing the rest of the list: always save cur.next BEFORE overwriting cur.next
→ Off-by-one when stopping: check cur !== null vs cur.next !== null carefully
→ Forgetting to null-terminate after splice: set the last node's next to null


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Reverse Linked List  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Reverse Linked List

Given the head of a singly linked list, reverse it in-place and return the new head.

Example:
  1 → 2 → 3 → 4 → 5  →  5 → 4 → 3 → 2 → 1
  1 → 2                →  2 → 1
  (empty list)         →  null

Constraints:
  - 0 <= number of nodes <= 5000
  - -5000 <= node.val <= 5000

Hint: use three pointers — prev, cur, next.]],

        code = [[class ListNode {
    val: number;
    next: ListNode | null;
    constructor(val: number, next: ListNode | null = null) {
        this.val = val;
        this.next = next;
    }
}

function reverseList(head: ListNode | null): ListNode | null {
    return null;
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function toArray(head: ListNode | null): number[] {
    const out: number[] = [];
    while (head) { out.push(head.val); head = head.next; }
    return out;
}

function fromArray(vals: number[]): ListNode | null {
    let head: ListNode | null = null;
    for (let i = vals.length - 1; i >= 0; i--) head = new ListNode(vals[i], head);
    return head;
}

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    results.push(["Test 1: 5 nodes", toArray(reverseList(fromArray([1,2,3,4,5]))), [5,4,3,2,1]]);
    results.push(["Test 2: 2 nodes", toArray(reverseList(fromArray([1,2]))),       [2,1]]);
    results.push(["Test 3: 1 node",  toArray(reverseList(fromArray([42]))),        [42]]);
    results.push(["Test 4: empty",   toArray(reverseList(null)),                   []]);
    results.push(["Test 5: 3 nodes", toArray(reverseList(fromArray([3,2,1]))),     [1,2,3]]);

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
