# Fable Mindset

> **Fable is not here — use the same logic as Fable, for free.**

Claude Fable 5 was available for a window. The model goes away; the way it works doesn't have to.

Fable Mindset is Fable 5's working discipline — how it decomposes hard tasks, verifies its own work, orchestrates subagents, and runs autonomous loops — written down **by Fable 5 itself** as portable skill files. Load them into Claude Code (or paste them into any capable model's system prompt) and your daily model inherits the habits, if not the raw horsepower.

No API keys. No dependencies. No telemetry. Just Markdown.

## What's inside

| File | What it teaches |
|---|---|
| [`skills/fable-mindset/SKILL.md`](skills/fable-mindset/SKILL.md) | The core reasoning discipline: decompose by dependency, kill the load-bearing unknown first, verify before "done", audit every claim against a tool result, and a hard pre-report checklist |
| [`skills/orchestration/SKILL.md`](skills/orchestration/SKILL.md) | Multi-agent fan-out: subagent vs agent-team vs solo decision tree, bounded task prompts, effort budgets by complexity, parallel-safety rules, coordination anti-patterns |
| [`skills/loop-engineering/SKILL.md`](skills/loop-engineering/SKILL.md) | Autonomous recurring runs: the 5-component loop pattern (Discovery, Handoff, Verification, Persistence, Scheduling), dual exit gates, circuit breakers, the L1→L3 maturity ladder |
| [`agents/verifier.md`](agents/verifier.md) | A ready-made independent evaluator subagent — because the agent that generated a change should never grade its own homework |

The three skills cross-reference each other: *fable-mindset* is how one agent thinks, *orchestration* is how work fans out across agents, *loop-engineering* is how the whole thing runs on a timer.

## Install

### Claude Code

```bash
git clone https://github.com/Connected-Mate/fable-mindset.git
cd fable-mindset
./install.sh
```

This copies the skills to `~/.claude/skills/` and the verifier agent to `~/.claude/agents/`. They register automatically — invoke with `/fable-mindset`, `/orchestration`, `/loop-engineering`, or spawn the `verifier` agent after any implementation.

To make the discipline non-optional, add two lines to your `~/.claude/CLAUDE.md`:

```markdown
# Hard-task discipline
Multi-step task → invoke /fable-mindset before starting. Before declaring "done" → run its "Before Reporting Done" checklist.
```

### Any other model or tool

The files are plain Markdown. Paste the body of a `SKILL.md` into your system prompt, custom instructions, or agent definition. The patterns are model-agnostic by design.

## What transfers — and what doesn't

Honesty over hype. These files transfer the **method**, not the model:

**Transfers well** (verified against Anthropic's published guidance):
- Auditing every progress claim against an actual tool result — the single habit Anthropic found "nearly eliminated fabricated status reports"
- Fresh-context verifier over self-critique — architectural, works in any multi-agent stack
- Explicit boundaries ("do only what was asked") — universal
- Decomposition toward an observable end-state, dependency-ordered
- Persistence discipline: state on disk, one file per lesson

**Does not transfer:**
- Raw capability. A skill file will not make a smaller model reason like a Mythos-class one.
- Effort-level claims ("high on Fable beats xhigh on prior models") — that's model capability, recalibrate empirically on whatever you run.
- On weaker models, goal-level (rather than step-level) instructions can under-specify — add back detail where your model needs it.

## Sources

Patterns distilled from working sessions with Claude Fable 5, cross-checked against public documentation:

- [Introducing Claude Fable 5 and Claude Mythos 5](https://www.anthropic.com/news/claude-fable-5-mythos-5) — Anthropic
- [Prompting Claude Fable 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5) — Anthropic ("Skills developed for prior models are often too prescriptive for Claude Fable 5")
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) — Anthropic
- [Claude Code: subagents](https://code.claude.com/docs/en/sub-agents) and [agent teams](https://code.claude.com/docs/en/agent-teams) — Anthropic
- [Loop Engineering](https://addyosmani.com/blog/loop-engineering/) — Addy Osmani

## License

MIT © 2026 Alexandre Cormeraie / ConnectedMate
