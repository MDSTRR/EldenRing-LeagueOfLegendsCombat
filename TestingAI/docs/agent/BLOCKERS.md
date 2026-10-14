# Blockers and unresolved evidence

Updated2026-10-13. Experiment003 build/static validation/workspace staging PASS. Previous runtime-compatibility prerequisite explicitly waived by user; not a build blocker.

- User-run offline test pending. Other/Point region67676767 lookup/availability, navmesh reachability, floor projection, arrival tolerance and shared/native reactions unverified.
- Battle callback requires normal battle activation; prototype does not initiate movement from inactive idle AI or implement custom input.
- Earlier workspace map snapshot65183A0F…28CCF7A no longer available. Authenticated Git backup2DDB49F2…0DCB56 recorded separately; current map comparison classified all106 raw differences rather than discarding them. No unexplained existing-entry change remains.
- Installed setup untouched. New two-file helper backs up/restores Lua+map and guards config/launcher/new hashes; external write actions unexecuted. Stop on changed setup/unexpected hash; no forced substitutions.
- Static success does not certify runtime behavior or M1. Need reproducible movement to fixed destination with player elsewhere and rollback returning baseline.

Report/commands: agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md. Active handoff: agent/tempHandoffs/experiment003-continuation.md. No installations/Steam changes/cleanup/Git mutations/game launch/deployment.

## 2026-10-13 — Experiment003B current runtime gate

User reports003 fixed-region movement verified; earlier pre-runtime region blockers are historical for the tested setup.003B arrival/wait is built/staged and statically/mocked-API verified, but untested in-game. Need the user's controlled003→003B→003 test: reach the region first, wait90seconds without wandering/reapproach, then restore003. Shared/native preemption, aggro loss, exact wandering caller and future command reception remain unresolved. No command channel is implemented in003B. [Report](experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md). Do not rerun builds or change the live setup automatically.

## Agent 2 arena prerequisites — 2026-10-13

Arena research complete, implementation unstarted. Need authenticated current-build m13 MSB/EMEVD/NVA/HKX inspection, complete encounter/common-reference audit, humanoid floor connectivity, and isolated Think/battle-goal registration. Published source identifiers are not current-build certification. No free custom IDs or compatible arena destinations certified. Future empty-arena access/return and short soldier route require offline runtime testing; no test performed. [Plan](../docs/arena/ARENA_IMPLEMENTATION_PLAN.md). These are arena prerequisites, not blockers that alter Agent1's003B work.

## Humanoid foundation prerequisites — 2026-10-13

Research completed. Need current-build row-level Buddy/Npc/Think/CharaInit values and effective player-NPC Think precedence before implementation. Friendly idle custom-logic/battle dispatch, isolated registration, absence of follow/dismissal, command replacement and arena navmesh remain unverified. Names labels and shared Lua source do not certify any candidate row mapping. [Comparison/proof](../docs/arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md). No new build/runtime blocker imposed on existing Agent1 experiments.
