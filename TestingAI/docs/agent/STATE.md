# Current state

Updated 2026-10-13.

- Research-only assignment completed for GOAL_COMMON_MoveToSomewhere and GOAL_COMMON_MoveFollowPathSpecifyPos. Exact documented slots, alternate typed declarations, target evidence, uncertainties, sources and two proposed minimal experiments are in `RESEARCH.md`.
- Reusable API library created at `docs/api/INDEX.md` with the user's knowledge-management instructions and references for goals, related functions and constants. Check its index before future function research and read only relevant entries.
- MoveToSomewhere has documented target-based pathing semantics. MoveFollowPathSpecifyPos has explicit x/y/z slots, but coordinate frame, route prerequisites and actual behavior remain unresolved.
- Recommended first experiment: Soldier of Godrick walks toward one fixed map region via POINT_EVENT and MoveToSomewhere, using an isolated offline mod override after installation and further instructions. First inspect actual soldier resources and local argument/default handling.
- Game is downloading; local game files are unavailable. Soldier identifiers/scripts and installed build are not verified. No gameplay modifications, controller code or in-game tests were made. M1 remains unachieved.
- No movement architecture selected. User-controlled documents remain unchanged.
- Active handoffs: none for this completed assignment. `tempHandoffs/handoff001.md` describes an earlier, broader AI-resource investigation; its resource-identification work is deferred pending installation, not completed here.
- Stop and wait for further user instructions. Do not implement experiments or advance to dynamic input/combat work.
