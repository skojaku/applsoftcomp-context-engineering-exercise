---
name: ralph-loop
description: Lead agent selects tasks one at a time, spawns a stateless sub-agent per task, collects results, updates progress.txt and learning.txt, repeats.
---

# Ralph Loop

Lead agent = orchestrator. Never does the work. Selects tasks, spawns sub-agents, maintains shared state.
Sub-agent = stateless. No memory of prior iterations. Reads context files, does task, reports back.

Shared files:
- `progress.txt` — what's been done
- `learning.txt` — lessons/pitfalls from prior iterations

---

## Lead Agent: Loop Steps

1. Init (first run only)
Create missing files:
```
progress.txt:  # Progress Log\n(empty)
learning.txt:  # Lessons Learned\n(empty)
```

2. Select task
Read `progress.txt`. Pick next task that: not done, dependencies met, completable in one pass.
No tasks left → write final summary, stop.

3. Spawn sub-agent
Use the **Task tool** to spawn a single sub-agent per iteration.
The sub-agent should be `general` (built-in) or any agent defined with `mode: subagent` in `opencode.json` or `.opencode/agents/`.
Task tool prompt must include:
1. Task description + done criteria
2. Full contents of `progress.txt`
3. Full contents of `learning.txt`
4. Expected output format
5. Explicit: *"No memory of prior iterations. Use only the context provided."*

4. Collect results
Review output: completed? errors? partial? new discoveries?

5. Update shared state
Append to `progress.txt`:
```
[DONE] <task>
  - what was done
  - output artifacts (paths, values)
  - iteration/date
```
Append to `learning.txt` only if genuinely useful:
```
[<task>] <lesson>
  - what happened
  - what to do/avoid next time
```
No padding. Factual and actionable only.

6. Loop → back to step 2

---

## Sub-Agent: Steps

1. Read `progress.txt` — know what exists
2. Read `learning.txt` — apply lessons before starting
3. Do the task
4. Report results clearly

Do NOT write to `progress.txt` or `learning.txt`. Lead agent owns those.

---

## Stop Conditions

- All tasks done in `progress.txt`
- Task failing repeatedly + blocker captured in `learning.txt` → escalate to user
- User cancels

---

## Example Sub-Agent Prompt

```
You are a stateless sub-agent. No memory of previous iterations.

## Task
<description and done criteria>

## progress.txt
<contents>

## learning.txt
<contents>

## Output
Summarize what you did and produced. Do NOT modify progress.txt or learning.txt.
```
