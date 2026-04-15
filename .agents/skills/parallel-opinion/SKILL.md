---
name: parallel-opinion
description: Run GPT and Claude read-only sidecars in parallel for planning, debugging, and review tasks, then synthesize the results.
---

# Parallel Opinion

Use this skill only when the user explicitly asks for it.

Use it for read-only analysis tasks where independent second opinions are valuable:
- planning
- debugging
- code review and PR review
- architecture and trade-off analysis
- audits

Do not use this skill for direct code writing, implementation, or routine edits.

When using this skill, the caller agent should not do the planning, debugging, or review itself in parallel. The caller's job is to delegate the analysis to `gpt-opinion` and `claude-opinion`, then synthesize their outputs afterward.

## Workflow

1. Confirm the task is analysis-oriented and read-only.
2. Launch both hidden subagents in parallel:
   - `gpt-opinion`
   - `claude-opinion`
3. Pass both subagents the same task statement and the same relevant context.
4. Keep the two analyses independent:
   - neither sidecar should see the other's output
   - neither sidecar should be asked to synthesize
5. Do not perform a separate first-party review, debugging pass, or planning analysis in the caller agent while the sidecars are running.
6. Wait for both results unless one times out or is blocked by permissions.
7. Synthesize the outputs in the parent agent.

## Required Output Shape

Present the final answer with these sections:
1. Consensus
2. Disagreements
3. Unique GPT findings
4. Unique Claude findings
5. Final recommendation

If one sidecar times out or is blocked, say so clearly and continue with the available analysis. Do not fabricate the missing side.

## Prompting Rules

When launching the sidecars:
- give both the same task and the same context
- keep the prompts as symmetric as possible
- keep the task read-only
- ask for concrete findings, risks, and caveats

The point of this workflow is independent parallel analysis followed by synthesis in the parent agent.
