# Current state

Updated 2026-10-13. User reports Experiments002 and003 verified in-game.003 reaches custom region67676767, then wanders without attacking and returns. Preserved003 as the baseline.

-003B prepared separately: only main Activate/Update differ from003;25 other functions including Interrupt remain identical. No faction/hostility/native-hook/XYZ changes.
- Parent-goal slot0 tracks MOVING→ARRIVED→WAITING. At POINT_EVENT distance<=0.5, clear movement and renew one-second Wait/TARGET_SELF while returning Continue. Empty queue away from point enters INCOMPLETE_HOLD, not false arrival. No automatic reapproach after waiting.
- Source evidence: published ER Update_Default_NoSubGoal returns Success on queue exhaustion; ApproachTarget delegates guard/lifetime behavior. Exact engine cause of wandering remains an inference, not a traced runtime result.
- Build/archive/static readback pass;27 functions, changed indices2/22. Six actual-Lua callback tests pass with mocked engine APIs. All140 earlier Experiment001/002/003 build files preserved.
-003B Lua archive hashD9EE71C57520B597CFCD9399A899DBBE241DFF2DE505F28A07523C3044F0BFCB; map remains605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD.
- Staged root: TestingAI/build/experiment003b/deployment/arrival-wait. Report: agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md. Separate helper requires pinned003 rollback baseline; syntax checked only.
- Runtime003B, parent/state preemption and future command reception remain unverified. No command transport introduced; no live deployment/game launch/tool installation/Git changes.
- Next: user-run003→003B→003 test, including arrival then90seconds positional waiting. Active handoff: agent/tempHandoffs/experiment003b-continuation.md. No autonomous live actions or unnecessary rebuilds.

Arena research (Agent2) complete; no implementation. [Findings/plan](../docs/arena/PLACIDUSAX_ARENA_FEASIBILITY.md): m13 encounter/access identifiers source-confirmed; current-build audit and humanoid nav coverage unresolved. Next: read-only local audit, then separately authorized empty-arena and short-route tests. Existing experiments remain Agent1-owned.

Agent2 [humanoid comparison](../docs/arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md) complete, research only. Keep Godrick as current control; propose fixed-equipment c0000 map-NPC proof before permanent adoption. Actual candidate Think mappings and friendly idle custom-AI dispatch remain unresolved; Mimic copying deferred. Existing experiments/arena artifacts untouched.
