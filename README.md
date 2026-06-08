# devit

A [Claude Code](https://claude.ai/code) skill that brings structured, TDD-driven feature development to any project. Break large features into epics and atomic tasks, plan them rigorously, and execute with mandatory verification at every step.

Works with any stack — Node/TypeScript, Python, Go, Rust, or anything else.

---

## How it works

Devit manages a `.devit/` folder at your project root. Inside it lives everything Claude needs to plan and execute features in a disciplined way:

```
.devit/
├── PLANNING.md          # format spec for epics and tasks (adapted to your stack)
├── EXECUTION.md         # 6-step per-task workflow with your project's commands
└── epics/
    └── 1/
        ├── meta.json    # epic metadata and task index (status, commits, PRs)
        ├── plan.md      # one-page epic overview (≤40 lines)
        └── tasks/
            ├── 1.json   # atomic task: steps, tests, acceptance criteria, files
            └── 2.json
```

Each task is scoped to **1–2 hours of focused work**. Tests are written before implementation. A task is only done when type-check, lint, and tests all pass.

---

## Three flows

| Command | What it does |
|---|---|
| `/devit start` | Initialize `.devit/` for your project, or inspect an existing one |
| `/devit plan <feature>` | Plan a new epic with ordered, TDD-ready tasks |
| `/devit execute [epic] [task]` | Execute the next pending task end-to-end |

### Model recommendation

| Flow | Recommended model |
|---|---|
| `plan` | **Opus** (`/model opus`) |
| `execute` | **Sonnet** (`/model sonnet`) |

---

## Installation

### Prerequisites

- [Claude Code](https://claude.ai/code) installed and authenticated

### One-line install

```bash
git clone https://github.com/jxnata/devit-skill.git && cd devit-skill && bash install.sh
```

### Manual install

```bash
git clone https://github.com/jxnata/devit-skill.git
ln -s "$(pwd)/devit-skill/skills/devit" ~/.claude/skills/devit
```

The symlink means updates from `git pull` are picked up automatically — no re-install needed.

### Verify

Restart Claude Code (or open a new session), then type `/devit` — you should see the three-option menu.

---

## Usage

### 1. Start — set up a project

Run in your project directory:

```
/devit start
```

Devit detects your stack from manifest files (`package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`), finds your lint/test/type-check commands, and writes `.devit/PLANNING.md` and `.devit/EXECUTION.md` adapted to your project.

If `.devit/` already exists, it summarizes your epics instead.

**Stack detection:**

| Stack | Detected from | Commands |
|---|---|---|
| Node/TypeScript | `package.json` + lockfile | bun/pnpm/yarn/npm; scripts from `package.json` |
| Python | `pyproject.toml`, `setup.cfg` | pytest, ruff/flake8, mypy |
| Go | `go.mod` | `go test`, `go vet`, golangci-lint |
| Rust | `Cargo.toml` | cargo test, clippy, check, build |

### 2. Plan — break a feature into tasks

```
/devit plan add user authentication with OAuth
```

Devit interviews you for scope and objectives, then decides whether the feature is large enough to warrant an epic or small enough to execute immediately as a simple task.

For an epic, it produces:

**`meta.json`** — the source of truth for task status:
```json
{
  "epic": "E07",
  "title": "Improve User Conversion",
  "objective": "Increase paid conversions by showing a pre-paywall draft preview and win-back abandoned users with a 15-minute discount notification.",
  "branch": "feature/improve-conversion",
  "pr_per_task": false,
  "tasks": [
    { "id": 1, "title": "Add Promo Helpers", "status": "pending", "commits": [] },
    { "id": 2, "title": "Schedule Win-back Notification", "status": "pending", "commits": [] }
  ]
}
```

**`tasks/1.json`** — a concrete, executable task:
```json
{
  "id": 1,
  "title": "Add Promo Helpers and RevenueCat Offering",
  "description": "Add MMKV-based promo timing helpers and a getPromoOfferings() function...",
  "steps": [
    "Write failing tests for isPromoActive()",
    "Create src/lib/promo.ts",
    "Export setPromoUnlockAt, isPromoActive, clearPromo",
    "Implement to pass tests",
    "Refactor safely"
  ],
  "tests": ["isPromoActive() returns false when not set", "..."],
  "acceptanceCriteria": ["All tests pass", "No TypeScript errors"],
  "files": { "modify": ["src/lib/revenuecat.ts"], "create": ["src/lib/promo.ts"] }
}
```

Tasks are ordered by dependency: foundation → building → composition → integration.

### 3. Execute — work through tasks

```
/devit execute
```

Or target a specific epic and task:

```
/devit execute 7 2
```

For each task, Devit:

1. Sets status to `in_progress` in `meta.json` and commits
2. Reads the task JSON — steps, tests, acceptance criteria
3. **Writes failing tests first** (TDD, no exceptions)
4. Implements to make tests pass
5. Runs the project's verification suite — type-check, lint, tests
6. Commits with the format `feat: description (E07 task 2)`
7. Updates `meta.json` with `"status": "completed"` and the commit hash
8. Creates a PR if `pr_per_task` is true

A task is **never marked done** until all verification passes.

---

## Simple tasks

For small isolated changes that don't warrant an epic, Devit routes you to a lightweight flow: write the failing test, implement, verify, commit — no epic files created.

```
/devit plan fix the date formatting bug in the invoice view
```

If Devit judges it's a simple task (≤1–2h, single concern), it switches to the simple-task flow automatically.

---

## Contributing

Issues and PRs are welcome. The skill lives entirely in `skills/devit/` — no build step, no dependencies.

```
skills/devit/
├── SKILL.md              # entry point and subcommand router
├── references/
│   ├── start.md          # start flow instructions
│   ├── planning.md       # planning flow instructions
│   ├── execution.md      # execution flow instructions
│   └── simple-task.md    # simple task flow
└── templates/
    ├── PLANNING.md        # template written into new projects
    ├── EXECUTION.md       # template written into new projects
    ├── epic-meta.json     # meta.json skeleton
    ├── epic-plan.md       # plan.md skeleton
    └── task.json          # task file skeleton
```

---

## License

MIT — see [LICENSE](LICENSE).
