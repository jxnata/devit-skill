# Devit — Start Flow

> **Goal:** Ensure `.devit/` exists and is correctly initialized for this project's stack. If it already exists, summarize the current state.

---

## Step 1 — Check for existing `.devit/`

Run:
```bash
ls .devit/
```

**If `.devit/` exists:**
1. Confirm it's initialized (check for `PLANNING.md`, `EXECUTION.md`, `epics/`).
2. Read all `epics/*/meta.json` files and produce a summary table:
   ```
   Epic  Title                          Status
   ────  ─────────────────────────────  ─────────────────────────────────────
   E01   <title>                        3/4 tasks completed
   E02   <title>                        pending
   ```
3. Show the model recommendation: plan → Opus, execute → Sonnet.
4. **Stop** — do not overwrite anything.

**If `.devit/` does not exist:** continue to Step 2.

---

## Step 2 — Detect the project stack

Probe the following manifest files in order. A project may hit multiple (e.g. a Node monorepo with a Go service) — detect the **primary** stack (the one with the most source files / the one the user is developing in). When ambiguous, ask.

### Node / JavaScript / TypeScript
- Manifest: `package.json`
- Package manager: check lockfiles in **one** combined command rather than separate probes per file, e.g. `ls bun.lockb pnpm-lock.yaml yarn.lock package-lock.json 2>/dev/null` — order of precedence is `bun.lockb` → bun, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm.
- Scripts: read `package.json` `.scripts` object (you're already reading the file for the manifest check above — reuse that read, don't re-fetch it). Map:
  - type-check → `typecheck`, `type-check`, `tsc`, `tsc --noEmit`
  - lint → `lint`, `eslint`
  - test → `test`, `jest`, `vitest`
  - build → `build`
- If a script doesn't exist, fall back to the direct tool (e.g. `npx tsc --noEmit`).
- Derive `{{RUN}}` from PM: `bun run`, `pnpm run`, `yarn`, or `npm run`.

**Test framework detection (Node):**
Check `package.json` devDependencies / dependencies:
- `jest` or `@jest/core` → Jest; tests typically co-located (`*.test.ts`) or in `__tests__/`
- `vitest` → Vitest; same placement
- `@testing-library/react-native` + `jest` → React Native / Expo patterns (check `src/app/` — if present, tests for routes go in `src/__tests__/app/**`)
- No test framework found → warn (see Step 3)

### Other stacks (Python, Go, Rust)

If the primary manifest isn't `package.json` (e.g. `pyproject.toml`, `go.mod`, `Cargo.toml`), read `references/stacks-other.md` now for that stack's detection rules — don't guess.

---

## Step 3 — Verify test setup

TDD is central to devit. Check:
- Is a test framework present (detected above)?
- Is there at least one test file in the repo?

If **no test setup found**:
```
⚠️  No test framework detected. Devit relies on TDD — tests must pass before a
    task can be marked done. Consider setting up tests before planning your first
    epic. I can note this as the first task if you'd like.
```
Ask the user whether to proceed anyway or add a test-setup note.

---

## Step 4 — Write `.devit/`

Create the following structure:
```
.devit/
├── PLANNING.md    (from templates/PLANNING.md, with placeholders replaced)
├── EXECUTION.md   (from templates/EXECUTION.md, with placeholders replaced)
└── epics/         (empty directory)
```

Read `templates/PLANNING.md` and `templates/EXECUTION.md` from the skill's own directory, then **replace all `{{...}}` placeholders** with the detected values:

| Placeholder         | Replacement                                        |
|---------------------|----------------------------------------------------|
| `{{PKG_MANAGER}}`   | `bun` / `pnpm` / `yarn` / `npm` / `pip` / etc.    |
| `{{RUN}}`           | `bun run` / `pnpm run` / `npm run` / `cargo` / etc.|
| `{{TYPECHECK_CMD}}` | Detected type-check command                        |
| `{{LINT_CMD}}`      | Detected lint command                              |
| `{{TEST_CMD}}`      | Detected test command                              |
| `{{BUILD_CMD}}`     | Detected build command (or `# no build step`)      |
| `{{TEST_PLACEMENT}}`| Test file placement conventions for this project   |
| `{{STACK}}`         | e.g. `Node/TypeScript (bun)`, `Python`, `Go`, `Rust`|

Write the files. Create `.devit/epics/` (empty).

---

## Step 5 — Report

Print a confirmation:
```
✅ Devit initialized for <project name>

Stack:     {{STACK}}
Commands:
  Type-check: {{TYPECHECK_CMD}}
  Lint:       {{LINT_CMD}}
  Test:       {{TEST_CMD}}
  Build:      {{BUILD_CMD}}

Files written:
  .devit/PLANNING.md
  .devit/EXECUTION.md
  .devit/epics/   (empty)

Next steps:
  /devit plan <feature>   — plan your first epic
  /devit execute          — execute a planned task
```
