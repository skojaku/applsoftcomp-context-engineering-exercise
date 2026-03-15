---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

Run a stateless sub-agent per iteration (no memory of prior iterations):
- reads progress.txt, picks next paper to review, reviews the paper,  and updates progress.txt + learning.txt + research_note.md based on summary

Lead agent = loop controller only. Spawns sub-agents in sequence, checks stop, repeats.

Shared files (persist across iterations; substitute for agent memory):
- `progress.txt`: operational log. Records which papers are done and what was produced. Lets each fresh agent know what exists and what remains. Prevents re-reviewing the same paper.
- `learning.txt`: intellectual accumulation. Records cross-paper insights. Each worker reads this before reviewing, so insights compound across iterations.
- `research_note.md`: summary of each paper + cross-paper themes, organized for human consumption.

## Lead Agent Loop

1. Init (first run only). Copy `templates/progress.txt`, `templates/learning.txt`, and `templates/research_note.md` into the working directory if they don’t already exist.
2. Pass `progress.txt` + `learning.txt` to a sub-agent. It selects the next paper to review, based on what’s done and what’s left, and what themes/gaps have already been identified.
5. Loop, back to step 2 until stop condition met.

All sub-agents via Task tool. Use `general` or any `mode: subagent` agent.

## Sub-Agent Instructions

- read `progress.txt`
- pick: not yet reviewed, foundational papers before dependent ones, reviewable in one pass.
- read `learning.txt` to understand what themes and gaps have already identified. 
- read the paper by running `tools/extract_pdf.py` to extract text from PDF files.

    ```
    python3 tools/extract_pdf.py <input.pdf>
    ```
    (Use `python` instead of `python3` if that's what your environment provides.)

- Update progress.txt by marking the paper as done and note what was produced (summary, themes, contradictions).
- Update `research_note.md` by creating a new section based on the following template. Do not read `research_note.md` but append to it. 

   ```
   ## <paper title>

   ### Summary 
    1. Motivation: <Why was this research conducted? What problem does it solve or question does it answer?>
    
    2. Diff of ideas: <How does it differ from previous research? Why is this difference crucial? Why not use existing methods/theories?>
    
    3. Method: <What approach/methodology addresses the research question? (experimental design, data collection, analysis techniques, theoretical frameworks)>
    
    4. Results: <What are the key findings? How do they contribute to the field? Any surprising/significant results?>
    
    5. Significance: <How does it advance understanding? What are potential applications/implications?>


   ```
    Draw from abstract, intro, and conclusion for a well-rounded explanation, with quotes and references to specific sections for clarity. Accessible to general audience while maintaining depth of original research.

    **Style:**
    
    - Use clear, concise language
    - Avoid jargon unless necessary. Define when used. 
    - Use LaTeX for equations.
    - Display mode for key equations. 
    - Max 3 sentences/paragraph. 
    - Prefer narrative over bullet points/lists for conversational tone.

- Append to `learning.txt` following the format in `templates/learning.txt`. Write in progressive, conversational form. Prioritize **new** themes not yet captured. If this paper contradicts or weakens a prior theme, say so explicitly. Connect to prior work only when the connection is specific and non-obvious. Avoid restating themes already in `learning.txt`. Be concise and specific.

## Stop Conditions

- selector returns `DONE`
- worker fails repeatedly + blocker in `learning.txt`, escalate to user
- user cancels
