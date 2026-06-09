# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code skill called **devit** — a structured, TDD-driven feature development workflow. The skill lives entirely in `skills/devit/` with no build step, no dependencies, and no package manager.

## Structure

```
skills/devit/
├── SKILL.md              # Entry point and subcommand router (loaded by Claude Code)
├── references/
│   ├── start.md          # /devit start flow
│   ├── planning.md       # /devit plan flow
│   ├── execution.md      # /devit execute flow
│   └── simple-task.md    # Lightweight single-task flow
└── templates/
    ├── PLANNING.md        # Written into user projects (contains {{placeholders}})
    ├── EXECUTION.md       # Written into user projects (contains {{placeholders}})
    ├── epic-meta.json     # meta.json skeleton
    ├── epic-plan.md       # plan.md skeleton
    └── task.json          # Task file skeleton
```

The `index.html` and `.nojekyll` at the repo root are for GitHub Pages documentation only.

## Install / update

```bash
bash install.sh   # Creates a symlink: ~/.claude/skills/devit → skills/devit/
```

The symlink means `git pull` updates are picked up automatically — no re-install after changes.

## How the skill works

`SKILL.md` is the entry point. It routes `/devit <subcommand>` to the appropriate reference file:

| Subcommand | Reference file |
|---|---|
| `start` | `references/start.md` |
| `plan [feature]` | `references/planning.md` |
| `execute [epic] [task]` | `references/execution.md` |

When `/devit plan` judges a feature is small (≤1–2h, single concern), it delegates to `references/simple-task.md` instead of creating an epic.

## Key design constraints

- **No code, no build** — all files are Markdown and JSON. Changes are just text edits.
- **Templates use `{{placeholders}}`** — `start.md` documents every placeholder that `PLANNING.md` and `EXECUTION.md` templates expose. When editing templates, keep placeholders consistent with what `references/start.md` fills in.
- **`SKILL.md` invariants are the contract** — any reference file change must stay consistent with the invariants listed in `SKILL.md` (TDD non-negotiable, verification required, task scope 1–2h).
- **Task JSON schema is defined in `references/planning.md`** — if the schema changes, update both the planning reference and `templates/task.json`.
