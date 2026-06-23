# Devit — Planning Flow

> **Goal:** Translate a feature idea into a well-structured epic with ordered, TDD-ready tasks — or recognize that it's small enough to execute directly as a simple task.

---

## Prerequisites

1. **Model:** Planning works best on Opus. If the current model is not Opus, advise:
   ```
   💡 Planning is best on Opus. Run `/model opus` then re-run `/devit plan`.
   ```
   (Do not block — the user may choose to continue on the current model.)

2. **`.devit/` must exist.** If `.devit/PLANNING.md` is missing, tell the user to run `/devit start` first and stop.

3. **Read the project's `.devit/PLANNING.md` once.** It is the authoritative format guide for this project: the task JSON schema, task-sizing rules, dependency ordering, and the planning checklist all live there — **not repeated in this file**. Use it directly when you get to Steps 4–6 below.

---

## Step 1 — Gather the feature description

If the user supplied a feature description with the command (e.g. `/devit plan add user authentication`), use that. Otherwise ask:

```
What feature or change do you want to plan? Please describe:
- The main objective (1–2 sentences)
- Any scope boundaries (what's in / what's out)
- Key technical decisions already made (if any)
- References or docs to read (if any)
```

Wait for the user's reply. Ask follow-up questions if the objective is unclear or the scope is too broad.

---

## Step 2 — Epic vs simple task decision

**Decide based on estimated effort and scope:**

| Scenario                                       | Decision              |
|-------------------------------------------------|-----------------------|
| Multiple concerns, >1 PR, likely >3 tasks       | → Epic                |
| Single isolated change, ≤1–2h, one concern      | → Simple task         |
| Unclear                                         | → Ask the user        |

**If simple task:** Tell the user:
```
This looks like a single focused change — no epic needed.
Read references/simple-task.md and follow that flow instead.
```
Stop this flow.

**If epic:** continue.

---

## Step 3 — Compute the next epic number

```bash
ls .devit/epics/ | sort -n | tail -1
```

If no epics exist, start at 1. Otherwise `N = last + 1`.

---

## Step 4 — Break the feature into tasks

Apply the task-sizing, dependency-ordering, and TDD-first rules from the project's `.devit/PLANNING.md` (already read in Prerequisites). Use its task JSON schema exactly — don't invent a different shape, and adapt its final acceptance-criterion line to the project's stack (e.g. `No mypy errors`).

---

## Step 5 — Write the epic files

```bash
mkdir -p .devit/epics/{N}/tasks
```

Copy this skill's own skeleton templates and fill in the fields per the schema in the project's `PLANNING.md`:

| Skeleton (this skill's `templates/`) | Destination |
|---|---|
| `epic-meta.json` | `.devit/epics/{N}/meta.json` |
| `epic-plan.md` | `.devit/epics/{N}/plan.md` (≤40 lines: context, scope, key decisions, references) |
| `task.json` | `.devit/epics/{N}/tasks/{M}.json` — one per task |

---

## Step 6 — Run the planning checklist

Run the epic through the checklist in the project's `.devit/PLANNING.md` before proceeding. If any item fails, revise the relevant tasks first.

---

## Step 7 — Confirm with the user

Present the epic summary:
```
📋 Epic E{NN}: <title>

Objective: <objective>
Branch:    feature/<slug>
Tasks:     {N} tasks planned

  Task 1: <title>   — <1-line description>
  Task 2: <title>   — <1-line description>
  ...

Files written:
  .devit/epics/{N}/meta.json
  .devit/epics/{N}/plan.md
  .devit/epics/{N}/tasks/1.json
  ...

Ready to execute? Run: /devit execute {N}
(Switch to Sonnet first: /model sonnet)
```

Ask if the user wants to adjust anything before you finish.
