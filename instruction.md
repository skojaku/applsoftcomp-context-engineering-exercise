# Exercise: The Autonomous Literature Reviewer

You will write a prompt that instructs Gemini to build an automated literature review pipeline. The pipeline takes a PDF paper as input and produces a written review. You don't write any code — just the prompt.

The catch: a naive prompt produces a broken pipeline. As the pipeline processes 20+ papers across multiple steps, information accumulates and overwhelms the model. Your prompt must engineer the context deliberately at every stage.

Read more: https://rlancemartin.github.io/2025/06/23/context_engineering/

---

## The four techniques your prompt must address

**Write** — Every intermediate result must be saved to a named file. If the pipeline crashes on reference 35 of 40, re-running should skip the 34 already processed.

**Select** — Classify references by relevance before retrieving anything. Not all 20 references matter equally. Define what makes one a priority.

**Compress** — Set a word budget per paper summary (e.g., 150 words). Compress summaries into thematic batches before final synthesis — 20 full papers will not fit in one context window.

**Isolate** — Each stage is a separate Gemini call with its own focused context. The summarizer should not see the full paper history. The synthesizer should not receive raw PDFs.

---

## What the pipeline should do

1. Extract all references from the PDF
2. Classify references by relevance to the paper's core contribution
3. Retrieve abstracts for the most relevant ones via the Semantic Scholar API
4. Summarize each retrieved paper
5. Synthesize summaries into a literature review saved to `review.md`

---

## Steps

**1. Write your prompt** — Create `my_prompt.md`. Be specific. Vague instructions produce vague pipelines.

**2. Evaluate** — Get scored feedback before generating anything:
```
bash evaluate.sh
```
Revise until you score at least 3/4 on every technique.

**3. Generate the pipeline**:
```
bash generate.sh
```
This creates `pipeline.sh`. Read the preview before continuing.

**4. Run it**:
```
bash run.sh
```
Expect a few minutes — it calls Gemini once per stage. Output appears in `review.md`.

**5. Reflect** — Write `reflection.md` answering:
1. Quote one line from your prompt for each technique. What breaks if you remove it?
2. Where did the generated pipeline fall short? What would you add to fix it?

---

## Deliverables

`my_prompt.md`, `pipeline.sh`, `review.md`, `reflection.md`
