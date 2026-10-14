# Experiment003B — prepared arrival/wait test

2026-10-13. Preparation complete; user-run gameplay test pending. Read [Experiment003B report](../experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md) and `agent/STATE.md`. User reports002/003 verified in-game;003 reaches region67676767 then wanders and returns. Preserve003 as the rollback baseline.

Separate outputs are under `TestingAI/build/experiment003b/`. Staged root `deployment/arrival-wait/` has Lua hash `D9EE71C57520B597CFCD9399A899DBBE241DFF2DE505F28A07523C3044F0BFCB` and unchanged003 map hash `605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD`. Only main Activate/Update differ; remaining25 executable functions match003. Compile/header/source/archive metadata/payload checks and six mocked-engine actual-Lua callback cases pass.140 earlier build files preserved. Do not rebuild over existing outputs.

Policy: parent-goal slot0 MOVING→ARRIVED→WAITING; arrival distance<=0.5 clears ApproachTarget and queues renewable one-second Wait/TARGET_SELF. Parent Update returnsContinue. Queue exhaustion outside arrival becomes INCOMPLETE_HOLD, not arrival. No automatic retries/reapproach, hostility/faction change, native hook, new XYZ endpoint or command receiver. Lifecycle mechanism source-backed externally; exact runtime cause and003B success unverified.

User-run helper `modengine-test.ps1` is syntax-checked only; no external actions executed. It accepts only the hash-pinned verified003 pair as Backup/rollback baseline and does not launch or modify configuration. Report contains exact003→003B→003 sequence,90second wait observation, failure criteria and rollback. Do not run live actions automatically.

Next: receive user's gameplay result. Stable waiting without arrival is not success. Future command reception remains a later separate experiment; keeping Update active is only a plausible foundation. Native/state preemption, aggro loss and guard/animation effects still need observation. No game/Git/installed edits performed during preparation; original003 reports/artifacts remain unchanged.
