# Future Ideas

## Language Switcher

Each exercise currently hard-codes `lang` and `ext` in its data file.
The plan is to let the user pick a language before opening a lesson, so the
same problem (e.g. MinStack, Contains Duplicate) can be solved in any of the
supported languages.

**Planned languages:** Python · TypeScript / JavaScript · C

**What runner.lua already supports:**
- `py` / `python` → `python3`
- `ts` / `typescript` → `bun`
- `js` / `javascript` → `node`
- C would need a `cc`/`clang` entry and a compile-then-run step

**Design sketch:**
- Each data file exports multiple `exercise` variants, keyed by language:
  ```lua
  exercises = {
      ts = { lang = "typescript", ext = "ts", code = ..., tests = ... },
      py = { lang = "python",     ext = "py", code = ..., tests = ... },
      c  = { lang = "c",          ext = "c",  code = ..., tests = ... },
  }
  ```
- `learn.open(module_name, lang)` picks the right variant (default: `"ts"`)
- A picker (nui select or telescope) lets the user choose before the panel opens
- `runner.lua` gets a compile step for C: `cc -o /tmp/out /tmp/file.c && /tmp/out`
