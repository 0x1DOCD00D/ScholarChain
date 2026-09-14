# Agent team, artifact ownership, and escalation

This repo is operated — and will be CREATED — by a team of Claude Code subagents defined
in `.claude/agents/`. Every artifact class has exactly one creating/owning agent; nothing
in this repository is hand-written except ratification decisions. Delegate to the owner;
never perform a specialty inline in the main context.

## Artifact ownership map (one writer per artifact class)

| Artifact class | Created & owned by | Version bumps by | Gated by |
|---|---|---|---|
| `.claude/**`, `CLAUDE.md`, `docs/agents.md` | **factory-engineer** | — | HUMAN ratification (constitutional) + code-reviewer |
| `build.sbt`, `project/*`, `.scalafmt.conf`, `.gitignore` | **build-engineer** | **dependency-updater** (version vals only) | code-reviewer + `sbt check` |
| `mapreduce/src/**` (Hadoop MapReduce jobs — parse, normalize, block, join) | **data-engineer** | — | test-engineer, code-reviewer, `sbt check` |
| `spark/src/**` (Apache Spark graph construction, analytics, embedding) | **spark-engineer** | — | test-engineer, code-reviewer, `sbt check` |
| `loaders/src/**` (Neptune, DynamoDB, S3, S3 Vectors, OpenSearch loaders) | **graph-loader** | — | test-engineer, code-reviewer, `sbt check` |
| `agents/src/**` (runtime AI agents: Retriever, Ranker, Verifier, Briefer) | **ai-agent-engineer** | — | test-engineer, code-reviewer, `sbt check` |
| `src/test/**`, `mapreduce/src/test/**`, `spark/src/test/**`, `loaders/src/test/**`, `agents/src/test/**` | **test-engineer** (and owner, tests shipped with features) | — | code-reviewer |
| `infra/terraform/**`, `scripts/*.sh`, `.github/workflows/**` | **infra-engineer** | — | `terraform plan` read by HUMAN who applies; code-reviewer |
| `docs/incidents/**` | **incident-responder** | — | — |

## Lifecycle → agent map

| Lifecycle stage | Agent | Trigger |
|---|---|---|
| Bootstrap / evolve the factory | **factory-engineer** | new agent, hook, permission, MCP server |
| Create / change the build | **build-engineer** | new project, new dependency, packaging change |
| Design / plan | (main context, plan mode) | new feature request |
| DBLP parse, normalize, block, join (MapReduce) | **data-engineer** | approved MapReduce plan |
| Research graph construction + analytics (Spark) | **spark-engineer** | approved Spark plan |
| Neptune / DynamoDB / S3 / S3-Vectors / OpenSearch load | **graph-loader** | approved loader plan |
| Runtime AI retrieval, ranking, verification, briefing | **ai-agent-engineer** | approved agent plan |
| Test | **test-engineer** | after each implementation phase, before review |
| Review | **code-reviewer** | before every commit / PR |
| Infra / pipelines / scripts | **infra-engineer** | any Terraform / script / workflow change |
| Monitor / diagnose | **incident-responder** | alarms, smoke-test failures, `/incident` |
| Maintain versions | **dependency-updater** | weekly schedule or CVE notice |

## Escalation policy

- incident-responder may restart and scale autonomously; anything touching data or security
  surfaces to a human first.
- graph-loader prepares Neptune schema and loader scripts; a human reviews and approves
  before any live-cluster execution.
- infra-engineer produces plans; a human runs `terraform apply`.
- factory-engineer prepares constitutional diffs; a human ratifies before they take effect.
- Any agent asked to work outside its ownership row declines and names the owner.
