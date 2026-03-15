---
name: ralph-loop
description: Lead agent loops, delegating task selection, execution, and reflection to stateless sub-agents. Shared state in progress.txt and learning.txt.
---

# Ralph Loop

Three stateless sub-agents per iteration (no memory of prior iterations):

| Role | Job |
|---|---|
| **selector** | reads progress.txt → picks next task |
| **worker** | does task → returns results |
| **reflector** | reviews results → writes progress.txt + learning.txt |

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop, repeats.

Shared files: `progress.txt` (completed tasks/artifacts), `learning.txt` (lessons/pitfalls)

---

## Lead Agent Loop

**1. Init (first run only)** — create missing files with empty headers.

**2. Spawn selector** — pass `progress.txt`. Returns: next task + done criteria, or `DONE`.
If `DONE` → stop.

**3. Spawn worker** — pass task + `progress.txt` + `learning.txt`. Returns: what was done, artifacts, errors.

**4. Spawn reflector** — pass task + worker results + `progress.txt` + `learning.txt`. Writes files directly.

**5. Loop → step 2**

All sub-agents via **Task tool**. Use `general` or any `mode: subagent` agent.

---

## Sub-Agent Instructions

All prompts start with: *"Stateless sub-agent. No memory of prior iterations. Use only context provided."*

**Selector**
- Input: `progress.txt`
- Output: next task + done criteria. Return `DONE` if all complete.
- Pick: not done, dependencies met, completable in one pass.

**Worker**
- Input: task + done criteria + `progress.txt` + `learning.txt`
- Output: what was done, output artifacts (paths/values), errors.
- Apply all lessons from `learning.txt` first. Do NOT write shared files.

**Reflector**
- Input: task + worker output + `progress.txt` + `learning.txt`
- Output: write directly to both files.
- Append to `progress.txt`: `[DONE] <task>` — what done, artifacts.
- Append to `learning.txt` only if useful: `[<task>] <lesson>` — what happened, what to do/avoid. No padding.

---

## Stop Conditions

- Selector returns `DONE`
- Worker fails repeatedly + blocker in `learning.txt` → escalate to user
- User cancels
