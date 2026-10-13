# Codex Agent Instructions

## Authority Hierarchy

This project separates user-defined requirements from agent-maintained working memory.

### User-Controlled Files

The following files are authoritative:

- `user/VISION.md`
- `user/REQUIREMENTS.md`
- `user/DECISIONS.md`
- `AGENTS.md`

These files must never be modified by the agent without explicit user authorization.

The agent must not reinterpret, silently remove, or override user requirements.

If requirements conflict, report the conflict and request clarification.

### Agent-Controlled Files

The agent may independently maintain:

- `agent/STATE.md`
- `agent/PROGRESS.md`
- `agent/RESEARCH.md`
- `agent/EXPERIMENTS.md`
- `agent/BLOCKERS.md`

These files serve as persistent working memory between Codex sessions.

The agent may update them without asking permission.

Agent-maintained documentation is informative, not authoritative. It cannot override user instructions.

## Context Efficiency

- Always consult `agent/STATE.md` for the current project state.
- Follow the authoritative requirements in `user/`.
- Read detailed research, experiments, and technical documentation only when relevant to the current task.
- Prefer targeted searches within large files instead of reading entire documents.
- Avoid rereading unchanged documentation unnecessarily within the same session.
- Keep `agent/STATE.md` concise, ideally under 300 words.
- Preserve detailed findings in dedicated research files rather than duplicating them in `STATE.md`.
- Update agent-maintained documentation at the end of substantial work sessions.

## Temporary Session Handoffs

- Use `agent/tempHandoffs/` to preserve detailed context for unfinished tasks.
- Create a handoff when a task must continue in another Codex session.
- At session startup, consult `agent/STATE.md` to identify the relevant active handoff.
- Read only the relevant handoff, not the entire directory.
- A handoff must include completed work, modified files, unresolved problems, and next actions.
- Transfer important discoveries into permanent research documentation.
- When a task is completed, mark its handoff as completed and remove it from the active handoff list in `STATE.md`.
- Do not treat temporary handoffs as authoritative project requirements.

### Technical Documentation

The agent may maintain files under `docs/`.

Every documented Elden Ring-specific API should include:

- Function name
- Source URL or source file
- Known parameters
- Known constraints
- Game version, when relevant
- Verification status

Do not present assumptions as verified facts.

## Technical Knowledge Management

The `docs/api/` directory is the project's reusable technical reference library.

When discovering an Elden Ring function, AI goal, event instruction, or constant:

1. Record investigation details and evidence in `agent/RESEARCH.md`.
2. Add reusable function documentation to the appropriate file under `docs/api/`.
3. Record the exact name, signature, parameters, purpose, usage examples, source references, and verification status.
4. Clearly distinguish documented behavior from hypotheses and locally verified behavior.
5. Never invent undocumented parameters, default values, or function signatures.
6. Cross-reference related functions and constants where relevant.
7. Update `docs/api/INDEX.md` when adding a new function.
8. Do not duplicate existing entries. Update them with new evidence instead.
9. Do not treat the existence of a documented function as proof that it works in the current Elden Ring build.

Before researching a function, check `docs/api/INDEX.md` to determine whether it has already been documented.

Read only the API reference files relevant to the current assignment. Do not load the entire reference library at every session startup.

## Session Startup Procedure

At the beginning of every new task:

1. Read `user/VISION.md`.
2. Read `user/REQUIREMENTS.md`.
3. Read `user/DECISIONS.md`.
4. Read `agent/STATE.md`.
5. Consult relevant research and documentation.
6. Continue from the latest verified project state.

## Session Completion Procedure

Before ending a substantial work session:

1. Update `agent/STATE.md` with the current state.
2. Update `agent/PROGRESS.md` with completed work.
3. Record new discoveries in `agent/RESEARCH.md`.
4. Record experiment results in `agent/EXPERIMENTS.md`.
5. Update `agent/BLOCKERS.md`.
6. Identify the next actionable step.

Keep documentation concise and avoid duplicating information.

## Development Rules

- Preserve original Elden Ring files.
- Test gameplay modifications offline.
- Prefer small, reversible experiments.
- Never invent undocumented Elden Ring APIs.
- Distinguish verified findings from hypotheses.
- Do not claim successful in-game testing without evidence.
- Ask before changing project scope or architecture.
- Do not modify user-controlled files without permission.

## Primary Objective

Follow the project goals and constraints defined in the user-controlled files.

The agent's responsibility is to implement those goals, investigate technical obstacles, and preserve useful context across sessions.