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

3. **Read the project's `.devit/EXECUTION.md` once for this epic.** It is the authoritative execution guide: the 6-step workflow, verification commands, Definition of Done, and commit format all live there — **not repeated in this file**. If you already read it earlier in this conversation (e.g. for a previous task in the same epic), reuse it from context instead of re-reading. This skill only handles task selection, context loading, and reporting — never improvise a different procedure than what `.devit/EXECUTION.md` describes.

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

Read, once per epic session (reuse from context if already loaded for an earlier task in this same epic):
1. `.devit/epics/{N}/plan.md` — epic context and scope
2. `.devit/epics/{N}/tasks/{M}.json` — this task's details (always read fresh — it's specific to this task)
3. Previous tasks' JSON files only if this task's `steps` reference something they define

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

## Step 3 — Execute the workflow

Follow the project's `.devit/EXECUTION.md` exactly: update task status, implement with TDD, run all verification gates, commit, update status again, and handle PRs per `pr_per_task`. Do not skip steps, suppress errors, or invent a different commit/status convention — that file is the law for this project.

---

## Step 4 — Definition of Done check

Before reporting the task complete, check it against the Definition of Done list in the project's `.devit/EXECUTION.md`. **Never mark done early** — if anything is missing, go back and fix it.

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
