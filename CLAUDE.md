# ScholarChain — project memory for Claude Code

ScholarChain is an AWS-based scholarly intelligence system that starts with the DBLP XML
publication dataset, links it to other open scholarly datasets, processes it through
Hadoop MapReduce and Apache Spark, loads the result into Amazon Neptune, DynamoDB, S3,
S3 Vectors, and optionally OpenSearch, and then serves runtime AI agents that retrieve
graph and vector evidence and ask an LLM to produce an evidence-backed research briefing.

The entire implementation is generated through an AI agentic workflow modelled on
AgenticScalaAppTutorial. Students act as architects, reviewers, and ratifiers; they supply
intent, phase prompts, acceptance criteria, and human approvals. A main Claude Code session
orchestrates; specialized subagents under `.claude/agents/` own disjoint artifact classes.

## System architecture

```
DBLP XML (S3)
   │
   ▼
Hadoop MapReduce (Amazon EMR)
   ├── Phase 1: XML parse → normalised publication records (S3 Parquet)
   ├── Phase 2: Record blocking (title n-gram / author surname)
   └── Phase 3: Join to SemanticScholar, OpenAlex, CrossRef, ORCID datasets
   │
   ▼
Apache Spark (Amazon EMR)
   ├── Heterogeneous research graph construction
   │     nodes: Author, Paper, Venue, Topic, Dataset, Affiliation
   │     edges: authored_by, cites, published_in, has_topic, affiliated_with
   ├── Graph analytics: PageRank, community detection, citation-path extraction
   └── Embeddings: per-paper text → float32 vectors via Bedrock Titan
   │
   ▼
Loaders (EMR / Lambda)
   ├── Neptune (property graph via Gremlin bulk loader)
   ├── DynamoDB (author and paper lookup tables)
   ├── S3 (normalised Parquet, analytics output)
   ├── S3 Vectors (paper embedding index)
   └── OpenSearch (full-text paper index, optional)
   │
   ▼
Runtime AI agents (Lambda / ECS)
   ├── Retriever  — Neptune Gremlin + S3 Vectors ANN search
   ├── Ranker     — score and deduplicate evidence
   ├── Verifier   — fact-check claims against graph edges
   └── Briefer    — calls Bedrock Claude to produce evidence-backed briefing
```

## Artifact ownership (one writer per class — enforce strictly)

See `docs/agents.md` for the full ownership map and lifecycle table.

## Commands

- `sbt assembly` — build fat JAR for Hadoop MapReduce jobs.
- `sbt sparkAssembly` — build fat JAR for Spark jobs.
- `sbt test` — run unit tests (no AWS, no cluster).
- `sbt check` — scalafmtCheckAll + compile + test + markTestRun (definition of done).
- `./scripts/emr-submit-mapreduce.sh` — submit MapReduce job to EMR.
- `./scripts/emr-submit-spark.sh` — submit Spark job to EMR.
- `./scripts/loader-run.sh <target>` — run a loader (neptune|dynamo|s3|vectors|opensearch).
- `./scripts/agent-smoke-test.sh` — invoke the AI agent stack end-to-end with a test query.
- `terraform -chdir=infra/terraform plan` — preview infra changes (human applies).

## Hard rules

1. Every artifact class has exactly one owning agent (see `docs/agents.md`). Decline work
   outside your row; name the owner.
2. No AWS credentials, API keys, or secrets ever appear in code, configs, or logs.
   Runtime secrets come from AWS Secrets Manager or SSM Parameter Store.
3. Hadoop and Spark jobs are stateless, idempotent, and output to versioned S3 prefixes
   so any phase can be re-run without corrupting prior results.
4. Neptune schema changes (vertex/edge labels, property keys) are handled only by the
   graph-loader agent and require human review before any live-cluster execution.
5. `terraform apply` and EMR cluster termination are never run by an agent; humans apply.
6. The stop hook enforces test coverage: Scala sources cannot change without `sbt check`
   having run after the last edit.
7. `.claude/**` and `CLAUDE.md` changes are constitutional: prepared by factory-engineer
   and take effect only after human ratification and session restart.
8. Infrastructure drift is forbidden: never hand-edit AWS resources; all changes go
   through `infra/terraform`.

@docs/agents.md
