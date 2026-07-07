---
name: orchestration
description: Multi-agent orchestration discipline — when to spawn subagents vs agent teams vs staying solo, how to write bounded task prompts, effort budgets by complexity, and coordination anti-patterns. Use before fanning work out to agents for research, implementation, reviews, or migrations.
---

# Orchestration

How a lead agent decomposes work across other agents without losing correctness, context, or budget. Companion skills: `fable-mindset` (how each agent should think), `loop-engineering` (recurring autonomous runs).

## Decision Tree — solo, subagent, or team

1. **Stay solo** when the task is under ~3 steps, the file/symbol is already known, or the question is conceptual. Spawning costs more than doing.
2. **Subagent(s)** when only the *result* matters: isolated context, one invocation, condensed report back to the lead. Cheapest multi-agent shape — default.
3. **Agent team** only when workers must *talk to each other* — challenge hypotheses, share discoveries mid-flight, claim tasks from a shared queue. Token cost scales linearly with team size; pay it only when cross-worker discussion is the point.

## Effort Budget by Complexity

Declare the budget in the agent's prompt — over-spawn is the #1 documented failure (50 subagents on a simple query).

- Simple fact-find → 1 agent, 3–10 tool calls
- Comparison / two-sided question → 2–4 agents, 10–15 calls each
- Complex research / broad audit → 10+ agents with explicitly divided scopes
- Parallel sweet spot: 3–5 subagents at a time; each doing 3+ tool calls in parallel internally

## The Bounded Task Prompt

Every delegated task states, explicitly:

1. **Objective** — one concrete outcome, not a theme
2. **Output format** — structure and a hard size cap (condensed 1,000–2,000 tokens; never raw dumps)
3. **Tool guidance** — which tools to use and for what; agents theorize when tools aren't imposed
4. **Boundaries** — what is out of scope, when to stop, what NOT to do

Vague boundaries produce duplicated work and silent gaps between agents. Vague tool descriptions cascade: one team measured −40% completion time just from rewriting them.

## Lead Discipline

- **Delegate, then wait.** The lead doing a worker's task while the worker runs is a documented failure mode — results collide and context forks.
- **Broad then narrow.** Start agents on wide scopes, narrow in follow-up rounds; over-specified first queries miss the target.
- **Tier the models.** Strong lead + cheaper workers beats strong-everything: Anthropic measured Opus lead + Sonnet workers at +90.2% over Opus solo on research evals. Pick worker models by task difficulty, not by habit.
- **Think between results.** Evaluate after each agent report and adjust the plan; don't queue blind follow-ups.
- **Async over blocking.** One slow subagent must not stall the rest — background agents, collect as they land.

## Parallel Safety

- One file / one scope per concurrent worker — parallel writes to the same file are silent overwrites.
- Agents that mutate files in parallel get worktree isolation, no exceptions.
- Before spawning N workers, list the files each will touch; overlap → re-partition or serialize.

## Verification Layer

- **Generator never grades its own homework.** A fresh-context verifier beats self-critique — the generator re-reading its own work inherits its own blind spots.
- Verification criteria must be explicit before the loop starts; generator-verifier cycles with vague criteria oscillate forever.
- Cap the feedback loop: max iterations declared up front.

## Anti-Patterns

- **Over-spawn** — agents without an effort budget multiply; declare call/agent caps in the prompt.
- **Infinite source-hunt** — research agents chasing nonexistent evidence; give explicit "stop after N empty searches" limits.
- **Lead-does-the-work** — see Lead Discipline; wait for the fan-out you paid for.
- **Raw-dump returns** — subagent returns 20k tokens of file contents; enforce the size cap in the prompt.
- **Aggressive compaction** — summarizing away context mid-orchestration loses critical details invisibly; keep load-bearing facts in files, not context.
- **Sequential anchoring** — one agent's early hypothesis steering everyone; for genuinely open questions, run adversarial/competing investigations.
