# Task Execution Guide

> Stack: **{{STACK}}** · Package manager: `{{PKG_MANAGER}}`

## Task Selection

**No epic specified:** Check if only one epic exists (use it), else list available from `.devit/epics/` and ask.

**Epic specified, no task:** Read `meta.json`, find first `"status": "pending"`, inform if all completed.

**Both specified:** Proceed directly.

**Before starting:** Read `plan.md` (epic context), `tasks/{M}.json` (task details), review previous tasks if needed.

## Workflow (6 Steps)

### 1. Update Status → `in_progress`

Edit `.devit/epics/{N}/meta.json`: set `"status": "in_progress"` for the task. Commit:
```
chore: start E{NN} task {M} — <title>
```

### 2. Implement (TDD)

- Read `tasks/{M}.json`
- **Write failing tests first** — from the `tests` array
- Follow `steps` in order (file paths, patterns, validations)
- Implement to make tests pass
- Handle loading/error/empty states
- Refactor safely once green

**Test file placement:**

{{TEST_PLACEMENT}}

### 3. Verify (CRITICAL — All Must Pass)

```bash
{{TYPECHECK_CMD}}   # No type errors
{{LINT_CMD}}        # No lint errors
{{TEST_CMD}}        # All tests pass
```

**Manual checks:**

- [ ] All acceptance criteria met
- [ ] Follows existing project patterns
- [ ] No console errors

**If anything fails:** Fix it. Do not disable rules, suppress errors, or skip tests. Do not move on until all checks pass.

### 4. Commit

Format: `{type}: {description} (E{NN} task {M})`

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### 5. Update Status → `completed`

Edit `.devit/epics/{N}/meta.json`:
- `"status": "completed"`
- `"commits": ["<7-char-hash>"]`

```bash
git log -1 --format="%h"
```

Multiple commits: `"commits": ["abc1234", "def5678"]`

### 6. Handle PR (if `pr_per_task` = true)

Branch format: `E{NN}-{M}-<short-slug>`

Update `meta.json` task entry with `"pull_request": <number>`.

If `pr_per_task` = false: continue on epic branch; single PR at end of epic.

---

## Definition of Done

A task is **ONLY** done when **ALL** of these are true:

- [ ] All steps from task JSON completed
- [ ] All tests from `tests` array written and passing
- [ ] Type-check passes: `{{TYPECHECK_CMD}}`
- [ ] Lint passes: `{{LINT_CMD}}`
- [ ] All acceptance criteria verified
- [ ] Loading/error/empty states handled (if applicable)
- [ ] Task status set to `"completed"` in `meta.json`
- [ ] Git commit created with correct format
- [ ] Commit hash(es) added to `meta.json`
- [ ] PR created and recorded (if `pr_per_task` is true)

---

## Troubleshooting

**Tests fail:** Review specs in task JSON, check acceptance criteria, verify mocks. Do NOT mark done until passing.

**Type errors:** Check imports, type definitions, prop types. Do NOT mark done until clean.

**Lint errors:** Fix formatting/style. Never disable rules. Do NOT mark done until lint passes.

---

## Quick Reference

```bash
# Find next pending task
cat .devit/epics/{N}/meta.json | jq '.tasks[] | select(.status == "pending") | .id, .title'

# Run all verifications
{{TYPECHECK_CMD}} && {{LINT_CMD}} && {{TEST_CMD}}

# Get commit hash
git log -1 --format="%h"
```

**Always follow this workflow. Never skip verification.**
