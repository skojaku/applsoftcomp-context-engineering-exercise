---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

# Literature Review Loop

Three stateless sub-agents per iteration (no memory of prior iterations):
- selector: reads progress.txt, picks next paper to review
- worker: reviews the paper, returns structured summary
- reflector: updates progress.txt + learning.txt based on summary

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop, repeats.

Shared files (persist across iterations; substitute for agent memory):
- `progress.txt`: operational log. Records which papers are done and what was produced. Lets each fresh agent know what exists and what remains. Prevents re-reviewing the same paper.
- `learning.txt`: intellectual accumulation. Records cross-paper insights — emerging themes, contradictions, methodological patterns, open gaps. Each worker reads this before reviewing, so insights compound across iterations.

## Lead Agent Loop

1. Init (first run only). Create missing files with empty headers.
2. Spawn selector. Pass `progress.txt`. Returns: next paper + review focus, or `DONE`. If `DONE`, stop.
3. Spawn worker. Pass paper + review focus + `progress.txt` + `learning.txt`. Returns: structured summary.
4. Spawn reflector. Pass paper + summary + `progress.txt` + `learning.txt`. Writes files directly.
5. Loop, back to step 2.

All sub-agents via Task tool. Use `general` or any `mode: subagent` agent.

## Sub-Agent Instructions

Phase 1: Select
- input: `progress.txt`
- output: next paper to review + what to focus on. Return `DONE` if all papers reviewed.
- pick: not yet reviewed, foundational papers before dependent ones, reviewable in one pass.

Phase 2: Execute
- input: paper + review focus + `progress.txt` + `learning.txt`
- output: structured summary covering motivation, method, results, relation to prior work, open questions.
- read `learning.txt` before starting; let known themes and gaps shape what you look for. Do NOT write shared files.

Phase 3: Reflect
- input: paper + summary + `progress.txt` + `learning.txt`
- output: write directly to both files.
- append to `progress.txt`: `[DONE] <paper title>`. What was covered, where notes are saved. (operational record)
- append to `learning.txt` only if the paper adds something new: emerging theme, contradiction with prior work, methodological gap. No padding. (intellectual record)

## Stop Conditions

- selector returns `DONE`
- worker fails repeatedly + blocker in `learning.txt`, escalate to user
- user cancels
