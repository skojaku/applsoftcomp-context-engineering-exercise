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

Shared files: `progress.txt` (papers reviewed, key findings), `learning.txt` (emerging themes, contradictions, gaps)

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
- consult `learning.txt` for known themes and gaps to inform the review. Do NOT write shared files.

Phase 3: Reflect
- input: paper + summary + `progress.txt` + `learning.txt`
- output: write directly to both files.
- append to `progress.txt`: `[DONE] <paper title>`. Key findings, where notes are saved.
- append to `learning.txt` only if useful: `[<paper>] <insight>`. New themes, contradictions, gaps worth tracking across papers. No padding.

## Stop Conditions

- selector returns `DONE`
- worker fails repeatedly + blocker in `learning.txt`, escalate to user
- user cancels
