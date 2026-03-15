---
name: ralph-loop
description: Lead agent loops, delegating task selection, execution, and reflection to stateless sub-agents. Shared state in progress.txt and learning.txt.
---

# Ralph Loop

Three stateless sub-agents per iteration (no memory of prior iterations):
- selector: reads progress.txt → picks next task
- worker: does task → returns results
- reflector: reviews results → writes progress.txt + learning.txt

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop, repeats.

Shared files: `progress.txt` (completed tasks/artifacts), `learning.txt` (lessons/pitfalls)

---

## Lead Agent Loop

1. Init (first run only) — create missing files with empty headers.
2. Spawn selector — pass `progress.txt`. Returns: next task + done criteria, or `DONE`. If `DONE` → stop.
3. Spawn worker — pass task + `progress.txt` + `learning.txt`. Returns: what was done, artifacts, errors.
4. Spawn reflector — pass task + worker results + `progress.txt` + `learning.txt`. Writes files directly.
5. Loop → step 2

All sub-agents via Task tool. Use `general` or any `mode: subagent` agent.

---

## Sub-Agent Instructions

All prompts start with: "Stateless sub-agent. No memory of prior iterations. Use only context provided."

selector
- input: `progress.txt`
- output: next task + done criteria. Return `DONE` if all complete.
- pick: not done, dependencies met, completable in one pass.

worker
- input: task + done criteria + `progress.txt` + `learning.txt`
- output: what was done, output artifacts (paths/values), errors.
- apply all lessons from `learning.txt` first. Do NOT write shared files.

reflector
- input: task + worker output + `progress.txt` + `learning.txt`
- output: write directly to both files.
- append to `progress.txt`: `[DONE] <task>` — what done, artifacts.
- append to `learning.txt` only if useful: `[<task>] <lesson>` — what happened, what to do/avoid. No padding.

---

## Stop Conditions

- selector returns `DONE`
- worker fails repeatedly + blocker in `learning.txt` → escalate to user
- user cancels
