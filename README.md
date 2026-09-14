# ScholarChain

An AWS-based scholarly intelligence system designed, generated, deployed, and evaluated
through a controlled AI agentic workflow.

## What it does

ScholarChain ingests the [DBLP XML publication dataset](https://dblp.uni-trier.de/xml/),
links DBLP records to SemanticScholar, OpenAlex, CrossRef, and ORCID, and builds a
heterogeneous research graph that runtime AI agents query to produce evidence-backed
research briefings.

**Processing pipeline:**

1. **Hadoop MapReduce on Amazon EMR** — parse, normalize, block, and join publication records
2. **Apache Spark on Amazon EMR** — construct the research graph, compute PageRank and community
   detection, generate paper embeddings via Amazon Bedrock
3. **Loaders** — bulk-load the graph into Amazon Neptune, Amazon DynamoDB, Amazon S3,
   Amazon S3 Vectors, and optionally Amazon OpenSearch Service
4. **Runtime AI agents** — Retriever, Ranker, Verifier, and Briefer query Neptune and S3 Vectors
   for evidence and call Bedrock Claude to produce cited briefings

## How it is built

The implementation is produced through a **repository-defined AI agentic workflow**
modelled on [AgenticScalaAppTutorial](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial).
Students act as architects, reviewers, and ratifiers. They provide intent, phase prompts,
acceptance criteria, and human approvals. A main Claude Code session orchestrates;
specialized subagents under `.claude/agents/` own disjoint artifact classes.

| Agent | Owns |
|---|---|
| `factory-engineer` | `.claude/**`, `CLAUDE.md`, `docs/agents.md` |
| `build-engineer` | `build.sbt`, `project/*`, `.scalafmt.conf`, `.gitignore` |
| `data-engineer` | `mapreduce/src/**` (Hadoop MapReduce jobs) |
| `spark-engineer` | `spark/src/**` (Spark graph + analytics + embeddings) |
| `graph-loader` | `loaders/src/**` (Neptune / DynamoDB / S3 / S3 Vectors / OpenSearch) |
| `ai-agent-engineer` | `agents/src/**` (Retriever, Ranker, Verifier, Briefer) |
| `test-engineer` | `*/src/test/**` |
| `infra-engineer` | `infra/terraform/**`, `scripts/*.sh`, `.github/workflows/**` |
| `code-reviewer` | reviews only — no writes |
| `dependency-updater` | version ledger vals in `build.sbt` only |
| `incident-responder` | `docs/incidents/**` |

See [`docs/agents.md`](docs/agents.md) for the full ownership map, lifecycle table, and
escalation policy.

## Quick-start commands

```bash
sbt check                            # format-check + compile + test (definition of done)
sbt assembly                         # fat JAR for MapReduce jobs
sbt sparkAssembly                    # fat JAR for Spark jobs
./scripts/emr-submit-mapreduce.sh    # submit MapReduce job to EMR
./scripts/emr-submit-spark.sh        # submit Spark job to EMR
./scripts/loader-run.sh neptune      # run Neptune loader
./scripts/agent-smoke-test.sh        # end-to-end smoke test of AI agent stack
terraform -chdir=infra/terraform plan  # preview infra changes (human applies)
```

## Key design decisions

- **Stateless, idempotent jobs** — every MapReduce and Spark job writes to a versioned S3
  prefix; any phase can be re-run safely.
- **Evidence-first generation** — the AI briefing pipeline requires verified Neptune graph
  evidence before the LLM is called; unverified claims are flagged, not silently dropped.
- **No credentials in source** — all secrets flow through AWS Secrets Manager / SSM at runtime.
- **Human gates** — `terraform apply`, Neptune schema changes, and destructive DML require
  explicit human approval; agents never run them autonomously.
