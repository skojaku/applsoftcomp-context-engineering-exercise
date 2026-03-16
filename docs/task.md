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

Write a prompt that:
1. Points the agent to `PRD.md`
2. Asks it to propose test cases per task (happy path, edge cases, bad inputs, failure modes), each with explicit input and expected output
3. Asks the agent to show you each task's tests and wait for your approval before moving on
4. Writes the approved tests back into `PRD.md`

**Output:** `PRD.md` (updated with test cases)


git commit the updated PRD.md.

## Step 4: Implement (Ralph Wiggum Pattern)

Let's implement the plan using the Ralph Wiggum pattern. The idea: instead of one agent trying to do everything, we spawn a fresh agent for each task. Each agent has no memory of previous agents, so it cannot drift. The only memory is in shared files that carry forward what matters (e.g., `learning.txt` and `progress.txt`).

See [`.agents/skills/literature-review/SKILL.md`](../.agents/skills/literature-review/SKILL.md) for an example.

### How it works

- **Lead Agent:** a loop controller. It initializes shared files on first run, spawns one sub-agent per task via the Task tool, waits, then repeats until done.
- **Sub-Agent:** spawned fresh each time via the Task tool. It has no memory of previous agents. Its prompt must be fully self-contained.
- **Shared files:** the only memory between agents. Typically `progress.txt` (what is done) and `learning.txt` (lessons learned).

### Checklist for the implementation prompt

When writing the implementation prompt for the sub-agent, make sure to cover: 

- [ ] **Shared files:** What files do agents communicate through? For each: who reads it, who writes it, what does it contain?
- [ ] **Initialization:** The files do not exist on first run. What does the Lead Agent create, and what does it put in them?
- [ ] **Lead Agent loop:** Write the loop as a numbered list. When does it spawn? When does it stop?
- [ ] **Sub-Agent steps:** The sub-agent knows nothing. Write every step:
   - Which files does it read, and why?
   - How does it pick which task to do?
   - What does it produce?
   - How does it verify its work against the tests in `PRD.md`?
   - What does it write to `learning.txt`? Be specific about what kind of information belongs there.
   - How does it mark the task done?
   - How does it ensure it stops after one task?
- [ ] **Stop conditions:** When is the whole skill complete? What happens on repeated failure?

If you cannot answer a question, your `PRD.md` is not specific enough. Go back to Step 2.

## Validation 

Run your skill on the tests you designed. Fix the skill until you are satisfied with the results. 

> [!TIP]
> Shorter instruction is better, not just for the agent, but also for you for readability and maintainability. Too long instruction is hard to understand and hard to maintain. This echoes the principle of ["Documentation is automation"](https://cacm.acm.org/practice/documentation-is-automation/).
>
> If the prompt is exceeding 150 lines (my rule-of-thumb), consider creating templates for parts or use tools to automate parts of the process.
>
> Putting `Sacrifice grammer` is effective in condensing instructions. Agents tend to follow grammer rules too strictly, which can lead to unnecessary verbosity. By explicitly allowing the agent to sacrifice grammar, you can encourage it to be more concise and to the point, which is often more effective for task-oriented prompts.

 
