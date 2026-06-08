# Epic and Task Planning Guide

> Stack: **{{STACK}}** · Package manager: `{{PKG_MANAGER}}`

Break features into **epics** (major features) and **tasks** (1–2 hour units). Apply **TDD**: write failing tests → implement → refactor.

## Structure

```
.devit/epics/{N}/
├── meta.json          # Epic metadata + task index
├── plan.md            # Epic overview, context, and goals
└── tasks/
    ├── 1.json        # Task details
    └── 2.json
```

**plan.md** — One-page summary of the epic (≤40 lines): 1-paragraph context, scope (bullets), key decisions, references. No redundancy.

## meta.json

```json
{
	"epic": "E06",
	"title": "Dashboard & Metrics",
	"objective": "Business value (1–2 sentences)",
	"branch": "feature/dashboard-metrics",
	"pull_request": null,
	"pr_per_task": false,
	"tasks": [
		{
			"id": 1,
			"title": "Create Component",
			"file": "tasks/1.json",
			"status": "pending",
			"commits": [],
			"pull_request": null
		}
	]
}
```

**Fields**: `branch`, `pull_request`, `pr_per_task`, `status` (pending|in_progress|completed), `commits` (7-char hash), task `pull_request` if `pr_per_task`.

## Task File

```json
{
	"id": 1,
	"title": "Create Component Name",
	"description": "What and why (1–3 sentences)",
	"steps": [
		"Write failing tests (expected behavior)",
		"Create src/path/file.ts",
		"Define <type/schema>: field (validation)",
		"Implement to pass tests",
		"Refactor safely"
	],
	"tests": ["Happy path", "Validation errors", "Edge cases", "Conditional logic"],
	"acceptanceCriteria": [
		"All tests pass",
		"Feature behaves as specified",
		"Loading/error/empty states handled",
		"No type errors ({{TYPECHECK_CMD}})"
	],
	"files": {
		"modify": ["src/existing.ts"],
		"create": ["src/new.ts", "src/new.test.ts"]
	}
}
```

## Test File Placement

{{TEST_PLACEMENT}}

## Guidelines

- **Title**: verb + noun, <60 chars
- **Steps**: specific paths, validations, patterns — never vague
- **Tests**: first (TDD); `[]` only if the task is truly trivial
- **Acceptance**: measurable outcomes; end with "No type errors"

## Task Size (1–2h)

**Good**: one module + tests; a form (3–5 fields); a hook/utility + tests

**Split**: full page → layout + sections; large form → subcomponents; CRUD → per layer

**Combine**: minor changes (imports, renames, config tweaks)

## Ordering

1. **Foundation**: types, query keys, utilities, hooks
2. **Building**: components, forms, API layers, dialogs
3. **Composition**: tables, sheets, lists assembling building blocks
4. **Integration**: pages, routes, navigation

## Process

1. Define epic (scope, objective)
2. Identify parts (data, UI, pages, integrations)
3. Break into tasks (tests first)
4. Order by dependency
5. Validate (1–2h, no blockers)

## Writing Rules

- **Steps**: concrete and technical
  - ✅ `Create src/x/form.ts`, `Define schema: amount (positive number)`
  - ❌ Vague: `Add form`, `Handle validation`
- **Acceptance**: outcomes, not implementation details
  - ✅ `Form validates required fields`
  - ❌ `Uses useState for form state`
- **Tests**: happy path, validation, edge cases, conditional logic

## Checklist

- [ ] Clear title and objective
- [ ] Tasks 1–2h, well named (verb + noun)
- [ ] Tests first (TDD) — `tests` array populated for every non-trivial task
- [ ] Ordered by dependency (foundation → building → composition → integration)
- [ ] Steps are specific (concrete paths, patterns, validations)
- [ ] Acceptance criteria are measurable outcomes
- [ ] Files lists complete (modify + create)
- [ ] No blockers between tasks

## Quick Commands

```bash
mkdir -p .devit/epics/{N}/tasks
touch .devit/epics/{N}/meta.json
touch .devit/epics/{N}/plan.md

# Get commit hash for meta.json
git log -1 --format="%h"
```
