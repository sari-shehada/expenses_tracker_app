# Agent Guidance

## Figma Workspace

- Use the **Expenses Tracker App** Figma file as the default workspace for all product design and design implementation work.
- File URL: https://www.figma.com/design/lQKEePxhJS0bmf84v6BJ2f/Expenses-Tracker-App
- File key: `lQKEePxhJS0bmf84v6BJ2f`

## Development Workflow

- Treat refactoring and generalization as behavior- and value-preserving work. Keep existing layout values, dimensions, spacing, colors, typography, copy, defaults, validation, control flow, persistence behavior, and public APIs unchanged unless the user explicitly approves a change.
- Do not include opportunistic visual, behavioral, or product changes inside a refactoring. If an improvement is identified, propose it separately with its rationale and expected impact, and wait for approval before implementing it.
- Call out any unavoidable difference before making the change. Never make a value change silently during a refactoring.
- Before finalizing a task, run the Dart formatter across every modified Dart file.
- Prefer `async`/`await` over `.then(...)` wherever the same behavior can be expressed clearly. Use Future callbacks only when `async`/`await` is not appropriate.
- Use `AddVerticalSpacing` and `AddHorizontalSpacing` instead of an empty `SizedBox` when adding one-dimensional layout spacing. Keep `SizedBox` for sizing content or constraining both dimensions.
- Keep the documentation collection at the docs project synchronized with code changes. When implementation work establishes or changes durable technical behavior, update the relevant `Implementation` document in the same task, including lifecycle timing, data sources, persistence boundaries, caching, dependency ownership, and important control flow.
- Document only behavior verified in the code or explicitly agreed with the user. Distinguish current behavior from an agreed but not-yet-implemented target design, and omit incidental structure that is easy to rediscover.
- When practical, structure changes as small, cohesive, commit-friendly units. Keep each unit focused on one responsibility and include its related tests so the development history remains easy for humans to understand and track.
- For code-related work, plan the task as a sequence of small, cohesive, independently reviewable steps. Each step should be meaningful enough to form its own Git commit, and the combined steps should deliver the requested feature or fix.
- Before implementation, share the planned commit-sized steps. Implement only the first step, then stop for the user's review. Do not begin a later step until the user explicitly asks to continue.
- After completing a step, report progress as both completed steps out of total steps and a percentage, then suggest a concise commit message for that completed step. Do not create a commit unless the user asks.
