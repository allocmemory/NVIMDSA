return {
    content = [=[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TRIE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is it?

A trie (prefix tree) is a tree where each path from root to a node represents
a prefix. Nodes are not individual words — edges are characters.

Inserting "cat", "car", "card", "care":

  root
   └─ c
       └─ a
           ├─ t (end)
           └─ r (end)
               ├─ d (end)
               └─ e (end)

All words sharing a prefix share the same path.


## Core operations

  insert(word)        O(m)  — m = word length, walk/create one node per char
  search(word)        O(m)  — walk nodes, check isEnd flag at final node
  startsWith(prefix)  O(m)  — same walk, return true if path exists

Space: O(total characters inserted)


## When to use

→ Autocomplete and spell checking
→ Word search in a grid (prune branches that can't lead to a word)
→ Prefix-based grouping or filtering
→ IP routing tables (longest prefix match)

Trie vs Hash Map:
  Hash Map gives O(1) exact lookup but cannot answer prefix queries.
  Trie gives O(m) lookup AND O(m) prefix queries.


## Node structure

    class TrieNode {
        children: Map<string, TrieNode> = new Map()
        isEnd: boolean = false
    }

Using a Map supports any character set. For lowercase a-z only, an array of
26 slots is slightly faster:

    children: (TrieNode | null)[] = new Array(26).fill(null)
    // index = char.charCodeAt(0) - 97


## Insert

    insert(word: string): void {
        let cur = this.root
        for (const ch of word) {
            if (!cur.children.has(ch)) {
                cur.children.set(ch, new TrieNode())
            }
            cur = cur.children.get(ch)!
        }
        cur.isEnd = true
    }


## Search

    search(word: string): boolean {
        let cur = this.root
        for (const ch of word) {
            if (!cur.children.has(ch)) return false
            cur = cur.children.get(ch)!
        }
        return cur.isEnd   // path exists AND it is a complete word
    }


## startsWith

    startsWith(prefix: string): boolean {
        let cur = this.root
        for (const ch of prefix) {
            if (!cur.children.has(ch)) return false
            cur = cur.children.get(ch)!
        }
        return true        // path exists (isEnd does not matter)
    }


## Common mistakes

→ Returning true from search() when only a prefix exists — must check isEnd
→ Forgetting to set isEnd = true after insert
→ Sharing node state across multiple Trie instances (always create a fresh root)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Exercise: Implement Trie  →  <C-l> to code, <leader>r to run
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]=],

    exercise = {
        lang = "typescript",
        ext = "ts",

        problem = [[Implement Trie (Prefix Tree)

Implement the Trie class:

  new Trie()                    — initialise the trie
  insert(word: string): void    — insert word into the trie
  search(word: string): boolean — return true if word is in the trie
  startsWith(prefix: string): boolean — return true if any word starts with prefix

Example:
  const t = new Trie()
  t.insert("apple")
  t.search("apple")    // → true
  t.search("app")      // → false   ("app" was not inserted)
  t.startsWith("app")  // → true    (prefix exists)
  t.insert("app")
  t.search("app")      // → true

Constraints:
  - 1 <= word.length, prefix.length <= 2000
  - Only lowercase letters a-z]],

        code = [[class TrieNode {
    children: Map<string, TrieNode> = new Map();
    isEnd: boolean = false;
}

class Trie {
    private root: TrieNode = new TrieNode();

    insert(word: string): void {}

    search(word: string): boolean {
        return false;
    }

    startsWith(prefix: string): boolean {
        return false;
    }
}
]],

        tests = [[
// ── test harness (auto-appended, do not edit) ────────────────────────────────

function runTests(): void {
    type Result = [string, unknown, unknown];
    const results: Result[] = [];

    const t = new Trie();
    t.insert("apple");
    t.insert("app");
    t.insert("cat");

    results.push(["Test 1: search inserted word",     t.search("apple"),      true]);
    results.push(["Test 2: search prefix as word",    t.search("app"),        true]);
    results.push(["Test 3: search missing word",      t.search("appl"),       false]);
    results.push(["Test 4: startsWith valid prefix",  t.startsWith("app"),    true]);
    results.push(["Test 5: startsWith no match",      t.startsWith("dog"),    false]);
    results.push(["Test 6: search different word",    t.search("cat"),        true]);

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
