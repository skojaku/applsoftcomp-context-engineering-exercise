---
name: ralph-loop
description: Lead agent runs a loop, delegating task selection, execution, and reflection to stateless sub-agents. Shared state lives in progress.txt and learning.txt.
---

# Ralph Loop

Three sub-agent roles per iteration. All are stateless — no memory of prior iterations.

| Role | Job |
|---|---|
| **selector** | Reads progress.txt, picks next task, returns task description |
| **worker** | Does the task, returns results |
| **reflector** | Reviews results, appends to progress.txt and learning.txt |

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop conditions, repeats.

Shared files:
- `progress.txt` — completed tasks and artifacts
- `learning.txt` — lessons/pitfalls from prior iterations

---

## Lead Agent: Loop Steps

**1. Init (first run only)**
Create missing files:
```
progress.txt:  # Progress Log\n(empty)
learning.txt:  # Lessons Learned\n(empty)
```

**2. Spawn selector sub-agent**
Pass full contents of `progress.txt`. Selector returns: next task + done criteria, or `DONE` if nothing remains.
If `DONE` → stop.

**3. Spawn worker sub-agent**
Pass task from selector + full contents of `progress.txt` and `learning.txt`.
Worker returns: what was done, output artifacts, any errors.

**4. Spawn reflector sub-agent**
Pass task description + worker results + full contents of `progress.txt` and `learning.txt`.
Reflector writes directly to `progress.txt` and `learning.txt` (it owns these writes).

**5. Loop → back to step 2**

All sub-agents are spawned via the **Task tool**. Use `general` (built-in) or any agent with `mode: subagent`.

---

## Sub-Agent Instructions

All sub-agents start their prompt with:
> *"You are a stateless sub-agent. No memory of previous iterations. Use only the context provided."*

### Selector
Input: contents of `progress.txt`
Output: next task + done criteria. If all tasks complete, return exactly `DONE`.
Rules: pick task that is not done and has dependencies met. Small enough for one pass.

### Worker
Input: task description + done criteria + contents of `progress.txt` + contents of `learning.txt`
Output: summary of what was done, output artifacts (file paths, values), errors if any.
Rules: apply all lessons from `learning.txt` before starting. Do NOT write to shared files.

### Reflector
Input: task description + worker output + contents of `progress.txt` + contents of `learning.txt`
Output: updated `progress.txt` and `learning.txt` (write directly to files).
Rules:
- Append to `progress.txt`:
  ```
  [DONE] <task>
    - what was done
    - output artifacts
  ```
- Append to `learning.txt` only if genuinely useful — no padding:
  ```
  [<task>] <lesson>
    - what happened / what to do or avoid next time
  ```

---

## Stop Conditions

- Selector returns `DONE`
- Worker fails repeatedly + reflector has logged the blocker → lead agent escalates to user
- User cancels
