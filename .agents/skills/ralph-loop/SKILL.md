---
name: literature-review
description: Write a literature review of papers.
---

# Literature ralph Loop

Three stateless sub-agents per iteration (no memory of prior iterations):
- selector: reads progress.txt, picks next task
- worker: does task, returns results
- reflector: reviews results, writes progress.txt + learning.txt

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop, repeats.

Shared files: `progress.txt` (completed tasks/artifacts), `learning.txt` (lessons/pitfalls)

## Lead Agent Loop

1. Init (first run only). Create missing files with empty headers.
2. Spawn selector. Pass `progress.txt`. Returns: next task + done criteria, or `DONE`. If `DONE`, stop.
3. Spawn worker. Pass task + `progress.txt` + `learning.txt`. Returns: what was done, artifacts, errors.
4. Spawn reflector. Pass task + worker results + `progress.txt` + `learning.txt`. Writes files directly.
5. Loop, back to step 2.

All sub-agents via Task tool. Use `general` or any `mode: subagent` agent.

## Sub-Agent Instructions

Phase 1: Select
- input: `progress.txt`
- output: next task + done criteria. Return `DONE` if all complete.
- pick: not done, dependencies met, completable in one pass.

Phase 2: Execute
- input: task + done criteria + `progress.txt` + `learning.txt`
- output: what was done, output artifacts (paths/values), errors.
- apply all lessons from `learning.txt` first. Do NOT write shared files.

Phase 3: Reflect
- input: task + worker output + `progress.txt` + `learning.txt`
- output: write directly to both files.
- append to `progress.txt`: `[DONE] <task>`. What done, artifacts.
- append to `learning.txt` only if useful: `[<task>] <lesson>`. What happened, what to do/avoid. No padding.

## Stop Conditions

- selector returns `DONE`
- worker fails repeatedly + blocker in `learning.txt`, escalate to user
- user cancels
