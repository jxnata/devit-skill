# Devit — Simple Task Flow

> **Goal:** Execute a small, isolated change that doesn't warrant a full epic — applying the same TDD and verification discipline without the epic scaffolding overhead.

Use this flow when:
- The change is a single concern, completable in ≤1–2 hours
- It doesn't belong to an existing planned epic
- Creating an epic would be overkill (a bug fix, a small utility, a quick refactor)

---

## Step 1 — Define the task

If the user hasn't described the task clearly, ask:
```
What needs to be done?
- What's the expected behavior after the change?
- Which files are likely affected?
- Are there existing tests to extend, or do new tests need to be written?
```

---

## Step 2 — Apply TDD

**Write the failing test(s) first.** Even for small tasks, tests must exist before implementation.

1. Identify where the test should live (check the project's `.devit/EXECUTION.md` for test placement conventions, if it exists).
2. Write a failing test that captures the expected behavior.
3. Run the test to confirm it fails for the right reason.

---

## Step 3 — Implement

- Follow the simplest path to make the test(s) pass.
- Respect existing project patterns (naming, structure, imports).
- Handle edge cases, error states, and empty states where relevant.

---

## Step 4 — Verify

Run the project's verification suite. Read `.devit/EXECUTION.md` for the exact commands. If `.devit/` doesn't exist, check `package.json` scripts or common conventions:

```bash
<TYPECHECK_CMD>   # No type errors
<LINT_CMD>        # No lint errors
<TEST_CMD>        # All tests pass — including the new ones
```

**Do not proceed if anything fails.** Fix the issue and re-verify.

---

## Step 5 — Commit

Use a clear, focused commit message:
```
{type}: {description}
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

No epic/task suffix needed for simple tasks.

---

## Step 6 — Recording the work (skip by default)

**Don't do this unless the user explicitly asks to track simple tasks in a log.** It costs an extra file edit and commit for no functional benefit — the git history already records the change. Only if asked, append a line to `.devit/simple-tasks.md`:
```
- {date} | {type}: {description} | {commit-hash}
```

---

## Simple task checklist

- [ ] Test written before implementation
- [ ] Test was failing before implementation, passing after
- [ ] Type-check passes
- [ ] Lint passes
- [ ] All tests pass
- [ ] Commit message is clear and correctly typed
- [ ] No unintended side effects (check diff before committing)
