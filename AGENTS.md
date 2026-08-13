# Agent Guidance

## Figma Workspace

- Use the **Expenses Tracker App** Figma file as the default workspace for all product design and design implementation work.
- File URL: https://www.figma.com/design/lQKEePxhJS0bmf84v6BJ2f/Expenses-Tracker-App
- File key: `lQKEePxhJS0bmf84v6BJ2f`

## Development Workflow

- Before finalizing a task, run the Dart formatter across every modified Dart file.
- Keep the documentation collection at the docs project synchronized with code changes. When implementation work establishes or changes durable technical behavior, update the relevant `Implementation` document in the same task, including lifecycle timing, data sources, persistence boundaries, caching, dependency ownership, and important control flow.
- Document only behavior verified in the code or explicitly agreed with the user. Distinguish current behavior from an agreed but not-yet-implemented target design, and omit incidental structure that is easy to rediscover.
- When practical, structure changes as small, cohesive, commit-friendly units. Keep each unit focused on one responsibility and include its related tests so the development history remains easy for humans to understand and track.
- For code-related work, plan the task as a sequence of small, cohesive, independently reviewable steps. Each step should be meaningful enough to form its own Git commit, and the combined steps should deliver the requested feature or fix.
- Before implementation, share the planned commit-sized steps. Implement only the first step, then stop for the user's review. Do not begin a later step until the user explicitly asks to continue.
- After completing a step, report progress as both completed steps out of total steps and a percentage, then suggest a concise commit message for that completed step. Do not create a commit unless the user asks.
