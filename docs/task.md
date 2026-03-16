# Your Task

Choose a skill to build:

| Level | Skill | What it does |
|---|---|---|
| ⭐ | `study-notes` | Given a paper PDF, produce structured notes with key concepts, definitions, and practice questions |
| ⭐⭐ | `trip-planner` | Given budget, dates, and group size, plan a trip from Binghamton with itinerary and costs |
| ⭐⭐⭐ | `arxiv-recommender` | Given a research interest or paper abstract, recommend relevant arXiv papers with explanations |


## Step 1: Vibe

Build a rough prototype with no planning. Goal: get a feel for what is hard. The output will be messy. That is intentional.

> [!TIP]
> Instruct agents to make atomic commit with clear message after each task. The git log then becomes a second-brain of the agent, recording what was done, when, and why. It also allows you to easily roll back if something goes wrong. Agents may also remove some files accidentally. So keeping track of changes with git is crucial for agentic coding. 


## Step 2: Plan

Let's create a clear, unambiguous specification for the skill. This is the most important step.
Every ambiguity left unresolved becomes a silent decision the agent makes during implementation, usually wrong.

Discard the prototype. Open a fresh session (`/new`).

Paste this prompt (replace `[SKILL]` and `[SKILL-NAME]`):

```
I want to build an AI skill called [SKILL] under .agents/skills/[SKILL-NAME].
Interview me RELENTLESSLY until nothing is ambiguous.
Ask one question at a time. Cover inputs, outputs, edge cases, tools, and output format.
Then write PRD.md with overview and each task as a subsection. The subsection of each task should be:

## Task <N>: <name>
- Goal:
- Inputs:
- Outputs:
- Specification 1:
- Specification 2:
```

**Output:** `PRD.md`

git commit the PRD.md. 

---

## Step 3: Test Design

Let's build a set of tests to hammer on the implementation before actually implementing it! 
With tests, we create a feedback loop for the agents, and agents can learn from their mistakes without human intervention.

Open a fresh session.

Paste this prompt:

```
Read PRD.md.

For each task, propose test cases covering: happy path, edge cases, bad inputs,
and failure modes. Each test case must include an explicit input and expected output.

Show me the tests for one task at a time and ask for my approval before moving on.
Refine any test I reject before proceeding.

Once all tests are approved, add them to each task's subsection in PRD.md.
```

**Output:** `PRD.md` (updated with test cases)


git commit the updated PRD.md.

## Step 4: Implement (Ralph Wiggum Pattern)

Write a prompt to implement the plan based on the Ralph Wiggum loop. Your prompt must: 
1. instruct the agent to spawn a fresh sub-agent for each task, with no memory of previous agents
2. specify the shared files for communication between agents (e.g., `learning.txt` and `progress.txt`)
3. write the loop for the Lead Agent, including when to spawn and when to stop
4. write the steps for the Sub-Agent, including how it picks a task, what it produces, how it verifies its work against the tests in `PRD.md`, what it writes to `learning.txt`, how it marks the task done, and how it ensures it stops after one task
5. specify the stop conditions for the whole skill, and what happens on repeated failure

See [`.agents/skills/literature-review/SKILL.md`](../.agents/skills/literature-review/SKILL.md) for an example.


> [!NOTE] 
> How Ralph Wiggum Pattern works:
> - **Lead Agent:** a loop controller. It initializes shared files on first run, spawns one sub-agent per task via the Task tool, waits, then repeats until done.
> - **Sub-Agent:** spawned fresh each time via the Task tool. It has no memory of previous agents. Its prompt must be fully self-contained.
> - **Shared files:** the only memory between agents. Typically `progress.txt` (what is done) and `learning.txt` (lessons learned).


## Validation 

Run your skill on the tests you designed. Fix the skill until you are satisfied with the results. 

> [!TIP]
> Shorter instruction is better, not just for the agent, but also for you for readability and maintainability. Too long instruction is hard to understand and hard to maintain. This echoes the principle of ["Documentation is automation"](https://cacm.acm.org/practice/documentation-is-automation/).
>
> If the prompt is exceeding 150 lines (my rule-of-thumb), consider creating templates for parts or use tools to automate parts of the process.
>
> Putting `Sacrifice grammer` is effective in condensing instructions. Agents tend to follow grammer rules too strictly, which can lead to unnecessary verbosity. By explicitly allowing the agent to sacrifice grammar, you can encourage it to be more concise and to the point, which is often more effective for task-oriented prompts.

 
