---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

Stateless sub-agents run per paper. Lead agent = loop controller only.

**Shared files** (substitute for agent memory):
- `progress.txt`: papers done/remaining
- `learning.txt`: cross-paper insights compounding across iterations
- `research_note.md`: human-readable summaries + themes
- `synthesis.md`: final cross-paper synthesis after all papers reviewed

## Lead Agent Loop

1. Init (first run only): copy `./agents/skills/templates/progress.txt`, `./agents/skills/templates/learning.txt`, `./agents/skills/templates/research_note.md`, `./agents/skills/templates/synthesis.md` into working dir if not exist. List all PDFs in working dir; populate `progress.txt` with unchecked entries for each.
2. Spawn Abstract Extraction Sub-Agent per paper (parallelizable). Wait for all.
3. Spawn Planning Agent to read abstracts and plan review order. Wait.
4. Pass `progress.txt` + `learning.txt` to Reading Sub-Agent. Repeat until stop condition.

All sub-agents via Task tool (`general` or `mode: subagent`).

## Sub-Agent Instructions

### Abstract extraction sub-agent (once per paper, parallelizable)
- Input: pdf of a paper
- Extract text: `python3 tools/extract_pdf.py <input.pdf>`
- Save to `abstracts.txt` format: `filename.pdf: abstract text`. Append only; do not read.

### Planning sub-agent (once, after abstracts extracted)
- Input: `abstracts.txt`
- Plan review order; prioritize foundational papers first. Reorder `progress.txt` entries accordingly. Do not mark any paper done.

### Reading sub-agent (once per paper, sequential)
1. Read `progress.txt` → pick next unreviewed paper (foundational first).
2. Read `learning.txt` for accumulated themes/gaps.
3. Extract paper: `python3 tools/extract_pdf.py <input.pdf>`
4. Read `templates/research_note.md` for format; append new entry to `research_note.md`. Do not read `research_note.md`—append only.
5. Append to `learning.txt` using format in `templates/learning.txt`. Note contradictions explicitly. Avoid restating existing themes. Conversational tone; speak aloud as if explaining to a peer. LaTeX for equations; define jargon on first use. Max 3 sentences/paragraph. Paragraph-based format; no bullets or tables.
6. Mark paper done in `progress.txt` with one-line note on what was produced.

Writing style: Clear, concise. Define jargon. LaTeX for equations (display mode for key ones). Max 3 sentences/paragraph. Narrative over bullets.

## Final Synthesis

After all papers reviewed (no unchecked entries in `progress.txt`), run one final sub-agent:
1. Read `research_note.md` and `learning.txt`.
2. Read `templates/synthesis.md` for format.
3. Write `synthesis.md` in working dir, filling all three sections (Synthesis, Contradictions, Open Questions). Write complete file; do not append.

Writing style: Same as sub-agents. Clear, concise. Define jargon. LaTeX for equations. Max 3 sentences/paragraph. Paragraph-based; no bullets or tables. Conversational tone.

## Stop Conditions
- No unreviewed papers in `progress.txt` and `synthesis.md` written
- Worker fails repeatedly → escalate to user
- User cancels
