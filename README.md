# Context Engineering Exercise

Build a real AI skill from scratch. Each step teaches a different principle of context engineering.

## Setup

Run the setup skill first:
```
Run .agents/skills/setup/SKILL.md
```

---

## Choose Your Level

| Level | Skill | What it does |
|---|---|---|
| ⭐ | `study-notes` | Given a lecture PDF, produce structured notes: key concepts, definitions, practice questions |
| ⭐⭐ | `trip-planner` | Given budget, dates, and group size, plan a trip from Binghamton with itinerary and costs |
| ⭐⭐⭐ | `arxiv-recommender` | Given a research interest or paper abstract, recommend relevant arXiv papers with explanations |

Create your skill under `.agents/skills/<skill-name>/`.

---

## Step 1 — Vibe

Open opencode and build a rough version of your skill. No planning, no structure — just explore.

**Goal:** get a feel for what's hard. Your output will be messy. That's intentional.

---

## Step 2 — Plan

Open a **fresh** opencode session. Paste this prompt and replace `[SKILL]`:

```
I want to build an AI skill called [SKILL]. Interview me about it one question
at a time. Ask about inputs, outputs, edge cases, tools needed, and output
format. Do not ask the next question until I answer the current one. Keep going
until nothing is ambiguous. Then write PRD.md where each task is a subsection
with: goal, inputs, outputs, and acceptance criteria.
```

**Output:** `PRD.md`

---

## Step 3 — Test Design

Open a **fresh** opencode session. Paste this prompt:

```
Read PRD.md. For each task, propose test cases covering: happy path, edge
cases, bad inputs, and failure modes. Each test must have an explicit input and
expected output. Show me the tests for each task and ask me to confirm or
refine before moving to the next. When all are approved, write tests.md.
```

**Output:** `tests.md`

---

## Step 4 — Implement

Use the **ralph wiggum pattern**: one subagent per task, each starting fresh.

Paste this prompt into opencode (adapt the skill-specific lines):

```
Read PRD.md, tests.md, progress.txt, and learning.txt.

If progress.txt does not exist, create it by listing all tasks from PRD.md as
unchecked. If learning.txt does not exist, create it empty.

Select the next incomplete task from progress.txt.

Execute the task. Create or edit the relevant files under
.agents/skills/<skill-name>/. Run the relevant tests from tests.md.

Append to learning.txt: what you did, what worked, what failed, what to watch
for next.

Mark the task done in progress.txt with a one-line note.

Stop. Do not proceed to the next task.
```

Run this prompt repeatedly until all tasks in `progress.txt` are marked done.

---

## What You're Building

By the end, your skill directory should contain:

```
.agents/skills/<skill-name>/
  SKILL.md          # agent instructions
  templates/        # output format templates
  tools/            # helper scripts (if needed)
```

Test your finished skill by running it on a real input and checking the output against `tests.md`.

---

## Reference: Existing Skills

Study these before you start — they show the patterns you'll use:

- `.agents/skills/explain-paper/` — simple single-agent skill
- `.agents/skills/literature-review/` — multi-agent loop with shared state
