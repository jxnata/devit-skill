---
name: devit
description: Organized, TDD-driven feature development workflow. Use when planning or executing features, epics, or tasks in any project. Manages the .devit folder, breaks large features into epics and atomic tasks, enforces test-first development, and tracks progress through meta.json. Trigger on: /devit, devit start, devit plan, devit execute, plan epic, plan feature, execute task, TDD workflow.
---

# Devit

Devit brings structure to feature development: break work into **epics** (major features) and **tasks** (1–2 hour atomic units), plan them rigorously, and execute with TDD + verification at every step. Progress is tracked in `.devit/` at the project root.

## Model Recommendation

| Flow    | Recommended model | Switch with     |
|---------|------------------|-----------------|
| start   | any              | —               |
| plan    | **Opus**         | `/model opus`   |
| execute | **Sonnet**       | `/model sonnet` |

If you are on a different model than recommended, advise the user to switch before proceeding.

---

## Router

Parse the first argument passed to `/devit`:

| Argument           | Action                                             |
|--------------------|----------------------------------------------------|
| `start`            | Read `references/start.md` and follow it           |
| `plan [feature]`   | Read `references/planning.md` and follow it        |
| `execute [epic] [task]` | Read `references/execution.md` and follow it  |
| *(none / unknown)* | Show the menu below and ask the user to choose     |

### No argument — show menu

When `/devit` is invoked without a subcommand, output:

```
Devit — three flows:

  /devit start          Initialize .devit/ for this project (or inspect existing)
  /devit plan <feature> Plan a new feature or epic
  /devit execute        Execute the next pending task

Which flow do you want to run?
```

Then wait for the user's reply and route accordingly.

---

## Important invariants

- **Always read the project's `.devit/PLANNING.md` or `.devit/EXECUTION.md`** before planning or executing — those files are the authoritative, stack-adapted rules for that project.
- **Never skip verification.** A task is not done until type-check, lint, and tests all pass.
- **TDD is non-negotiable.** Write failing tests before implementing.
- **Keep tasks 1–2 hours.** If a task is larger, split it.
