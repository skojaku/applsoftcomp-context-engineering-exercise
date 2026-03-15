---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

Stateless sub-agents run per paper. The lead agent is a loop controller only.

**Shared files** (substitute for agent memory):
- `progress.txt`. tracks which papers are done/remaining
- `learning.txt`. cross-paper insights that compound across iterations
- `research_note.md`. human-readable summaries + themes
- `synthesis.md`. final cross-paper synthesis written after all papers are reviewed

## Lead Agent Loop

1. Init (first run only): copy `./agents/skills/templates/progress.txt`, `./agents/skills/templates/learning.txt`, `./agents/skills/templates/research_note.md`, and `./agents/skills/templates/synthesis.md` into the working directory if they don't exist. Also list all PDF files in the working directory and populate `progress.txt` with unchecked entries for each.
2. Pass `progress.txt` + `learning.txt` to a sub-agent.
3. Repeat until stop condition.

All sub-agents via Task tool (`general` or `mode: subagent`).

## Sub-Agent Instructions

1. Read `progress.txt` → pick next unreviewed paper (foundational first).
2. Read `learning.txt` to understand accumulated themes and gaps.
3. Extract the paper: `python3 tools/extract_pdf.py <input.pdf>`
4. Read `templates/research_note.md` for the format, then append a new entry to `research_note.md`. Do not read `research_note.md` itself. append only.
5. Append to `learning.txt` using the format in `templates/learning.txt`. Prioritize **new** themes. Note contradictions explicitly. Avoid restating existing themes.
6. Update `progress.txt`: mark the paper done with a one-line note on what was produced.

Writing style: Clear and concise. Define jargon. LaTeX for equations (display mode for key ones). Max 3 sentences/paragraph. Narrative over bullets.

## Final Synthesis

After all papers are reviewed (no unchecked entries remain in `progress.txt`), run one final sub-agent:

1. Read `research_note.md` and `learning.txt`.
2. Read `templates/synthesis.md` for the format.
3. Write `synthesis.md` in the working directory, filling in all three sections (Synthesis, Contradictions, Open Questions). Do not append—write the complete file.

Writing style: same as sub-agents. Clear and concise. Define jargon. LaTeX for equations. Max 3 sentences/paragraph. Narrative over bullets.

## Stop Conditions

- No unreviewed papers remain in `progress.txt` and `synthesis.md` has been written
- Worker fails repeatedly → escalate to user
- User cancels
