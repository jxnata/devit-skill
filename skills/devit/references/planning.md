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

3. **Read the project's `.devit/PLANNING.md`** — it is the authoritative format guide for this project. Use its task JSON schema, ordering guidelines, and checklist throughout this flow.

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
|-----------------------------------------------|-----------------------|
| Multiple concerns, >1 PR, likely >3 tasks     | → Epic                |
| Single isolated change, ≤1–2h, one concern    | → Simple task         |
| Unclear                                        | → Ask the user        |

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

Apply the guidelines from the project's `.devit/PLANNING.md`:

**Ordering (always follow this dependency order):**
1. Foundation — query keys, hooks, utilities, data models, types
2. Building — components, forms, dialogs, API layers
3. Composition — tables, lists, pages assembling building blocks
4. Integration — routes, navigation, E2E connections

**Task sizing:**
- Each task: 1–2 hours of focused work
- Good: one component + its tests; a form (3–5 fields); a hook/utility + tests
- Split when: full page → layout + sections; large form → subcomponents; CRUD → per layer
- Combine when: trivial imports, renames, or config tweaks

**TDD first:** Every non-trivial task must list failing tests to write *before* implementing. The `tests` array must not be empty unless the task is genuinely trivial (e.g. a rename).

**Task JSON format** (from the project's `PLANNING.md` schema):
```json
{
  "id": 1,
  "title": "Verb + noun, <60 chars",
  "description": "What and why (1–3 sentences)",
  "steps": [
    "Write failing tests for <behavior>",
    "Create src/path/file.ts",
    "Define <schema/type>: field (validation)",
    "Implement to pass tests",
    "Refactor safely"
  ],
  "tests": ["Happy path", "Validation errors", "Edge cases", "Conditional logic"],
  "acceptanceCriteria": [
    "All tests pass",
    "Feature behaves as specified",
    "Loading/error/empty states handled",
    "No TypeScript errors"  // adapt to the stack's equivalent
  ],
  "files": {
    "modify": ["src/existing.ts"],
    "create": ["src/new.ts", "src/new.test.ts"]
  }
}
```

Adjust the last acceptance criterion to match the project's stack (e.g. `No mypy errors`, `Passes cargo check`).

---

## Step 5 — Write the epic files

Create the directory and files:
```bash
mkdir -p .devit/epics/{N}/tasks
```

**meta.json** (`.devit/epics/{N}/meta.json`):
```json
{
  "epic": "E{NN}",
  "title": "<title>",
  "objective": "<objective — 1-2 sentences of business value>",
  "branch": "feature/<kebab-slug>",
  "pull_request": null,
  "pr_per_task": false,
  "tasks": [
    {
      "id": 1,
      "title": "<task 1 title>",
      "file": "tasks/1.json",
      "status": "pending",
      "commits": [],
      "pull_request": null
    }
  ]
}
```

**plan.md** (`.devit/epics/{N}/plan.md`, ≤40 lines):
- 1 paragraph: context and problem being solved
- `## Scope` section: bullet list of what's included
- `## Key Decisions` section: architectural choices already made
- `## References` section: relevant files, docs, tickets

**tasks/{M}.json** — one file per task, using the schema above.

---

## Step 6 — Run the planning checklist

From the project's `.devit/PLANNING.md` checklist:

```
- [ ] Clear title and objective
- [ ] Tasks 1–2h, well named (verb + noun)
- [ ] Tests written first (TDD) — tests array populated for every non-trivial task
- [ ] Ordered by dependency (foundation → building → composition → integration)
- [ ] Steps are specific (concrete paths, validations, patterns)
- [ ] Acceptance criteria are measurable outcomes
- [ ] Files lists are complete (modify + create)
- [ ] No blockers between tasks
```

If any item fails, revise the relevant tasks before proceeding.

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
