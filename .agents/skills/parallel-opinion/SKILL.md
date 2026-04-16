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

## Parent Orchestration Rules

While using this skill:
- do not load task-specific review skills in the parent agent before launching the sidecars
- do not perform your own Rust, Bevy, debugging, or verification analysis before the sidecars return
- let each sidecar independently decide whether to load its own applicable skills based on the task
- keep the parent agent in orchestration mode only until both sidecar results are available
- only after both sidecars return should the parent synthesize their outputs

## Prompting Rules

When launching the sidecars:
- give both the same task and the same context
- keep the prompts as symmetric as possible
- keep the task read-only
- ask for concrete findings, risks, and caveats
- preserve the sidecars' exact section structure when possible
- do not ask them to inspect or summarize each other's outputs
- do not pre-load skills in the parent as a substitute for child-side skill loading

## Synthesis Rules

When synthesizing:
- treat each sidecar's "My wrong turns and course corrections" section as supplemental signal, not the main result
- use course corrections to understand reliability, dead ends, and what changed during each sidecar's analysis
- do not invent hidden transcript details that were not included in the child outputs
- if a sidecar reports "None material", say so briefly and move on
- if a sidecar timed out or was blocked, say so clearly and continue with the available analysis

## Required Output Shape

Present the final answer with these sections:
1. Consensus
2. Disagreements
3. Unique GPT findings
4. Unique Claude findings
5. Sidecar course corrections
6. Final recommendation

The point of this workflow is independent parallel analysis followed by synthesis in the parent agent.
