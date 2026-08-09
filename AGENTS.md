# Agent Guidance

## Development Workflow

- Before finalizing a task, run the Dart formatter across every modified Dart file.
- When practical, structure changes as small, cohesive, commit-friendly units. Keep each unit focused on one responsibility and include its related tests so the development history remains easy for humans to understand and track.
- For code-related work, plan the task as a sequence of small, cohesive, independently reviewable steps. Each step should be meaningful enough to form its own Git commit, and the combined steps should deliver the requested feature or fix.
- Before implementation, share the planned commit-sized steps. Implement only the first step, then stop for the user's review. Do not begin a later step until the user explicitly asks to continue.
- After completing a step, report progress as both completed steps out of total steps and a percentage, then suggest a concise commit message for that completed step. Do not create a commit unless the user asks.
