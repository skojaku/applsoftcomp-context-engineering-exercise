# Context Engineering Exercise

This repository provides a step-by-step exercise to practice context engineering by building an AI skill from scratch. You will learn: 

1. principles of soft-ware development such as test-driven development and 80/20 planning. 
2. context engineering techniques through ralph wiggum style implementation
3. an end-to-end process for building AI agent skills, from ideation to testing to implementation. 


We will use [opencode](https://opencode.dev/) as our coding environment, but any AI coding tools (e.g., `claude code` ) can be used. For `claude code` users, simply rename `.agents` to `.claude` (ask claude to do so).


## Example skills: 

This repository includes example skills under `.agents/skills/`. Each skill has a `SKILL.md` file with instructions for the agent, and may include templates and tools as needed. 


> [!WARNING]
> Before starting the exercise, please set the LLM to `qwen3.5:35b`, `qwen3.5:397b`, or `glm-5`. 
> These models are accessible through [OpenRouter](https://openrouter.ai/) and [Ollama](https://ollama.com/) for free. If you don't have access to these models, please reach out to the instructor for assistance.
> To set the model, type `/model` and select the appropriate model from the list.

To run, open `opencode` and run:

```md
/skills
```

This will show you the list of available skills (found under `.agents/skills/`). Select:

```bash
/setup
```

This will set up the necessary environment for running the example skills. See [.agents/skills/setup/SKILL.md](.agents/skills/setup/SKILL.md) for details on what the setup does.

Now, let's try running `explain-paper` skill. See [.agents/skills/explain-paper/SKILL.md](.agents/skills/explain-paper/SKILL.md) on the instructions in this skill. 
Ask the agent to explain a paper of your choice in `papers/` folder by providing the file name. For example:

```bash 
Explain papers/brown2020_gpt3_few_shot.pdf
```

Next, try running `literature-review` skill. This skill runs a Ralph Wiggum loop to go through multiple papers and synthesize a literature review. See [.agents/skills/literature-review/SKILL.md](.agents/skills/literature-review/SKILL.md) for instructions. 

To run, just say something like: 

```bash
Literature-review papers in the papers/ folder. 
```

## Your task

Choose one of the following task goals of your choice. 

| Level | Skill | What it does |
|---|---|---|
| ⭐ | `study-notes` | Given a lecture PDF, produce structured notes: key concepts, definitions, practice questions |
| ⭐⭐ | `trip-planner` | Given budget, dates, and group size, plan a trip from Binghamton with itinerary and costs |
| ⭐⭐⭐ | `arxiv-recommender` | Given a research interest or paper abstract, recommend relevant arXiv papers with explanations |

Complete the following steps to build your chosen skill. The steps are designed to be iterative and flexible, so feel free to adapt them as needed while maintaining the core principles of good software development and context engineering.

## Step 1: Vibe coding for prototyping

Open opencode and build a prototype. No planning, no structure.

**Goal:** get a feel for what's hard. Your output will be messy. That's intentional.

## Step 2 — Plan

Remove your prototype (or git add and commit in a branch. Then change the branch and delete it.). 

Open a **fresh** opencode session by running `/new`. 

Paste this prompt and replace `[SKILL]`:

```
I want to build an AI skill called [SKILL] under .agents/skills/<skill-name>. 
Interview me RELENTLESSLY until nothing is ambiguous. 
Ask one question at a time. Ask about inputs, outputs, edge cases, tools needed, and output
format.  Then write PRD.md where each task is a subsection with format as follows: 

'''
## Task <number>: <task name>
- Goal: <what the task achieves>
- Inputs: <what inputs the task takes>
- Outputs: <what outputs the task produces>
- Specification 1:
- Specification 2:
- ...

Test cases:
- Test 1: <description of the test>
- Test 2: <description of the test>
'''
```

**Output:** `PRD.md`

---

## Step 3 — Test Design

Open a **fresh** opencode session. Paste this prompt:

```
Read PRD.md. For each task, propose test cases covering: happy path, edge
cases, bad inputs, and failure modes. Each test must have an explicit input and
expected output. Show me the tests for each task and ask me to confirm or
refine before moving to the next. When all are approved, write it in PRD.md.
```

**Output:** `PRD.md`

---

## Step 4 — Implement

Use the **ralph wiggum pattern**: one subagent per task, each starting fresh.

First, read [.agents/skills/literature-review/SKILL.md](.agents/skills/literature-review/SKILL.md) to understand the pattern — a Lead Agent that loops, spawning one Sub-Agent per task via the Task tool, each reading shared state (`progress.txt`, `learning.txt`) and writing back before stopping.

Then paste this prompt into opencode to write your `SKILL.md` following the same pattern:

```
Read PRD.md and .agents/skills/literature-review/SKILL.md.

Write .agents/skills/<skill-name>/SKILL.md using the ralph wiggum pattern from
literature-review as a reference. The Lead Agent initializes progress.txt and
learning.txt if they don't exist, then spawns one Sub-Agent per task via the
Task tool — waiting for each to finish before spawning the next.

Each Sub-Agent must:
1. Read PRD.md, progress.txt, and learning.txt for context.
2. Select the next incomplete task from progress.txt.
3. Execute the task and run its tests from PRD.md.
4. Append to learning.txt: what was done, what worked, what failed.
5. Mark the task done in progress.txt with a one-line note.
6. Stop. Do not proceed to the next task.

Include stop conditions: all tasks done, repeated failure, or user cancels.
```

Once `SKILL.md` is written, run it. The Lead Agent will work through all tasks automatically.

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
