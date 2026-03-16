# Your Task

Choose a skill to build:

| Level | Skill | What it does |
|---|---|---|
| ⭐ | `study-notes` | Given a lecture PDF, produce structured notes with key concepts, definitions, and practice questions |
| ⭐⭐ | `trip-planner` | Given budget, dates, and group size, plan a trip from Binghamton with itinerary and costs |
| ⭐⭐⭐ | `arxiv-recommender` | Given a research interest or paper abstract, recommend relevant arXiv papers with explanations |

---

## Step 1: Vibe

Build a rough prototype with no planning. Goal: get a feel for what is hard. The output will be messy. That is intentional.

---

## Step 2: Plan

Discard the prototype. Open a fresh session (`/new`).

> [!NOTE]
> Fresh context forces you to articulate your idea explicitly. Vague plans produce vague output. Every ambiguity left unresolved becomes a silent decision the agent makes during implementation, usually wrong.

Write a prompt that:
1. States what skill you are building and where it lives
2. Instructs the agent to interview you one question at a time until nothing is ambiguous (inputs, outputs, edge cases, tools, format)
3. Specifies the output format: ask the agent to write `PRD.md` where each task is a subsection with goal, inputs, outputs, and specifications

**Output:** `PRD.md`

---

## Step 3: Test Design

Open a fresh session.

> [!NOTE]
> Tests define "done" without ambiguity. Without them, the agent decides for itself when a task is complete.

Write a prompt that:
1. Points the agent to `PRD.md`
2. Asks it to propose test cases per task (happy path, edge cases, bad inputs, failure modes), each with explicit input and expected output
3. Asks the agent to show you each task's tests and wait for your approval before moving on
4. Writes the approved tests back into `PRD.md`

**Output:** `PRD.md` (updated with test cases)

---

## Step 4: Implement (Ralph Wiggum Pattern)

> [!NOTE]
> One agent runs too long and drifts. The Ralph Wiggum pattern fixes this: one sub-agent per task, each starting fresh. Shared files carry only what matters forward.

### How it works

- **Lead Agent:** a loop controller. It initializes shared files on first run, spawns one sub-agent per task via the Task tool, waits, then repeats until done.
- **Sub-Agent:** spawned fresh each time via the Task tool. It has no memory of previous agents. Its prompt must be fully self-contained.
- **Shared files:** the only memory between agents. Typically `progress.txt` (what is done) and `learning.txt` (lessons learned).

### Writing your SKILL.md

Read [`.agents/skills/literature-review/SKILL.md`](../.agents/skills/literature-review/SKILL.md) as a reference, then write `.agents/skills/<skill-name>/SKILL.md` by answering these questions:

1. **Shared files:** What files do agents communicate through? For each: who reads it, who writes it, what does it contain?
2. **Initialization:** The files do not exist on first run. What does the Lead Agent create, and what does it put in them?
3. **Lead Agent loop:** Write the loop as a numbered list. When does it spawn? When does it stop?
4. **Sub-Agent steps:** The sub-agent knows nothing. Write every step:
   - Which files does it read, and why?
   - How does it pick which task to do?
   - What does it produce?
   - How does it verify its work against the tests in `PRD.md`?
   - What does it write to `learning.txt`? Be specific about what kind of information belongs there.
   - How does it mark the task done?
   - How does it ensure it stops after one task?
5. **Stop conditions:** When is the whole skill complete? What happens on repeated failure?

If you cannot answer a question, your `PRD.md` is not specific enough. Go back to Step 2.

### Expected output

```
.agents/skills/<skill-name>/
  SKILL.md
  templates/
  tools/
```

Run the skill on a real input and verify the output against the tests in `PRD.md`.
