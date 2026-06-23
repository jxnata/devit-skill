# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code skill called **devit** — a structured, TDD-driven feature development workflow. The skill lives entirely in `skills/devit/` with no build step, no dependencies, and no package manager.

## Structure

```
skills/devit/
├── SKILL.md              # Entry point and subcommand router (loaded by Claude Code)
├── references/
│   ├── start.md          # /devit start flow (Node/JS/TS detection inline)
│   ├── stacks-other.md   # Python/Go/Rust detection — loaded by start.md only when needed
│   ├── planning.md       # /devit plan flow (decision logic only — schema lives in templates/PLANNING.md)
│   ├── execution.md      # /devit execute flow (task selection/reporting only — workflow lives in templates/EXECUTION.md)
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
- **Single source of truth per concern, to control token cost** — the project's `.devit/PLANNING.md` and `.devit/EXECUTION.md` (written from `templates/`) are read on every `/devit plan`/`/devit execute` call and are the **only** place the task JSON schema and the 6-step execution workflow are spelled out in full. The skill's own `references/planning.md` and `references/execution.md` hold only the decision logic and mechanics that aren't in those project files (epic-vs-simple-task judgment, task selection, file-write mechanics). Don't reintroduce a second full copy of the schema or workflow into the reference files — that duplication gets re-read on every invocation and was the main driver of excess token usage in the iteration-1 benchmark.
