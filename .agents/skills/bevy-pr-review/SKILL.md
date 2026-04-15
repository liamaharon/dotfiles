---
name: bevy-pr-review
description: Review Bevy and Rust PRs for unnecessary logic duplication, adherence to existing repo conventions, optimization of added systems, and risky new conventions. Use when asked to review gameplay, UI, or engine-facing changes in this codebase or similar Bevy projects.
---

# Bevy PR Review

Review Bevy and Rust changes with a code review mindset.

Primary goals:
- Find unnecessary logic duplication.
- Enforce existing repo conventions before accepting new patterns.
- Flag any newly introduced convention and ask for explicit approval before recommending it.
- Check whether newly added or modified systems are efficient and appropriately scheduled.

## Review Priorities

Present findings first, ordered by severity.

Focus on:
- Bugs and behavioral regressions
- Replay or authoritative-state risks
- Logic duplication and maintainability issues
- Convention drift from the existing codebase
- Performance problems in systems, queries, scheduling, and per-frame work
- Missing or weak verification where changes are risky

Keep summaries brief and secondary to findings.

## Project-Specific Review Rules

Use the repo's `AGENTS.md` as a source of truth.

While reviewing, strongly prefer the following:
- The smallest correct change
- Direct readable flow over new helpers and indirection
- Keeping logic in one function unless reuse is real and justified
- Shared gameplay logic living in `shared/` exactly once when both client and server need it
- No mutation of authoritative gameplay state outside the world-event apply pipeline
- Runtime scheduling metadata kept separate from authoritative world state
- Existing Bevy plugin and system patterns over inventing new abstractions

Do not recommend a new convention just because it is valid Rust or valid Bevy. If the PR introduces a new convention, pattern, helper style, plugin shape, naming style, or architectural rule that is not already established, call it out as an open question and ask whether the team wants to adopt it first.

## Duplication Review Checklist

Look for duplicated logic across:
- `client/`, `server/`, and `shared/`
- multiple systems that perform the same filtering, lookup, or transformation
- UI feature modules that should be using `client/src/ui/ui_kit.rs`
- state transition files that duplicate gameplay checks or derivations
- rendering systems that repeat the same query or world-space calculations

Flag duplication when:
- the same gameplay rule exists in more than one crate
- the same logic is copy-pasted with only naming differences
- a helper exists already and the PR reimplements it elsewhere
- a new abstraction is added but only wraps a single call site with no meaningful reuse

Do not push for abstraction when:
- duplication is tiny and removal would add indirection
- the code is clearer kept inline
- reuse is speculative rather than real

Preferred review framing:
- ask whether shared logic should move into `shared/`
- ask whether an existing `ui_kit` helper should be extended instead of duplicating behavior
- ask whether repeated preconditions or lookups can be hoisted without adding extra layers

## Convention Review Checklist

Check whether the PR follows established repo patterns for:
- crate boundaries: `shared/`, `client/`, `server/`, `web-play/`
- plugin entrypoints named `plugin`
- explicit Bevy system functions instead of inline closure systems
- direct and readable imports instead of long qualified paths when local imports are clearer
- domain naming that matches actual semantics
- Bevy `States`, plugin composition, and focused systems
- `ui_kit` as the home for reusable client UI behavior
- event-sourced world mutation flow
- centralized shared constants for gameplay values

Flag convention drift when the PR:
- introduces a new pattern where an existing one already exists
- adds wrappers, traits, or helpers that hide simple flow without reducing real complexity
- duplicates authoritative facts in parallel state holders
- mutates authoritative state in startup or runtime systems instead of world-event application
- introduces naming that obscures semantics

If a new convention might be reasonable but is not established, do not approve it silently. Raise it explicitly as:
- an open question
- why it differs from current convention
- whether the team wants to standardize on it before merging more of it

## System Performance Checklist

Every time a PR adds or changes a Bevy system, inspect whether it is efficient enough for its schedule.

Check for:
- unnecessary per-frame work in `Update`
- broad queries when a narrower query or filter would do
- repeated expensive lookups that could be gated or hoisted
- systems running while idle when they should be event-driven or state-gated
- repeated entity scans across several systems that could share a narrower trigger or marker
- unnecessary allocations, cloning, or recomputation inside hot systems
- work done every frame for UI or rendering when it only needs to run on state changes
- schedule placement issues that cause redundant reruns or unstable ordering

Prefer patterns already used in the repo, such as:
- singleton queries when the code truly expects one entity/resource
- explicit states and gating instead of always-on polling
- direct systems with clear data access
- avoiding extra indirection unless it removes real duplicated work

Flag as a finding when a system:
- does visible work every frame without a clear reason
- scales poorly with entity count due to avoidable scans
- duplicates filtering logic across systems in a hot path
- performs client-side work that should happen only on meaningful state change

## Bevy 0.18.1 Check

This workspace targets Bevy `0.18.1`.

When reviewing uncertain Bevy APIs or patterns:
- verify against Bevy `0.18.1` docs, not older Bevy examples
- prefer established repo usage if it already matches Bevy `0.18.1`

## Verification Commands: Always Use `crunch`, Never `cargo`

This workspace uses `crunch` instead of `cargo` for all check / test /
clippy / run commands. Plain `cargo check` / `cargo test` / `cargo
clippy` will NOT work reliably in this environment because dependencies
are resolved on a remote host via `crunch`, and the local machine may
not have the toolchain, features, or platform backends required to
compile the workspace (for example, the client crate is wasm-targeted
and does not enable `x11`/`wayland` on Linux, and dependency feature
unification happens on the remote side).

Whenever a review needs to verify a claim by actually building or
testing, use these commands EXACTLY — never substitute `cargo` for
`crunch`:

- Workspace tests: `crunch test --workspace`
- Single-crate tests: `crunch test -p gammafront-shared`
  (or `-p gammafront-client`, `-p gammafront-server`)
- Single-test filter: `crunch test -p gammafront-client --lib hover_tooltip`
- Check a crate: `crunch check -p gammafront-server`
- Strict clippy: `crunch clippy --workspace --all-targets -- -D warnings`
- Narrow clippy: `crunch clippy -p gammafront-client --tests`
- Running the server locally: `crunch run -p gammafront-server`
- Format (this one is the single exception — it stays on cargo because
  it runs purely locally and does not hit the remote compile host):
  `cargo +nightly fmt --all`

The workspace also has a `crunch.toml` at the repo root with the
standard exclude list and defaults. Prefer plain `crunch <subcommand>`
invocations that pick up that config rather than passing overrides on
the command line unless there is a specific reason.

If a `crunch <command>` run fails in a way that looks environmental
(for example, winit "platform not supported" on Linux because the
crate disables `x11`/`wayland`, or a missing `zstd_rust` / `zstd_c`
backend on `bevy_image`), do NOT retry the same command with `cargo`.
Report the failure in the review, include the exact `crunch` command
you ran, and flag whether the problem is a real regression in the PR
or a pre-existing environment issue that the author has a workaround
for (e.g. `--target wasm32-unknown-unknown`, `--features debug`).
Silent fallback to `cargo` hides real regressions and produces
misleading review output.

## Review Output Format

Use this structure:

1. Findings
2. Open questions or convention questions
3. Brief summary of overall risk

For each finding:
- include severity
- include file and line reference when available
- explain why it is a problem
- suggest the smallest change that aligns with current conventions

If no findings are discovered, say so explicitly and still mention:
- any residual performance risk
- any convention question
- any missing verification that limits confidence

## Example Review Prompts To Yourself

- Is this logic duplicated somewhere else already?
- Should this gameplay rule live in `shared/` instead of being repeated?
- Is this new helper actually reducing complexity, or just adding indirection?
- Does this follow an existing plugin, system, UI, or event pattern in the repo?
- Is this PR silently introducing a new convention that should be discussed first?
- Does this system do more work than necessary for its schedule?
- Can this system be gated by state, event, or more precise query filters?
- Is the code optimizing for actual hot-path behavior, not just stylistic neatness?

## Non-Goals

Do not focus mainly on style nits.
Do not recommend broad refactors unless the PR clearly creates a real problem.
Do not invent new conventions during review.
Do not trade simple readable code for abstraction just to remove tiny duplication.
