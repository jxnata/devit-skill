# Devit — Execution Flow

> **Goal:** Execute a single planned task end-to-end, following the project's `.devit/EXECUTION.md` workflow, with TDD and mandatory verification at every step.

---

## Prerequisites

1. **Model:** Execution works well on Sonnet. If the current model is not Sonnet, advise:
   ```
   💡 Execution works well on Sonnet. Run `/model sonnet` then re-run `/devit execute`.
   ```
   (Do not block — the user may continue on the current model.)

2. **`.devit/` must exist.** If missing, tell the user to run `/devit start` first.

3. **Read the project's `.devit/EXECUTION.md`** — it is the authoritative execution guide for this project. It contains the verified commands (type-check, lint, test), test placement conventions, and Definition of Done. **This skill is a thin orchestrator; the project's EXECUTION.md is the law.**

---

## Step 1 — Task selection

**Arguments provided with `/devit execute [epic] [task]`:**

| Arguments           | Action                                                                    |
|---------------------|---------------------------------------------------------------------------|
| No epic, no task    | If only one epic exists, use it. Otherwise list epics and ask.            |
| Epic only           | Read `meta.json`, find first task with `"status": "pending"`. If none, report all completed. |
| Epic + task         | Proceed directly.                                                         |

To list available epics:
```bash
for f in .devit/epics/*/meta.json; do echo "$f"; done
```
Read each `meta.json` and display: `E{NN} — <title> — <N> pending tasks`.

---

## Step 2 — Load context

Before starting, read:
1. `.devit/epics/{N}/plan.md` — epic context and scope
2. `.devit/epics/{N}/tasks/{M}.json` — this task's details
3. Previous tasks' JSON files if they provide context (e.g. types defined earlier that this task uses)

Confirm the task to the user:
```
▶ Executing E{NN} Task {M}: <title>

<description>

Steps:
  1. <step>
  2. <step>
  ...

Tests to write: <tests>
Files: modify <...>, create <...>
```

---

## Step 3 — Run the 6-step workflow

Follow the project's `.devit/EXECUTION.md` exactly. The standard workflow is:

### 3.1 Update status → `in_progress`

Edit `.devit/epics/{N}/meta.json`:
- Find the task entry by id
- Set `"status": "in_progress"`

Commit:
```
chore: start E{NN} task {M} — <title>
```

### 3.2 Implement (TDD)

Follow the task's `steps` array in order:

1. **Write failing tests first** — from the `tests` array in the task JSON. Tests must fail before implementation begins.
2. **Implement** to make the tests pass — follow the steps' file paths, patterns, and validations exactly.
3. **Handle all states** — loading, error, and empty states where applicable.
4. **Refactor** safely once tests are green — improve clarity without changing behavior.

Respect the test placement conventions in the project's `EXECUTION.md`.

### 3.3 Verify — ALL must pass

Run the project's verification commands from its `EXECUTION.md`. Typically:
```bash
<TYPECHECK_CMD>   # No type errors
<LINT_CMD>        # No linting errors
<TEST_CMD>        # All tests pass
```

**Manual checklist:**
- [ ] All acceptance criteria from the task JSON are met
- [ ] Code follows existing project patterns
- [ ] No console errors or warnings left in

**If any verification fails:** Fix the issue. **Do not proceed to commit until all pass.** Do not disable rules, suppress errors, or skip tests.

### 3.4 Commit

Format from the project's `EXECUTION.md`:
```
{type}: {description} (E{NN} task {M})
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### 3.5 Update status → `completed`

Edit `.devit/epics/{N}/meta.json`:
- Set `"status": "completed"` for this task
- Add the commit hash(es) to `"commits": ["abc1234"]`

Get the hash:
```bash
git log -1 --format="%h"
```

### 3.6 Handle PR (if `pr_per_task` = true)

If `meta.json` has `"pr_per_task": true`:
- Branch format: `E{NN}-{M}-<short-slug>`
- Create PR and update `"pull_request"` field in the task entry in `meta.json`

If `pr_per_task` = false: continue on the epic branch; a single PR is created at the end of the epic.

---

## Step 4 — Definition of Done check

A task is **ONLY** done when ALL of the following are true:

- [ ] All steps from the task JSON completed
- [ ] All tests from the `tests` array written and passing
- [ ] Type-check passes with no errors
- [ ] Lint passes with no errors
- [ ] All acceptance criteria verified
- [ ] Loading/error/empty states handled (if applicable)
- [ ] Task status set to `"completed"` in `meta.json`
- [ ] Git commit created with correct format
- [ ] Commit hash(es) added to `meta.json`
- [ ] PR created and recorded (if `pr_per_task` is true)

If anything is missing, go back and fix it. **Never mark done early.**

---

## Step 5 — Report and offer next task

```
✅ E{NN} Task {M} completed: <title>

Commit: <hash>
Tests:  all passing
Lint:   clean
Types:  no errors

Next pending task: Task {M+1} — <title>
Run: /devit execute {N}
```

If all tasks in the epic are done:
```
🎉 Epic E{NN} fully complete! All {N} tasks done.

Run /devit plan <feature> to plan the next epic.
```
