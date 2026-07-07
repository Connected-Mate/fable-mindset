---
name: loop-engineering
description: Design and run autonomous Claude Code loops safely — the 5-component pattern (Discovery, Handoff, Verification, Persistence, Scheduling), exit gates, budget caps, and guardrails. Use when setting up /loop, /schedule routines, overnight agents, ralph loops, or any recurring self-directed run.
---

# Loop Engineering

From prompting to looping: instead of prompting the model, you build a loop that prompts it. "I don't prompt Claude anymore. I have loops running that prompt Claude." (Boris Cherny). A loop is by design a machine that makes the number of turns large — every design decision below exists to shorten the distance between "mistake happens" and "someone sees it".

Companion skills: `fable-mindset` (how each iteration should think), `orchestration` (how to fan work across agents); this skill covers how the *harness around iterations* is built.

## The 5 Components

Every production loop needs all five. A loop missing one is a demo, not a system.

### 1. Discovery — the loop finds its own work
Work comes from a queue the loop reads, never from a human typing a prompt: CI failures, open issues, TODO files, incoming commits, a backlog markdown.
- Claude Code: a `SKILL.md` or `LOOP.md` freezes project context so every iteration starts from the same ground truth.
- The discovery source must be *finite per iteration* (e.g. "pick the top unclaimed item"), or the loop thrashes.

### 2. Handoff — isolate each unit of work
One git worktree per agent/iteration: separate branch + separate filesystem, zero collisions between parallel workers.
- Claude Code: `Agent(..., isolation: "worktree")`, `EnterWorktree`, or workflow agents with `isolation: 'worktree'`.
- Never let two loop iterations write the same checkout.

### 3. Verification — a separate evaluator, always
"The agent that generated the change should not grade its own homework." A distinct agent (or hook, or CI job) checks tests, diffs, requirements, and failure modes before the result is accepted.
- Claude Code: a custom verifier subagent (`~/.claude/agents/verifier.md`), a `SubagentStop` hook with exit-code 2 blocking, or `/verify`.
- The verifier must be **cheaper and more reliable than the action it verifies** — otherwise the loop just produces wrong answers faster.
- A fresh-context verifier beats self-critique: the generator re-reading its own work inherits its own blind spots.

### 4. Persistence — state on disk, never in context
The model forgets everything between runs. All loop state lives in files: `STATE.md`, a PR description, a DB row. Each iteration reads state, acts, writes state back.
- Claude Code: auto-memory dir, project `STATE.md`, task files, PR bodies via `gh`.
- If an iteration learns something, it isn't learned until it's written to disk.

### 5. Scheduling — a timer or event triggers repetition
Cron, webhook, or interval — not a human pressing enter.
- Claude Code local: `/loop 5m <prompt>` (interval) or `/loop <prompt>` (self-paced via ScheduleWakeup).
- Claude Code cloud: Routines (`/schedule daily PR review at 9am`, managed at claude.ai/code/routines) — runs without the laptop open; triggers: cron / API / GitHub events.
- Set caps (max turns, max tokens, max calls/hour) **before** launch, never after.

## Exit & Safety Patterns

- **Dual exit gate**: stop only when BOTH a natural-language completion heuristic (≥2 independent "done" indicators) AND an explicit signal (`EXIT_SIGNAL: true` written by the agent) agree. Exact string-match alone (`--completion-promise`) is less reliable than a hard iteration cap — always keep the cap.
- **Circuit breaker**: 3 iterations without measurable progress, or 5 iterations hitting the same error → pause the loop (e.g. 30 min) and surface to the human. Never retry-forever.
- **Budget caps first**: max iterations, max tokens, tool whitelist (`ALLOWED_TOOLS`-style) defined before the first run.
- **Human gate — non-negotiable**: merge, deploy, delete, close-issue, send-anything-external always requires explicit human approval. The loop prepares; the human pulls the trigger.
- **Comprehension debt**: unreviewed code accumulates while a loop runs. Schedule human diff-reading as part of the loop's output (PRs, not direct commits), or the codebase becomes unknown to its owner.

## Maturity Ladder

Run every new loop through these stages — never start at L3:
- **L1 Report**: loop only observes and reports (no writes). Validate discovery + verification quality.
- **L2 Assisted**: loop writes code but every result goes through the human gate (PR + verifier verdict attached).
- **L3 Unattended**: only for loops with a proven verifier, hard caps, and reversible outputs.

## Minimal Recipes

Native interval loop:
```
/loop 15m triage new issues in the repo, draft fixes as PRs, never merge
```

Cloud routine (no laptop needed):
```
/schedule weekdays at 8am: review open PRs, run the verifier agent on each, post findings as comments
```

Bare-metal ralph loop (use only with caps + sandbox):
```bash
i=0; while [ $i -lt 20 ]; do cat PROMPT.md | claude -p --max-turns 30; i=$((i+1)); done
```

Parallel batch over worktrees: spawn N agents with `isolation: "worktree"`, one work item each, verifier pass on every result before any merge.

## Reference Implementations

- github.com/frankbria/ralph-claude-code — dual exit gate, circuit breaker, `.ralphrc` caps, tool whitelist
- github.com/cobusgreyling/loop-engineering — `loop-init` scaffold (STATE.md/LOOP.md/loop-budget.md), `loop-audit` readiness score, L1→L3 ladder
- addyosmani.com/blog/loop-engineering — the foundational article
