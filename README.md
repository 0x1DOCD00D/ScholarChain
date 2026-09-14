# CS441 Course Project: ScholarChain

Project type: AWS cloud computing, distributed big data processing, AI agentic software engineering, Graph-RAG, Infrastructure as Code, elasticity, and empirical evaluation

Grade: 20 points

Submission deadline: Wednesday, November 25, 2026 at 11PM CST

Reference agentic implementation: [AgenticScalaAppTutorial](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial)

## Project goal

The goal of this project is to design, generate, deploy, and evaluate ScholarChain, an AWS-based scholarly collaboration intelligence system whose complete implementation is produced through a controlled AI agentic workflow.

ScholarChain starts with the [DBLP XML publication dataset](https://dblp.org/xml/) and links DBLP records to additional open scholarly datasets that improve researcher identity resolution and enrich researchers and publications with topics, institutions, identifiers, abstracts, venues, and citation context. Hadoop MapReduce performs the first large-scale parsing, normalization, author-mention preparation, blocking, joining, and coauthor-pair generation operations. Apache Spark consumes the Hadoop outputs, constructs a temporal weighted coauthorship graph, and computes distributed graph analytics over researchers and their collaboration relationships. The processed graph and supporting semantic context are loaded into Amazon Neptune, Amazon DynamoDB, ordinary Amazon S3, Amazon S3 Vectors, and optionally Amazon OpenSearch Service. Runtime AI agents then resolve researcher names, retrieve collaboration metrics and paths, retrieve semantic context, verify evidence, and ask an LLM to produce an evidence-backed explanation.

The software itself must be generated using the repository-defined workflow demonstrated by AgenticScalaAppTutorial. Students act as architects, reviewers, and ratifiers. They provide intent, phase prompts, acceptance criteria, and human approvals. A main Claude Code session acts as the orchestrator. Specialized subagents under `.claude/agents/` own disjoint artifact classes. Hooks, permission fences, tests, reviews, and human gates constrain what those agents may do.

This is not a project in which one giant prompt is sent to an LLM and the resulting repository is submitted untouched. That would be automated optimism, not software engineering. The required workflow must make ownership, evidence, validation, repair, and approval explicit.

## Required final capability

A successful ScholarChain deployment must answer a family of related research questions about scientific collaboration. The central research problem is:

```text
Which researchers have collaborated with the largest and most diverse sets of coauthors, how strongly connected are researchers through direct and indirect coauthorship relationships, and which researchers act as bridges between otherwise separate collaboration communities?
```

The project decomposes this problem into three related questions.

1. Which researchers have the broadest collaboration networks and which researchers publish papers with the largest author teams?

This question distinguishes collaboration breadth from simple publication count. A researcher who publishes one hundred papers with the same three collaborators is structurally different from a researcher who publishes thirty papers with eighty different collaborators. The system must therefore report distinct coauthor counts, repeated collaboration counts, publication counts, average team size, maximum team size, and the papers responsible for unusually large collaboration teams.

2. How connected are researchers through their coauthors?

This question treats the coauthorship data as a graph. The system must identify direct collaborators, compute shortest coauthorship paths between researchers, identify connected components, report component sizes, and characterize how many collaboration hops separate researchers when a path exists. Where practical, the project should estimate component-level quantities such as average path length or effective diameter using scalable methods rather than collecting the full graph on one machine.

3. Which researchers connect otherwise separate collaboration communities?

A researcher can have fewer direct coauthors than another researcher and still be more important structurally because the researcher lies on paths between otherwise weakly connected groups. The system must therefore discover collaboration communities and compute one or more bridge measures such as betweenness centrality or an explicitly documented scalable approximation, cross-community edge count, number of communities connected, participation coefficient, or related measures. K-core or coreness should also be used to distinguish peripheral high-degree researchers from researchers embedded in dense collaboration structures.

The final application must support time windows and enrichment filters such as research topic, venue, institution, and publication year when the linked datasets provide the necessary evidence. A representative query is:

```text
Which ten researchers have the broadest coauthorship networks in distributed systems since 2015, which of them have published papers with the largest author teams, and which of them are most important for connecting otherwise separate collaboration communities? Show direct collaboration counts, shortest-path or bridge evidence, representative papers, topics, institutions, and uncertainty in researcher identity resolution.
```

The answer must include:

- Ranked researchers for the metric requested by the user.
- Distinct coauthor counts and collaboration-strength measures.
- Publication count, average coauthors per paper, and maximum coauthors on one paper.
- The publication or publications that produced each reported maximum team size.
- Direct and indirect coauthorship paths when connectivity is requested.
- Connected-component and community membership information.
- Bridge metrics with their definitions and limitations.
- Temporal boundaries used for every metric.
- Topic, institution, venue, and representative-publication context when available.
- Stable identifiers and links back to source records.
- Explicit uncertainty when author identities or cross-dataset matches remain ambiguous.
- A machine-readable evidence bundle supporting every material claim.

The application must expose an evidence chain, not private model reasoning. The evidence chain consists of source publication records, canonical researcher IDs, coauthorship edges, graph paths, computed metrics, semantic context, match confidence, prompt and model versions, and concise claim justifications. Hidden chain-of-thought is neither required nor accepted as proof.

## What must be measured

For every canonical researcher `r`, the project must compute and clearly distinguish at least the following quantities.

```text
P_r = number of publications attributed to researcher r
C_r = number of distinct coauthors of researcher r
T_r = total coauthor occurrences across all publications of researcher r
A_r = average number of coauthors per publication of researcher r
M_r = maximum number of coauthors on any single publication of researcher r
W_r = weighted degree, where edge weight is the number of joint publications with each coauthor
```

`C_r` measures collaboration breadth. `W_r` and `T_r` measure collaboration intensity. `M_r` answers whether a researcher has participated in unusually large author teams. These values must not be collapsed into one unexplained score.

For every canonical pair of researchers `u` and `v`, a coauthorship edge must record at least:

```text
jointPublicationCount
firstCollaborationYear
lastCollaborationYear
representativeWorkIds
```

For connectivity analysis, the project must compute or retrieve:

```text
d(u,v) = shortest coauthorship-path length when u and v are connected
componentId(r) = connected component containing researcher r
componentSize(r) = number of researchers in that component
```

For community and bridge analysis, the project must compute a documented community assignment plus at least one bridge measure. Recommended measures include betweenness centrality or an approximation suitable for the selected graph size, cross-community degree, participation coefficient, and k-core or coreness.

All metrics must be time-aware. The graph must support either explicit yearly snapshots or configurable windows such as 2000 to 2005, 2006 to 2010, and so on. This makes it possible to ask whether collaboration networks are becoming broader, whether team sizes are increasing, whether research communities are becoming more connected, and which researchers became bridges over time.

A paper with `n` authors induces `n * (n - 1) / 2` undirected coauthor pairs before duplicate researcher pairs are consolidated. Large author teams can therefore create substantial pair expansion, which is one reason the project uses distributed processing rather than a local collection loop.

## Preliminaries and context

Before starting this project, students should be comfortable with the following topics:

- Git and private GitHub repositories.
- Scala 3 and sbt.
- Hadoop MapReduce concepts.
- Apache Spark transformations, actions, partitioning, and graph analytics.
- AWS identity, networking, storage, compute, monitoring, and cost controls.
- Docker and container registries.
- Terraform basics.
- RESTful microservices.
- Retrieval Augmented Generation and vector embeddings.
- LLM prompting, structured outputs, and hallucination controls.

Students should study the following parts of the reference agentic repository before creating ScholarChain:

- [AgenticScalaAppTutorial.md](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/AgenticScalaAppTutorial.md)
- [The reference genesis prompts](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/docs/genesis-prompts.md)
- [The reference project memory file](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/CLAUDE.md)
- [The reference agent ownership map](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/docs/agents.md)
- [The reference agent definitions](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/tree/master/.claude/agents)
- [The reference settings and hooks](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/tree/master/.claude)
- [The reference MCP configuration](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/.mcp.json)

The reference repository is a control-system example, not a ScholarChain solution. Students must adapt its orchestrator, subagent, authority, hook, report, repair, and ratification patterns to the substantially different data, cloud, and AI requirements in this assignment. Copying TaskForge source code and renaming classes does not satisfy any ScholarChain requirement.

## Overview and motivation

Scholarly collaboration is distributed across millions of publication records, name variants, institutions, venues, research topics, and independently maintained identity systems. A simple bibliographic query can count papers by a literal author string, but it cannot safely answer who really has the broadest collaboration network, how two researchers are connected through intermediate coauthors, or which researchers bridge otherwise separate communities. Those questions require researcher identity resolution, pair generation, large graph construction, temporal analysis, and auditable path evidence.

ScholarChain turns publication metadata into an evidence-bearing temporal coauthorship graph. Hadoop handles high-volume record preparation that is naturally expressed as mapping, grouping, joining, reducing, and generating coauthor-pair candidates. Spark performs iterative and graph-oriented analytics such as distinct-degree computation, weighted degree, connected components, shortest-path or distance analysis, community discovery, bridge scoring, k-core analysis, temporal collaboration trends, and evidence-path construction. Neptune stores graph topology and supports bounded path retrieval. S3 Vectors stores durable embeddings of researcher profiles, collaboration-community summaries, representative paper abstracts, and path summaries. DynamoDB stores operational state and audit records. An optional OpenSearch tier supports hot or hybrid lexical and vector retrieval. Runtime agents combine these stores without confusing deterministic graph facts with LLM-generated interpretation.

The project also addresses a second problem. LLMs can generate a surprising amount of software, but unrestricted generation creates ambiguous ownership, silent defects, weak review, accidental cloud changes, and artifacts nobody can reproduce. The AgenticScalaAppTutorial solves that problem by treating the repository as an engineered institution. A main orchestrator delegates work to narrow subagents. Each artifact class has one writer. Tests and reviewers are independent from implementation. Hooks create a deterministic safety floor. Human ratification is required for constitutional, destructive, costly, or security-sensitive changes.

The educational value comes from combining these two systems:

1. A build-time agentic software factory that creates and validates the complete ScholarChain repository.
2. A runtime agentic collaboration-analysis application that answers graph questions from explicit evidence.

Students therefore learn not only how to call an LLM, but how to control an LLM-based engineering organization and how to build an LLM application whose explanations are grounded in deterministic distributed computations.

## Functionality

ScholarChain must provide the following end-to-end functionality:

1. Register and retrieve versioned open scholarly datasets.
2. Store raw snapshots and manifests in Amazon S3.
3. Parse DBLP XML and normalize publication and author-mention records with Hadoop MapReduce.
4. Normalize at least three additional datasets with Hadoop MapReduce.
5. Generate deterministic and probabilistic cross-dataset entity-link candidates, with special attention to author identity resolution.
6. Produce accepted, rejected, unresolved, and conflict match records with provenance.
7. Generate publication-to-researcher records and coauthor-pair records, then construct a temporal weighted coauthorship graph with Spark.
8. Compute researcher collaboration metrics, connected components, communities, bridge measures, path-related data, k-core or equivalent density measures, team-size statistics, and temporal trends with Spark.
9. Load graph topology and computed researcher properties into Neptune.
10. Store operational records, match caches, query sessions, selected metric tables, and audit records in DynamoDB.
11. Store source text and generated researcher or community summaries in ordinary S3 and embeddings plus compact metadata in S3 Vectors.
12. Optionally promote selected hot records into OpenSearch for hybrid search.
13. Expose the runtime through independently scalable RESTful microservices.
14. Execute a multi-agent query workflow that resolves researchers, retrieves graph metrics and paths, retrieves semantic context, verifies evidence, and synthesizes an explanation.
15. Return stable researcher IDs, publications, coauthor paths, scores, uncertainty, and source metadata with every answer.
16. Define the complete AWS environment in Terraform.
17. Provide source-controlled scripts that reproduce build, validation, Terraform planning, deployment, bounded data processing, smoke testing, experiments, evidence archiving, and cleanup. Optional continuous-integration workflows may invoke these scripts but are not required.
18. Demonstrate elastic resource provisioning under controlled load.
19. Preserve reproducibility through manifests, checksums, versioned prompts, immutable image tags, run ledgers, exact agent definitions, and phase work orders.
20. Generate every required repository artifact through the controlled Claude Code agentic workflow.

## Inputs

The system inputs include:

- The DBLP XML dump and DTD.
- At least three additional open scholarly datasets.
- A versioned dataset manifest.
- Dataset-specific schemas and normalization rules.
- Researcher and work entity-linking thresholds and matching policies.
- Coauthorship time-window configuration.
- A runtime user question.
- LLM and embedding model identifiers.
- Graph, vector, path, community, ranking, and answer-generation configuration.
- Terraform environment variables and source-controlled run-script parameters.

## Outputs

The system outputs include:

- Normalized publication, researcher, author-mention, venue, topic, institution, and text records.
- Accepted, rejected, unresolved, and conflict entity-link decisions.
- Canonical publication-to-researcher authorship records.
- Temporal weighted coauthorship edges with supporting publication IDs.
- Partitioned graph node and edge files.
- Spark researcher-metric, component, community, bridge, k-core, team-size, temporal, and path tables.
- A Neptune property graph.
- S3 Vectors indexes and ordinary S3 source or generated-context objects.
- DynamoDB operational and audit records.
- Optional OpenSearch indexes.
- REST API responses with evidence bundles.
- CloudWatch logs, metrics, traces, dashboards, and alarms.
- Elasticity and performance experiment results.
- A complete agent-generated source repository containing every submitted agent definition and reproducibility work order.
- A final report, architecture diagrams, runbook, demonstration video, and cleanup evidence.

## High-level architecture

The build-time workflow and runtime workflow are separate but related.

```text
Human architect
     |
     v
Claude Code orchestrator
     |
     +--> factory-engineer
     +--> build-engineer
     +--> domain-engineer
     +--> dataset-engineer
     +--> hadoop-engineer
     +--> entity-resolution-engineer
     +--> spark-engineer
     +--> storage-engineer
     +--> rag-engineer
     +--> service-engineer
     +--> test-engineer
     +--> code-reviewer
     +--> infra-engineer
     +--> deploy-engineer
     +--> experiment-engineer
     +--> documentation-engineer
     +--> incident-responder
     +--> dependency-updater
     |
     v
Versioned repository with validated deliverables
```

```text
DBLP + open scholarly enrichment datasets
     |
     v
S3 raw zone
     |
     v
EMR Hadoop MapReduce
parse -> normalize -> resolve candidates -> author mentions -> coauthor-pair candidates
     |
     v
S3 curated zone
     |
     v
EMR Spark
canonical researchers
  -> temporal weighted coauthorship graph
  -> distinct coauthor counts and weighted degree
  -> team-size statistics
  -> connected components and path data
  -> communities, bridge metrics, and k-core
  -> temporal collaboration summaries
     |
     +----------------------+----------------------+---------------------+
     |                      |                      |                     |
     v                      v                      v                     v
Neptune                 DynamoDB              S3 Vectors          ordinary S3
coauthorship graph      run and audit state   semantic context     source records
     |                      |                      |                     |
     +----------------------+-----------+----------+---------------------+
                                        |
                                        v
                          Runtime agentic query workflow
                                        |
                                        v
                     Evidence-backed collaboration explanation and API
```

The optional OpenSearch tier sits beside S3 Vectors. It is used only when the team implements and evaluates hybrid lexical and vector search, lower-latency hot retrieval, or faceted aggregation. S3 Vectors remains the durable semantic retrieval tier.

## The reference agentic control model

The main Claude Code session is the orchestrator. It is not represented by a file under `.claude/agents/`. It retains the conversation for one project phase, interprets human intent, decomposes work, invokes the correct specialist, reads reports, routes blocked work, and presents results to the human architect. The orchestrator must not perform a specialist's work inline.

Each subagent starts with a fresh context and receives:

- Its role file from `.claude/agents/`.
- The shared project memory from `CLAUDE.md`.
- The current work order.
- Any prior agent reports explicitly pasted into the work order.

Subagents do not call one another. All routing passes through the orchestrator. This hub-and-spoke topology preserves an observable audit trail and prevents an incorrect agent decision from silently propagating through several other agents.

The project must follow these control rules:

1. One artifact class has exactly one creating and owning agent.
2. An agent asked to edit another agent's artifact must decline and name the correct owner.
3. Reviewer-class agents have no write tools.
4. Infrastructure authors may produce plans but may not apply or deploy them.
5. Deployment operators may execute approved scripts but may not author those scripts.
6. Tests must be run before an agent may report implementation work complete.
7. Dangerous commands are blocked by hooks and permission rules.
8. Constitutional files require human ratification and a fresh session before they take effect.
9. One project phase uses one fresh orchestrator session and normally one commit.
10. Agent reports, committed contracts, and repository artifacts are the only memory that crosses sessions.
11. A blocked agent returns `BLOCKED-ON` with evidence and the required owner. The orchestrator routes the dependency, validates the repair, and reruns the blocked agent in a fresh context.
12. No agent approves its own work.

## Human architect responsibilities

Students are not passive spectators. The human architect is responsible for:

- Selecting and defending the architecture.
- Writing or adapting phase prompts.
- Checking that prompts state concrete inputs, outputs, actors, APIs, constraints, and acceptance tests.
- Ratifying constitutional changes.
- Reviewing Terraform plans and estimated cost.
- Approving deployment and cleanup operations.
- Reviewing destructive, security-sensitive, or high-cost changes.
- Resolving ambiguous entity-link examples used in the gold set.
- Explaining the resulting system during the demonstration.
- Reporting manual interventions honestly.

A student cannot defend weak work by saying, "the agent generated it." The agent is a tool. The submitted architecture, code, experiments, and explanations remain the student's responsibility.

## Agent authority and ownership matrix

The following agent set is required. A team may split a role only when it can demonstrate non-overlapping artifact ownership and routing descriptions. A team may merge roles only with instructor approval and only when review independence is preserved.

| Agent | Creates and owns | Must not do | Primary gate |
|---|---|---|---|
| `factory-engineer` | `CLAUDE.md`, `docs/agents.md`, `.claude/**`, `.mcp.json` | Application, data, build, infrastructure, or deployment work | Human constitutional ratification and code review |
| `build-engineer` | `build.sbt`, `project/*`, `.scalafmt.conf`, local compose files, packaging, `.gitignore` | Application source, version-only maintenance, Terraform, deployment | `sbt check` and code review |
| `domain-engineer` | `modules/core/**`, shared domain records, stable identifiers, serialization contracts, and configuration contracts | Dataset retrieval, distributed jobs, storage adapters, service routes, infrastructure | Contract tests, `sbt check`, and code review |
| `dataset-engineer` | `datasets/**`, dataset manifest, download and sampling scripts, schema notes, license records | Hadoop analytics, Spark analytics, entity-match policy | Dataset validation tests and manifest review |
| `hadoop-engineer` | `modules/hadoop/**`, MapReduce jobs, Hadoop integration tests, counters, rejected-record formats | Spark jobs, storage clients, service APIs | Local or EMR sample run and deterministic output checks |
| `entity-resolution-engineer` | `modules/entity-resolution/**`, blocking keys, match features, thresholds, calibration tools, match decision schemas | Graph analytics, API synthesis, infrastructure | Gold-set evaluation and match-policy review |
| `spark-engineer` | `modules/spark/**`, graph construction, graph analytics, evidence-path generation | Hadoop parser ownership, runtime API, Terraform | Spark tests, sample run, output invariants |
| `storage-engineer` | `modules/storage/**`, loaders and adapters for S3, Neptune, DynamoDB, S3 Vectors, optional OpenSearch | Terraform, answer synthesis, runtime HTTP routes | Contract tests and bounded load test |
| `rag-engineer` | `modules/rag/**`, query plans, retrieval fusion, evidence bundles, prompts, claim verification | HTTP transport, cloud deployment, dataset acquisition | Retrieval and groundedness evaluation |
| `service-engineer` | `modules/services/**`, REST models, routes, health checks, runtime composition | Hadoop and Spark algorithms, Terraform, agent constitution | API tests and `sbt check` |
| `test-engineer` | Adversarial and cross-module tests under `tests/**` and designated test source trees | Production implementation | Exact pass and fail report; no production edits |
| `code-reviewer` | No implementation artifacts; review reports only | Any write or edit | Read-only verified verdict |
| `infra-engineer` | `infra/terraform/**`, deployment, smoke-test, reproduction, cleanup scripts, and optional GitHub workflows | `terraform apply`, live deployment, application source | Format, validate, plan, script syntax checks, security scan, human approval |
| `deploy-engineer` | Deployment execution reports and release records | Authoring Terraform or deployment scripts | Approved plan, clean tree, smoke tests, rollback gate |
| `experiment-engineer` | `experiments/**`, `load-tests/**`, experiment manifests, raw result collectors | Altering production algorithms to improve reported results | Reproducible run and immutable raw results |
| `documentation-engineer` | `README.md`, `docs/**` except `docs/agents.md`, `docs/agent-runs/**`, and `docs/incidents/**`, plus the final report, diagrams, and demo script | Inventing results or changing implementation | Link check, command replay, evidence review |
| `incident-responder` | `docs/incidents/**`, diagnosis reports, approved rollback and bounded recovery actions | Schema changes, destructive data repair, infrastructure authorship | Human escalation for data, security, or destructive actions |
| `dependency-updater` | Version values in the approved dependency ledger and dependency update reports | Build structure, application features, major upgrades without approval | `sbt check`, vulnerability review, code review |

The ownership map in `docs/agents.md` is authoritative. The table above must be transcribed and refined for the team's exact directory structure before any application generation starts.

Human ratification records under `docs/agent-runs/**` are human-owned evidence, not agent-authored implementation artifacts. The orchestrator may assemble agent final reports there, but no implementation agent may rewrite a human decision.

## Required factory artifacts

The repository must contain the following control artifacts.

| Artifact | Required content |
|---|---|
| `CLAUDE.md` | Project identity, module boundaries, commands, architecture invariants, security invariants, definition of done, and import of `docs/agents.md` |
| `docs/agents.md` | One-writer ownership map, lifecycle routing table, authority boundaries, escalation policy, and human gates |
| `.claude/agents/*.md` | Routing description, narrow tools, role, non-negotiable laws, ordered procedure, refusal boundaries, and report contract for each subagent |
| `.claude/settings.json` | Explicit allow and deny rules plus PreToolUse, PostToolUse, and Stop hooks |
| `.claude/hooks/guard-dangerous.sh` | Blocks destructive AWS, Terraform, Git, database, S3, Neptune, DynamoDB, and vector-index commands |
| `.claude/hooks/format-scala.sh` | Runs formatting after Scala writes and exits harmlessly when no Scala file changed |
| `.claude/hooks/verify-tests-ran.sh` | Prevents a source-changing agent from stopping until the repository test marker is newer than relevant source changes |
| `.claude/hooks/validate-agent-files.sh` | Validates frontmatter, required tool fences, unique names, executable hooks, and JSON syntax |
| `.claude/commands/deploy.md` | Routes deployment to `deploy-engineer` and states gates |
| `.claude/commands/rollback.md` | Routes rollback and limits autonomous actions |
| `.claude/commands/incident.md` | Routes diagnosis to `incident-responder` |
| `.claude/commands/run-pipeline.md` | Runs a bounded ScholarChain data pipeline through approved scripts |
| `.claude/commands/experiment.md` | Routes controlled experiments to `experiment-engineer` |
| `.mcp.json` | Read-only or least-privilege GitHub, AWS API, Terraform, and documentation tools |
| `docs/agent-runs/` | Phase prompts, final agent reports, human gate decisions, repair records, and commit hashes |

The repository must not store model hidden reasoning. The phase record stores the work order, the agent's final report, deterministic command output, review findings, and human decision.

## Required hook and permission behavior

At minimum, the deterministic floor must enforce the following:

- Block `terraform apply` and `terraform destroy` from ordinary agent tool calls.
- Block force pushes.
- Block reads of `.env`, secret directories, private keys, and generated credential files.
- Block destructive AWS CLI operations such as deleting buckets, tables, Neptune clusters, vector buckets, vector indexes, ECR repositories, or KMS keys.
- Block recursive S3 deletion.
- Block unreviewed EMR termination and large scale-out commands.
- Block direct modification of already ratified agent constitutional files by non-factory agents.
- Format Scala after edits.
- Refuse agent completion after source changes when the test marker is stale.
- Produce an actionable error message rather than a cryptic rejection.

A hook is not a suggestion. It is executable policy. The student demonstration must include at least three safe probes showing that the guard blocks prohibited commands without actually performing them.

## Required MCP policy

MCP servers and external tools must be least privilege by default. Read-only access is preferred for discovery and inspection. Any write capability must be narrowly scoped, documented, and protected by an explicit phase gate.

Recommended MCP roles include:

- GitHub repository browsing and issue or pull-request inspection.
- AWS API read-only inspection.
- Terraform provider and resource documentation.
- AWS documentation lookup.

Agents should not receive direct unrestricted cloud-write tools. The intended write path is reviewed Terraform plus approved source-controlled deployment scripts. Cloud consoles must not become the undocumented side door where the real architecture lives.

## Required technology stack

| Concern | Required technology |
|---|---|
| Agentic software factory | Claude Code orchestrator and repository-defined subagents based on AgenticScalaAppTutorial |
| Main language | Scala 3 |
| Build | sbt multi-project build |
| JSON | One project-wide Scala JSON library selected and pinned; uPickle is recommended to match the reference workflow |
| Tests | ScalaTest or MUnit, selected once and used consistently |
| Raw and curated storage | Amazon S3 |
| Initial big-data processing | Hadoop MapReduce on Amazon EMR |
| Graph analytics | Apache Spark on Amazon EMR |
| Graph database | Amazon Neptune or Neptune Serverless |
| Operational NoSQL | Amazon DynamoDB |
| Durable semantic retrieval | Amazon S3 Vectors |
| Optional hot and hybrid search | Amazon OpenSearch Service or OpenSearch Serverless |
| LLM and embeddings | Amazon Bedrock or an instructor-approved model endpoint |
| Runtime microservices | Amazon ECS Fargate by default; EKS requires justification |
| Workflow orchestration | AWS Step Functions and Amazon SQS where asynchronous work is needed |
| Infrastructure as Code | Terraform |
| Build and deployment automation | Source-controlled scripts; optional GitHub Actions may invoke them |
| Images | Amazon ECR with immutable Git SHA tags |
| Secrets | AWS Secrets Manager and AWS KMS |
| Metrics, logs, and traces | Amazon CloudWatch and OpenTelemetry where practical |
| Source control | Private GitHub repository |

GitHub Actions may be used for lightweight pull-request checks or scheduled agent maintenance. They are optional and must call the same source-controlled verification or deployment scripts documented for manual reproducibility.

## Dataset portfolio

DBLP is the mandatory seed dataset. At least three additional datasets must be used in the implemented workflow. A strong submission uses five or more datasets and assigns each one a clear analytical role.

| Dataset | Official access | Contribution | Preferred linkage keys |
|---|---|---|---|
| DBLP XML | [DBLP XML releases](https://dblp.org/xml/) | Computer science publications, authors, titles, venues, years, and electronic edition links | DBLP key, DOI, normalized title, author sequence, year, venue |
| OpenAlex | [OpenAlex snapshot](https://help.openalex.org/tutorials/download-the-snapshot/) | Works, authors, institutions, topics, sources, identifiers, and citation data | DOI, OpenAlex IDs, title, authors, year |
| OpenCitations | [OpenCitations downloads](https://download.opencitations.net/) | Open citation edges and bibliographic metadata | DOI, OMID, title, year |
| Crossref | [Crossref public data file](https://www.crossref.org/services/metadata-retrieval/public-data-file/) | DOI-centered metadata, references, funders, licenses, ORCID and ROR fields when supplied | DOI, title, author, year, venue |
| arXiv | [arXiv bulk data access](https://info.arxiv.org/help/bulk_data.html) | Preprint IDs, titles, authors, categories, abstracts, and versions | arXiv ID, DOI, title, authors |
| ORCID | [ORCID public data file](https://info.orcid.org/documentation/integration-guide/working-with-bulk-data/) | Researcher identifiers, works, and public affiliations | ORCID, DOI, title, author, affiliation |
| Semantic Scholar | [Semantic Scholar datasets API](https://api.semanticscholar.org/api-docs/datasets) | Papers, authors, citations, references, venues, and abstracts | DOI, arXiv ID, S2 paper ID, title, authors |
| S2ORC | [S2ORC repository](https://github.com/allenai/s2orc) | Machine-readable scientific text for permitted records | DOI, arXiv ID, S2 paper ID, title |
| Papers with Code historical data | [Papers with Code data repository](https://github.com/paperswithcode/paperswithcode-data) | Paper-to-code, task, method, dataset, and evaluation relationships | arXiv ID, DOI, title, repository URL |

For the collaboration research questions, the recommended minimum enrichment portfolio is DBLP plus OpenAlex, ORCID, and either Crossref or Semantic Scholar. OpenAlex contributes canonical author candidates, institutions, and topics. ORCID provides strong identity evidence where public identifiers are available. Crossref or Semantic Scholar can strengthen work matching and supply additional author or abstract context. OpenCitations, arXiv, S2ORC, and Papers with Code are optional enrichments rather than core requirements for the coauthorship analysis.

The dataset manifest must record actual availability, snapshot dates, licenses, checksums, source size, selected subset, schema, update strategy, and known staleness. A dead endpoint is not a dataset strategy.

## Required dataset scope

The first local and cloud smoke tests should use a bounded corpus. The final experiment should be large enough to show distributed execution and elastic behavior without creating irresponsible cost.

Recommended minimums are:

- At least 100,000 DBLP works in the integrated functional run.
- At least 1,000,000 graph edges in the scale experiment, subject to course budget.
- At least 10,000 text chunks embedded in S3 Vectors.
- At least 200 manually reviewed entity-match examples in the evaluation gold set.
- At least 30 benchmark questions covering coauthor breadth, maximum team size, direct collaboration, shortest paths, components, communities, bridge researchers, temporal change, topics, institutions, and evidence.

A smaller final scale requires instructor approval and a written explanation of the limiting factor.

## Dataset manifest

The `dataset-engineer` must create `datasets/dataset-manifest.yaml`. Each dataset entry must contain:

- Name and purpose.
- Official source and documentation links.
- License or reuse terms.
- Snapshot or retrieval date.
- Retrieval command or script.
- File format and compression.
- Expected and observed size.
- S3 raw prefix.
- SHA-256 checksum, ETag policy, or equivalent integrity record.
- Schema version.
- Selected subset rule.
- Incremental update strategy.
- Linkage fields.
- Personal data and privacy considerations.
- Known omissions or quality limitations.
- Validation commands.
- Owning agent.

Example:

```yaml
datasets:
  dblp:
    required: true
    purpose: "seed publication records"
    source_url: "https://dblp.org/xml/dblp.xml.gz"
    dtd_url: "https://dblp.org/xml/dblp.dtd"
    snapshot_date: "YYYY-MM-DD"
    format: "xml.gz"
    raw_prefix: "s3://scholarchain-raw/dblp/snapshot_date=YYYY-MM-DD/"
    linkage_fields:
      - doi
      - normalized_title
      - normalized_author_sequence
      - year
      - venue
    validation:
      - "gzip -t dblp.xml.gz"
      - "sha256sum -c dblp.xml.gz.sha256"
    limitations:
      - "A matching author name is not sufficient evidence of author identity."
```

## Entity linkage policy

Dataset linkage must follow an evidence hierarchy.

1. Exact identifiers first: DOI, arXiv ID, ORCID, OpenAlex ID, Semantic Scholar ID, and stable repository URL.
2. Exact normalized bibliographic fields next: normalized title, year, and compatible author sequence.
3. Blocked probabilistic matching next: title similarity, author overlap, venue compatibility, year distance, coauthor evidence, affiliation evidence, and citation-neighborhood evidence.
4. LLM adjudication only for bounded ambiguous cases.
5. Human review for high-impact unresolved cases used in evaluation.

The LLM must not manufacture an identifier. Its adjudication output must contain the candidate IDs, cited input fields, confidence, reason codes, and an abstention option.

Required match outcomes are:

```text
ACCEPTED
REJECTED
UNRESOLVED
CONFLICT
```

Every decision must preserve:

```text
source record ID
candidate target ID
features used
rules fired
model or prompt version when applicable
confidence
decision
reason codes
timestamp
run ID
```

## Core data model

The shared domain module must define versioned schemas for at least the following records.

```scala
final case class WorkRecord(
  workId: String,
  source: String,
  sourceRecordId: String,
  title: String,
  normalizedTitle: String,
  year: Option[Int],
  venueId: Option[String],
  doi: Option[String],
  arxivId: Option[String],
  authors: Vector[AuthorMention],
  abstractTextRef: Option[String],
  provenance: Provenance
)

final case class MatchDecision(
  sourceId: String,
  targetId: String,
  features: Map[String, Double],
  decision: MatchOutcome,
  confidence: Double,
  reasonCodes: Vector[String],
  policyVersion: String,
  runId: String
)

final case class GraphEdge(
  edgeId: String,
  fromId: String,
  edgeType: String,
  toId: String,
  properties: Map[String, String],
  provenance: Provenance
)

final case class EvidenceItem(
  evidenceId: String,
  workId: String,
  sourceUri: String,
  chunkId: Option[String],
  graphPath: Option[Vector[String]],
  score: Double,
  text: Option[String],
  provenance: Provenance
)

final case class CoauthorEdge(
  researcherA: String,
  researcherB: String,
  jointPublicationCount: Long,
  firstCollaborationYear: Int,
  lastCollaborationYear: Int,
  representativeWorkIds: Vector[String],
  provenance: Provenance
)

final case class ResearcherMetrics(
  researcherId: String,
  publicationCount: Long,
  distinctCoauthorCount: Long,
  totalCoauthorOccurrences: Long,
  averageCoauthorsPerPaper: Double,
  maximumCoauthorsOnOnePaper: Long,
  weightedDegree: Double,
  componentId: String,
  communityId: Option[String],
  bridgeScore: Option[Double],
  coreness: Option[Int],
  windowStartYear: Int,
  windowEndYear: Int
)

final case class AnswerClaim(
  claimId: String,
  text: String,
  evidenceIds: Vector[String],
  verificationStatus: String,
  uncertainty: Option[String]
)
```

The exact fields may differ, but identifiers, versioning, provenance, uncertainty, time windows, and serialization tests are mandatory.

## Research graph model

Required node classes include:

- `Researcher`
- `AuthorMention`
- `Work`
- `Venue`
- `Institution`
- `Topic`
- `TextChunk`
- `DatasetSnapshot`

Required edge classes include:

- `AUTHORED`
- `RESOLVES_TO`
- `COAUTHORED_WITH`
- `PUBLISHED_IN`
- `AFFILIATED_WITH`
- `HAS_TOPIC`
- `DERIVED_FROM`
- `SUPPORTED_BY`

`COAUTHORED_WITH` is an undirected logical relationship even when the selected storage representation requires a direction. Its properties must include at least `jointPublicationCount`, `firstCollaborationYear`, `lastCollaborationYear`, and supporting work identifiers or a stable pointer to them. Duplicate researcher pairs must be consolidated deterministically.

Researcher nodes or associated metric records must expose the selected time window and the Spark-computed collaboration measures required by the research questions. Citation relationships may be retained as optional enrichment, but citation PageRank is not a required research metric for this version of the project.

Each graph element must carry enough provenance to locate the source dataset record and pipeline run that produced it.

## Recommended repository layout

```text
scholarchain/
  CLAUDE.md
  .mcp.json
  .claude/
    settings.json
    agents/
      factory-engineer.md
      build-engineer.md
      domain-engineer.md
      dataset-engineer.md
      hadoop-engineer.md
      entity-resolution-engineer.md
      spark-engineer.md
      storage-engineer.md
      rag-engineer.md
      service-engineer.md
      test-engineer.md
      code-reviewer.md
      infra-engineer.md
      deploy-engineer.md
      experiment-engineer.md
      documentation-engineer.md
      incident-responder.md
      dependency-updater.md
    hooks/
      guard-dangerous.sh
      format-scala.sh
      verify-tests-ran.sh
      validate-agent-files.sh
    commands/
      deploy.md
      rollback.md
      incident.md
      run-pipeline.md
      experiment.md
  build.sbt
  project/
  datasets/
    dataset-manifest.yaml
    scripts/
    schemas/
    samples/
  modules/
    core/
    hadoop/
    entity-resolution/
    spark/
    storage/
    rag/
    services/
  tests/
    contracts/
    integration/
    end-to-end/
    adversarial/
  prompts/
    runtime/
    schemas/
  infra/
    terraform/
      environments/
      modules/
  scripts/
    plan.sh
    deploy.sh
    rollback.sh
    smoke-test.sh
    run-bounded-pipeline.sh
    cleanup.sh
  load-tests/
  experiments/
  reports/
  docs/
    agents.md
    architecture.md
    data-lineage.md
    threat-model.md
    service-limits.md
    runbook.md
    agent-runs/
    incidents/
  README.md
```

Directory names may change, but the ownership boundaries and required artifacts must remain clear.

## How to execute the agentic build

Use one fresh Claude Code session, or `/clear`, for each phase. Normally create one commit per phase. The phase prompt, agent report, reviewer verdict, human gate decision, and commit hash must be saved under `docs/agent-runs/phase-NN/`.

The sequence for each phase is:

```text
1. Human architect opens a fresh orchestrator session.
2. Human provides the exact phase work order.
3. Orchestrator invokes the owning subagent.
4. Subagent inspects current repository state and performs only its owned work.
5. Subagent runs deterministic verification and returns a structured report.
6. Orchestrator invokes test or review agents when required.
7. Findings are routed to the owning agent, never fixed by the reviewer.
8. The phase is rerun until its gate passes.
9. Human ratifies or rejects the phase.
10. Human commits the accepted phase and records the commit hash.
11. The next phase starts in a fresh session.
```

Required agent report fields are:

```text
STATUS: COMPLETE | BLOCKED-ON | FAILED
OWNER:
WORK ORDER:
FILES CREATED:
FILES MODIFIED:
COMMANDS RUN:
TEST RESULTS:
VALIDATION RESULTS:
ASSUMPTIONS:
RISKS:
MANUAL ACTION REQUIRED:
BLOCKED-ON OWNER:
BLOCKED-ON EVIDENCE:
NEXT GATE:
```

An agent must never report a command as successful unless it observed the successful output.

## Agent submission and reproducibility requirements

Every submitted agent is part of the graded artifact. The repository must contain the complete agent system used to generate and maintain the project, not a cleaned-up subset prepared after the work is finished.

The submission must include:

- Every file under `.claude/agents/` used during the project.
- `CLAUDE.md` and `docs/agents.md`.
- `.claude/settings.json` and every hook under `.claude/hooks/`.
- Every project command under `.claude/commands/`.
- `.mcp.json` with secret values omitted and environment-variable names preserved.
- The exact phase work order for every phase under `docs/agent-runs/phase-NN/prompt.md`.
- The final agent report for every phase.
- Reviewer and test-agent reports when they were required.
- Human ratification records and repair records.
- The commit hash accepted at each phase.
- A version record describing the Claude Code client version, model configuration when known, JVM, sbt, Scala, Terraform, AWS CLI, and other tools needed to replay the workflow.

The README must include an agent catalog with one row per submitted subagent. Each row must identify the agent name, purpose, owned artifact paths, tool fence, prerequisites, an exact example orchestrator instruction such as `Use the spark-engineer agent to ...`, the deterministic verification command, and the expected final-report fields. This catalog is required even when several agents are normally invoked only through phase prompts.

The root README must contain a subsection named `Reproducing the agentic workflow`. At minimum it must provide these steps in project-specific form:

```text
1. Clone the private repository and check out the submitted tag.
2. Install the documented Claude Code version and all local toolchain prerequisites.
3. Configure only the required environment variables and authenticated MCP or AWS read access. Never place secrets in the repository.
4. Start Claude Code from the repository root using the documented `claude` command.
5. Confirm that CLAUDE.md, docs/agents.md, .claude/settings.json, hooks, MCP configuration, and all submitted subagents are loaded or discoverable.
6. Run the repository's safe agent-validation command and the documented dangerous-command probe.
7. For a phase to be replayed, open a fresh Claude Code session or clear the existing session, copy the exact work order from docs/agent-runs/phase-NN/prompt.md, and instruct the orchestrator to use the named owning subagent.
8. After the owning subagent returns, invoke the test-engineer or code-reviewer exactly when the phase record requires it.
9. Route BLOCKED-ON findings through the orchestrator to the artifact owner rather than editing another owner's files directly.
10. Compare the reproduced report, tests, and generated diff with the archived phase evidence. Exact natural-language wording is not expected to be byte-identical, but required artifacts, contracts, tests, safety gates, and observable results must be reproducible.
11. Use a fresh session before replaying the next phase so that the ratified repository state, not stale conversation context, becomes the next phase's starting point.
```

The README must also contain at least one bounded reproduction exercise that a grader can execute without rebuilding the entire cloud environment. A suitable exercise is to run the agent validation, replay one small code-generation or test-hardening phase on a branch, run `sbt check`, and compare the resulting report to the archived phase evidence.

If a submitted agent requires an external tool, MCP server, account permission, environment variable, model endpoint, or local executable, the instructions must name it and explain how the grader verifies that it is available. Statements such as `run the agents` are insufficient.

The grader must be able to determine which agent owns any artifact, how that agent is invoked, what it is allowed to change, which deterministic gate checks its work, and how its final report is preserved.

## Phase 0: plant the seed agent

Purpose:

Create the only initial agent file required to bootstrap the factory. The plain orchestrator may create only `.claude/agents/factory-engineer.md` during this phase.

Why:

The agent system cannot create itself until one constrained agent exists. The seed is intentionally small so the human can inspect every line before it gains authority to create the remaining control plane.

Use this work order in a clean repository:

```text
Create exactly one file, .claude/agents/factory-engineer.md, and nothing else.

The agent must create and maintain the ScholarChain agent system from an authority matrix. Its owned artifacts are CLAUDE.md, docs/agents.md, .claude/agents/*, .claude/hooks/*, .claude/commands/*, .claude/settings.json, and .mcp.json.

Frontmatter requirements:
- name: factory-engineer
- description: a routing-grade description stating that it creates and maintains the agent system from scratch, prepares constitutional diffs, and never self-ratifies
- tools: Read, Grep, Glob, Write, Edit, Bash

Body requirements:
- State that all controlled files are constitutional.
- Require a human-ratified authority matrix before widening tools, ownership, or autonomy.
- Require least privilege and explicit tools fields.
- Forbid reviewer agents from receiving write tools.
- Separate timeless role rules, shared project memory, and one-run task details.
- Preserve floor invariants for dangerous-command guards, test-stop hooks, formatter behavior, secret-read denial, terraform apply and destroy denial, destructive AWS denial, and force-push denial.
- Require collision, orphan, and one-writer-per-artifact audits.
- Require JSON parsing, shell syntax checks, executable-bit checks, and a complete diff report.
- Forbid the agent from authoring application, data, build, infrastructure, experiment, or documentation artifacts outside the agent-control system.
- End with a report contract and a statement that no constitutional change is effective before human ratification and session restart.

Print the complete file and stop. Do not create any other artifact.
```

Gate:

- Human reads the complete seed file line by line.
- The file grants no authority outside the control-plane artifacts.
- The tools field is explicit.
- The agent cannot self-ratify.
- Commit the seed file.
- Restart Claude Code before Phase 1.

## Phase 1: the factory builds the ScholarChain factory

Purpose:

Generate the complete agent control plane from the authority matrix in this assignment.

Why:

Every later artifact depends on correct routing, ownership, permissions, hooks, and human gates. A flawed factory can generate a large amount of consistently flawed work at impressive speed.

Use this work order:

```text
Use the factory-engineer agent to create the complete ScholarChain agent system from the authority matrix in the course project specification.

Create:

1. CLAUDE.md
- Identify ScholarChain as a Scala 3, Hadoop, Spark, AWS, Graph-RAG project.
- Define module dependency boundaries.
- Define sbt check as the repository definition of done.
- State the one-owner-per-artifact rule.
- Require feature tests for every behavior change.
- Require provenance for every data transformation and runtime claim.
- Require secrets only through Secrets Manager or approved local placeholders.
- Require all AWS infrastructure through Terraform.
- Forbid direct cloud-console mutation as an implementation path.
- Import docs/agents.md.

2. docs/agents.md
- Transcribe the complete artifact ownership table for all required agents.
- Add a lifecycle-to-agent routing table.
- Add escalation rules for constitutional changes, data destruction, security changes, Terraform apply, deployment, expensive scale changes, and ambiguous ownership.
- State that subagents do not invoke one another and that all routing passes through the orchestrator.

3. All remaining .claude/agents/*.md files
- Use precise routing descriptions in the vocabulary of this project.
- Use the narrowest practical tools field.
- Give code-reviewer no Edit or Write tool.
- Give infra-engineer authoring and read-only cloud inspection tools but no apply or live deployment authority.
- Give deploy-engineer execution authority only through approved scripts and approved environments.
- Give test-engineer write access only to test territories.
- Require each agent to decline and route out-of-scope work.
- Include a structured report contract.

4. .claude/settings.json and hooks
- PostToolUse formatter for Scala writes.
- PreToolUse dangerous-command guard.
- Stop hook requiring current tests after source changes.
- Agent-file validation hook or script.
- Explicit allow and deny lists.
- Deny reads of secrets and .env files.
- Deny terraform apply and destroy.
- Deny force push.
- Deny destructive S3, DynamoDB, Neptune, S3 Vectors, ECR, KMS, and EMR commands.

5. .mcp.json
- GitHub access.
- AWS API inspection with no unrestricted write authority.
- Terraform documentation or provider inspection.
- AWS documentation access where available.
- Document every server's trust boundary and environment variables.

6. .claude/commands
- deploy, rollback, incident, run-pipeline, and experiment commands.
- Every command must name the responsible agent and gates.

7. docs/agent-runs/README.md
- Define the phase evidence format.
- State that hidden model reasoning is not stored.

Do not create build files or application source.

Validate every JSON file with a parser, every shell script with bash -n, all hook executable bits, all agent frontmatter, unique agent names, ownership completeness, routing collisions, routing orphans, and reviewer tool fences.

Present the complete diff, per-file authority justification, audit results, validation output, and post-ratification probe instructions. Stop for human ratification.
```

Required probes after ratification and restart:

1. Ask `feature-implementer` to edit `build.sbt`. It must refuse and route to `build-engineer`.
2. Ask `code-reviewer` to fix a defect. It must report the defect but refuse to edit.
3. Propose `echo 'terraform destroy'`. The guard must block it.
4. Propose reading `.env`. The permission policy must block it.
5. Modify a harmless Scala sample and attempt to stop without tests. The Stop hook must require the test command.
6. List available agents and confirm every required lifecycle stage has one owner.

Gate:

- Human reviews the complete constitutional diff.
- Every artifact class has one writer.
- No agent has an omitted tools field.
- Review and implementation are separated.
- Destructive commands are structurally blocked.
- Probes pass.
- Human records a ratification statement and commit hash.
- Restart before Phase 2.

## Phase 2: create the build and repository skeleton

Purpose:

Create a deterministic Scala 3 multi-project build and empty owned directories.

Why:

The build is executable policy. It determines language versions, dependency boundaries, test scope, packaging, formatting, and the command that every agent and source-controlled validation script uses to decide whether the repository is healthy.

Use this work order:

```text
Use the build-engineer agent to create the ScholarChain sbt multi-project build and repository skeleton from scratch.

Required projects:
- core
- hadoop
- entityResolution
- sparkAnalytics
- storage
- rag
- services

Required principles:
- Scala 3 everywhere.
- Use Hadoop and Spark Java or DataFrame APIs where that avoids unsupported Scala binary assumptions.
- Pin every dependency and plugin version in a single version ledger.
- No floating or latest versions.
- Select one JSON library for the entire Scala codebase. Prefer uPickle unless a documented compatibility problem requires another choice.
- Select ScalaTest or MUnit and use it consistently.
- Keep Hadoop and Spark dependencies Provided when the runtime supplies them.
- Keep test-only libraries in Test scope.
- Keep logging implementation in Runtime scope.
- Use scalafmt with the Scala 3 dialect.
- Create a markTestRun task that updates .claude/.last-test-run only after tests pass.
- Define aliases: fmt, check, packageJobs, and dockerLocal.
- check must run format checking, compilation, tests, contract tests that do not need AWS, and markTestRun.
- Container images must use a pinned Java runtime, a non-root user, and percentage-based memory limits.
- Build behavior may depend only on explicitly documented environment variables.
- No secrets, cloud endpoints, or deployment procedures in the build definition.

Create:
- build.sbt
- project/build.properties
- project/plugins.sbt
- .scalafmt.conf
- .gitignore
- local compose file for emulators or test dependencies only when justified
- empty module source roots
- empty required top-level directories from the approved ownership map

Verify on a clean repository state with sbt Test/compile and then sbt check once the marker test exists.
Report the complete version ledger, module dependency graph, environment input surface, packaging choices, and any compatibility risk involving Scala 3, Hadoop, or Spark.
```

Gate:

- No application logic is present.
- `sbt Test/compile` succeeds.
- `sbt check` has a stable definition.
- The module graph does not create cycles.
- Dependency versions appear in one ledger.
- Code review returns APPROVE.

## Phase 3: define contracts, configuration, and dataset manifests

Purpose:

Freeze the shared data and wire contracts before distributed jobs and services depend on them.

Why:

A distributed system fails expensively when producers and consumers disagree about researcher identity, identifiers, pair semantics, field meanings, partition keys, nullability, or JSON representation. Contract tests are cheaper than debugging millions of malformed or incorrectly merged collaboration records in S3.

Use this work order:

```text
Use the dataset-engineer and domain-engineer, in separate delegated work orders, to create the ScholarChain data contracts and dataset manifest.

Dataset-engineer work:
- Create datasets/dataset-manifest.yaml for DBLP and every selected enrichment dataset.
- Include source, license, snapshot, format, size estimate, S3 prefixes, checksums, subset rule, schema, linkage keys, update method, limitations, privacy notes, and validation commands.
- Create bounded download and sample-generation scripts under datasets/scripts.
- Create representative legal sample files under datasets/samples, small enough for the repository.
- Create schema notes under datasets/schemas.
- Scripts must be idempotent and must not download a full corpus by default.

Domain-engineer work:
- Create immutable Scala domain records for WorkRecord, AuthorMention, CanonicalResearcher, AuthorshipRecord, PublicationTeam, CoauthorPairCandidate, CoauthorEdge, ResearcherMetrics, Venue, Institution, Topic, Provenance, MatchDecision, GraphNode, GraphEdge, EvidenceItem, EvidenceBundle, QueryPlan, AnswerClaim, and AnswerResponse.
- Define stable researcher, work, edge, evidence, and run ID functions.
- Define enums for source type, match outcome, evidence type, collaboration metric, query operation, and verification status.
- Define a configuration loader using environment variables plus versioned HOCON or YAML files. Do not hardcode bucket names, endpoints, thresholds, model IDs, AWS account IDs, graph windows, or bridge-algorithm parameters.
- Create serialization and schema-version tests.
- Freeze representative JSON wire examples in contract tests.
- Add validation that rejects missing provenance, invalid confidence ranges, unsupported schema versions, malformed stable IDs, invalid undirected pair ordering, and time windows where start year exceeds end year.

Run sbt check.
Report sample serialized records, stable ID formulas, pair canonicalization rule, configuration precedence, schema versions, and known unresolved dataset questions.
```

Required stable ID principles:

```text
work ID: namespace plus authoritative source ID when available
researcher ID: canonical external identifier when validated, otherwise a versioned ScholarChain identity ID
coauthor edge ID: hash of canonical ordered researcher IDs plus graph-window and policy version
chunk or profile ID: hash of entity ID, source version, document type, ordinal when needed, and text hash
graph edge ID: hash of edge type, canonical endpoints, policy version, and source evidence
run ID: timestamp-independent unique identifier stored with an immutable run manifest
```

Gate:

- Every record has provenance.
- Wire-format contract tests pass.
- Dataset manifest validation passes.
- Sample scripts do not silently fetch large files.
- Pair ordering and time-window tests pass.
- The reviewer verifies that no dataset license, identifier, or source is invented.

## Phase 4: implement raw ingestion and Hadoop MapReduce

Purpose:

Create the first required big-data processing stage and prepare the records from which the collaboration graph will be built.

Why:

DBLP XML and external scholarly snapshots contain large numbers of mostly independent records. MapReduce is appropriate for parsing, canonicalization, key-based grouping, blocking, joins, deduplication, author-mention extraction, and expansion of each publication into candidate coauthor pairs.

Use this work order:

```text
Use the hadoop-engineer agent to implement the ScholarChain Hadoop MapReduce pipeline.

Required jobs:

1. DBLP record extraction
- Read complete DBLP publication records without splitting an XML record across mappers.
- Support the selected DBLP record types present in the chosen snapshot.
- Extract DBLP key, title, author sequence, year, venue fields, ee links, URLs, and record type.
- Emit valid normalized WorkRecord and AuthorMention records.

2. External source normalization
- Implement one normalizer per selected dataset.
- Map source fields into shared contracts without losing source-specific IDs.
- Preserve author identifiers, affiliations, topic identifiers, abstracts, and work identifiers when available.
- Write malformed and unsupported records to versioned reject outputs.

3. Exact identifier extraction and join preparation
- Normalize DOI, arXiv, ORCID, OpenAlex, Semantic Scholar, and other selected identifiers.
- Emit exact-identifier keys and duplicate or conflict counters.

4. Researcher and work blocking
- Emit bounded candidate blocks using normalized names, initials, coauthor context, title, year, venue, affiliation, and source.
- Prevent pathological common-name or title blocks from overwhelming reducers.

5. Candidate feature construction
- Join records within blocks.
- Compute deterministic match features.
- Emit MatchCandidate records rather than final guesses hidden inside logs.

6. Publication team extraction
- Emit one publication-team record containing the ordered author mentions for every retained work.
- Emit author-paper records keyed by author mention and work ID.
- Emit candidate unordered coauthor pairs for every paper with at least two authors.
- A paper with n authors generates n * (n - 1) / 2 candidate pairs before duplicates are consolidated.
- Preserve work ID, year, author position, and source provenance on every pair record.
- Count and report unusually large author teams because they can create quadratic pair expansion.

7. Graph export preparation
- Emit partitioned work, author-mention, team, pair-candidate, topic, institution, and other selected enrichment files for Spark.

Required operational behavior:
- Hadoop counters for input, accepted, rejected, duplicate, conflict, oversize block, oversize author team, emitted pair, missing key, and schema failure records.
- Explicit partition strategy.
- Idempotent output paths containing run ID and dataset snapshot.
- No mutable shared state across map or reduce tasks.
- Compression for intermediate outputs.
- Deterministic outputs for deterministic inputs.
- Unit tests for parsers, pair generation, normalization, and key functions.
- Mini-cluster or local integration tests for representative jobs.
- A bounded EMR smoke-run script owned by the infrastructure workflow, not by this agent.

Run sbt check and the local bounded pipeline.
Report job graph, mapper and reducer key-value contracts, partition counts, counters, rejected records, output paths, maximum observed team size, largest pair expansion, and the largest observed blocking group.
```

Required Hadoop data flow:

```text
DBLP XML --------------------> DBLP parser --------------------------+
                                                                    |
OpenAlex/ORCID/etc. ---------> source normalizers ------------------+--> identity-link inputs
                                                                    |
publication teams -----------> author-paper and pair expansion -----+--> coauthor pair candidates
                                                                    |
all normalized records ------> blocking-key mappers ----------------+--> candidate identity groups
                                                                    |
all prepared records -----------------------------------------------+--> S3 curated MapReduce output
```

Gate:

- At least two real MapReduce jobs execute, not local collection operations disguised as MapReduce.
- DBLP parser handles record boundaries correctly.
- Pair generation passes hand-checkable papers with 1, 2, 3, and larger author lists.
- Counters and reject outputs are visible.
- Repeated runs with the same input produce equivalent logical output.
- Sample results contain provenance.
- Test engineer adds adversarial XML, Unicode, missing-field, duplicate-ID, common-name, and giant-team cases.
- Code reviewer returns APPROVE.

## Phase 5: implement entity resolution

Purpose:

Resolve records across datasets while preserving uncertainty and auditability.

Why:

A title or author-name match is not identity. Incorrectly merging two researchers or splitting one researcher into several identities corrupts coauthor counts, shortest paths, components, communities, bridge scores, team-size attribution, and every LLM answer downstream. Entity resolution must be treated as an evaluated model, not as a convenient string comparison.

Use this work order:

```text
Use the entity-resolution-engineer agent to implement the ScholarChain entity-resolution subsystem against the Phase 3 contracts and Phase 4 MatchCandidate records.

Required behavior:
- Exact identifier rules for DOI, arXiv ID, ORCID, OpenAlex ID, Semantic Scholar ID, and repository URL.
- Normalization for Unicode, punctuation, whitespace, title markup, initials, name order, and DOI prefixes.
- Feature functions for researcher-name similarity, initials, author order, coauthor overlap, affiliation compatibility, ORCID or external IDs, title similarity, year distance, venue compatibility, citation-neighborhood evidence when available, and source reliability.
- A versioned scoring policy.
- Separate thresholds for accepted, rejected, and unresolved results.
- Conflict detection when authoritative identifiers disagree.
- LLM adjudication only for a bounded unresolved band.
- Strict JSON schema for LLM adjudication with accept, reject, and abstain outcomes.
- No LLM call may alter source records or create an identifier not present in the candidates.
- Cache LLM adjudications by input hash, prompt version, model version, and policy version.
- Produce accepted, rejected, unresolved, and conflict outputs.
- Generate a review queue for human-labeled evaluation examples.

Evaluation requirements:
- At least 200 manually reviewed candidate pairs.
- Precision, recall, F1, confusion matrix, and coverage, reported separately for researcher-identity resolution and work resolution when both are implemented.
- Metrics by match path: exact ID, deterministic bibliographic, probabilistic, and LLM-adjudicated.
- Error analysis with at least ten false positives and ten false negatives when available.
- Threshold sensitivity analysis.

Run sbt check and the gold-set evaluation.
Report the policy version, feature definitions, thresholds, model and prompt versions, confusion matrix, unresolved rate, and representative errors.
```

Gate:

- Exact ID conflicts do not silently merge.
- The LLM can abstain.
- Evaluation examples are traceable to source records.
- Gold labels are human-reviewed.
- Precision and recall are reported separately, not hidden behind one aggregate score.
- The reviewer verifies there is no data leakage from evaluation labels into matching logic.

## Phase 6: build the temporal coauthorship graph and run Spark analytics

Purpose:

Convert resolved publication and researcher records into a temporal weighted collaboration graph and compute the measures required by the three research questions.

Why:

MapReduce prepares records and pair candidates. The main research problem, however, requires iterative graph algorithms, repeated aggregations, community computation, path analysis, and temporal comparison. Those operations are better suited to Spark's distributed execution model.

Use this work order:

```text
Use the spark-engineer agent to implement the ScholarChain Spark collaboration-analysis pipeline.

Required jobs:

1. Canonical researcher and authorship builder
- Read accepted researcher and work entity links plus Hadoop author-paper outputs.
- Construct canonical Researcher, Work, AUTHORED, Topic, Institution, and Venue tables.
- Preserve unresolved author mentions without forcing a merge.
- Validate that every canonical authorship edge points to existing nodes.

2. Temporal weighted coauthorship graph builder
- Map Hadoop pair candidates onto canonical researcher IDs.
- Drop self-pairs created by identity resolution.
- Canonicalize pair order so each logical undirected pair has one identity.
- Aggregate duplicate pairs.
- Store jointPublicationCount, firstCollaborationYear, lastCollaborationYear, and supporting work IDs or a stable pointer to them.
- Support configurable year windows.

3. Researcher collaboration breadth and team-size statistics
For each researcher and time window compute:
- publicationCount P_r
- distinctCoauthorCount C_r
- totalCoauthorOccurrences T_r
- averageCoauthorsPerPaper A_r
- maximumCoauthorsOnOnePaper M_r
- weightedDegree W_r
- the work IDs responsible for M_r
Keep every component visible. Do not replace these measures with one opaque collaboration score.

4. Connected components
- Compute connected components of the researcher coauthorship graph.
- Store component ID and component size.
- Report the fraction of researchers in the largest component and the number of singleton researchers when applicable.

5. Researcher connectivity and path support
- Provide a scalable method for shortest paths between selected researcher pairs.
- Materialize or cache bounded path evidence for benchmark queries.
- Where feasible, estimate component-level average path length or effective diameter using sampling or another documented scalable method.
- Never compute all-pairs shortest paths by collecting the graph on the driver.

6. Collaboration communities
- Compute a documented community method appropriate to the selected Spark stack, such as label propagation or another justified algorithm.
- Store community membership, community size, and cross-community edges.

7. Bridge analysis
- Compute at least one documented bridge measure such as exact or approximate betweenness centrality, cross-community degree, or participation coefficient.
- Record algorithm parameters and approximation strategy when exact computation is impractical.
- Report the number of distinct communities directly connected by each selected researcher when derivable.

8. K-core or equivalent dense-subgraph measure
- Compute coreness or a justified alternative that captures whether a researcher is embedded in a dense collaboration structure.
- Test against small hand-checkable graphs.

9. Temporal collaboration analysis
- Recompute selected metrics over configured time windows or yearly snapshots.
- Measure changes in distinct coauthors, team sizes, component membership, community membership, and bridge behavior.
- Do not compare windows with incompatible inclusion rules without stating the limitation.

10. Semantic-context preparation
- Produce researcher-profile summaries, community summaries, collaboration-path summaries, and selected paper or topic summaries for later embedding.
- Summaries must be generated from computed data and source records, not invented metrics.

11. Export
- Write partitioned Parquet node, edge, metric, community, component, path-evidence, and semantic-summary tables.
- Produce load manifests for Neptune, DynamoDB, S3 Vectors, and ordinary S3.

Operational requirements:
- Explain partitioning and shuffle boundaries.
- Avoid collecting the full graph on the driver.
- Configure checkpointing where iterative algorithms require it.
- Emit counts and invariant failures.
- Make every run reproducible from a run manifest.

Run sbt check, a local or small-cluster Spark integration test, and a bounded EMR Spark run.
Report stage DAGs, partition counts, shuffle metrics, graph counts, component counts, community counts, metric distributions, path-test results, temporal windows, rejected integrity violations, and output paths.
```

Gate:

- Spark performs real distributed transformations and graph analytics.
- No complete graph is collected to the driver.
- Distinct coauthor counts and pair weights pass small known-graph tests.
- Connected components, community assignment behavior, path queries, and k-core or equivalent tests are demonstrated on hand-checkable fixtures.
- Every bridge measure is defined and its limitations are stated.
- Time windows are explicit in outputs.
- Partition and shuffle behavior are documented.
- Code review returns APPROVE.

## Phase 7: implement storage adapters and loading

Purpose:

Load each collaboration data product into the AWS store designed for its access pattern.

Why:

A graph database, an operational key-value database, an object store, and a vector index are not interchangeable products with different logos. Each store should have a narrow, defensible role.

Use this work order:

```text
Use the storage-engineer agent to implement ports, adapters, loaders, and contract tests for the ScholarChain storage layer.

Required adapters:

1. Ordinary S3
- Raw, curated, graph, semantic-context, reports, and logs prefixes.
- Versioned object keys and run manifests.
- Content hashes and source references.

2. Neptune
- Bulk loader manifests for Researcher, Work, Venue, Institution, Topic, and selected context nodes.
- Load AUTHORED, COAUTHORED_WITH, PUBLISHED_IN, AFFILIATED_WITH, HAS_TOPIC, RESOLVES_TO, DERIVED_FROM, and SUPPORTED_BY relationships as required by the implemented graph model.
- Store coauthor-edge properties including jointPublicationCount, firstCollaborationYear, lastCollaborationYear, selected time window, and evidence pointer.
- Store researcher collaboration metrics needed for bounded runtime lookup when appropriate.
- Use idempotent identifiers and parameterized openCypher queries.
- Give runtime services read-only graph credentials.

3. DynamoDB
- RunLedger table.
- EntityLinkCache table.
- QuerySession table.
- EvidenceBundle table.
- ArtifactRegistry table.
- Optional ResearcherMetricCache table when justified by access patterns.
- Explicit partition and sort keys.
- Conditional writes for idempotency.
- TTL only where data is genuinely disposable.

4. S3 Vectors
- Create and query vector-bucket and index abstractions.
- Store embeddings with stable vector keys and compact filterable metadata.
- Store long text or generated profiles in ordinary S3 and keep only references in vector metadata.
- Support metadata filters for researcher, year window, source, topic, institution, community, and document type when permitted by service limits.
- Batch writes, retry transient failures, and record rejected vectors.

5. Optional OpenSearch
- Only when the team implements hybrid lexical and vector retrieval or a measured hot tier.
- Define synchronization from durable S3 and S3 Vectors data.
- Do not make OpenSearch an undocumented second source of truth.

Required vector indexes:
- researcher-profile-v1
- collaboration-community-v1
- paper-abstract-v1
- collaboration-path-v1
- topic-institution-summary-v1

Required tests:
- Serialization and deserialization.
- Idempotent reload.
- Missing and malformed metadata.
- Duplicate vector keys.
- Neptune coauthor-edge endpoint and evidence validation.
- DynamoDB conditional-write behavior.
- Local fakes or test containers where possible.
- Bounded AWS integration tests behind an explicit profile.

Run sbt check and the bounded storage integration suite.
Report schemas, keys, indexes, metadata fields, batch sizes, retry policy, idempotency strategy, service limits captured from current documentation, and cleanup procedures.
```

Gate:

- Long text is not stuffed into vector metadata.
- Neptune graph identifiers match Spark output identifiers.
- COAUTHORED_WITH edges can be traced to supporting work evidence.
- DynamoDB keys support stated access patterns.
- Loaders are idempotent.
- AWS integration tests are bounded and separately enabled.
- The reviewer approves schema and failure-handling behavior.

## Phase 8: create embeddings and populate S3 Vectors

Purpose:

Build durable semantic retrieval indexes that explain researcher interests, collaboration communities, representative publications, and graph paths while leaving exact graph metrics in deterministic stores.

Why:

Graph traversal answers structural questions exactly. Vector retrieval supplies semantic context about what researchers and communities work on. The final application needs both, but the LLM must never recompute or guess deterministic collaboration metrics from text.

Use this work order:

```text
Use the storage-engineer and rag-engineer in separate delegated work orders to build the embedding and S3 Vectors ingestion path.

Storage-engineer work:
- Implement a bounded embedding work queue using SQS or a manifest-driven batch design.
- Implement vector write batches through the S3 Vectors API.
- Store authoritative source text and generated profile documents in ordinary S3.
- Store vector key, researcher or community ID, relevant time window, topic or institution IDs, document type, source dataset, model version, text hash, and run ID as compact metadata.
- Detect and skip unchanged text by content hash and embedding model version.
- Record failures and retry counts in RunLedger.

Rag-engineer work:
- Define deterministic rendering templates for researcher profiles, community profiles, collaboration paths, and representative-paper summaries.
- Define chunking policies for permitted abstracts or longer text when used.
- Define embedding model versioning.
- Create retrieval smoke tests with known expected researcher, topic, or community neighbors.
- Create a compact semantic-context format for the synthesis agent.

Required indexes:
- researcher-profile-v1
- collaboration-community-v1
- paper-abstract-v1
- collaboration-path-v1
- topic-institution-summary-v1

Run the local contract tests and a bounded AWS ingestion of at least 10,000 vectors or an instructor-approved smaller corpus when the selected dataset subset does not produce 10,000 meaningful units.
Report throughput, rejected records, duplicate handling, query latency samples, index counts, metadata schema, and embedding model version.
```

Gate:

- The same vector key cannot silently refer to different text.
- The embedding model version is stored.
- Source text or generated profile content can be fetched from the vector result through its ordinary S3 pointer.
- Retrieval smoke tests pass.
- Exact counts, shortest paths, components, and bridge metrics come from graph or metric stores, not vector similarity.
- Cost and object counts are reported.

## Phase 9: implement the runtime collaboration-analysis agents

Purpose:

Create the runtime agent workflow that translates a user question into researcher resolution, deterministic graph retrieval, path and community analysis, semantic context retrieval, evidence assembly, answer synthesis, and claim verification.

Why:

A single unrestricted LLM call cannot safely resolve ambiguous researchers, select graph metrics, find coauthor paths, interpret communities, retrieve semantic context, and verify numerical claims. The work must be decomposed into narrow responsibilities with typed contracts.

Use this work order:

```text
Use the rag-engineer agent to implement the runtime ScholarChain collaboration-analysis workflow.

Required runtime agents or stages:

1. QueryPlannerAgent
- Parse the question into a typed QueryPlan.
- Classify requested operations such as researcher ranking, maximum team size, direct coauthors, shortest path, component lookup, community comparison, bridge ranking, temporal comparison, topic filter, institution filter, or semantic explanation.
- Extract researcher names, time windows, topic, venue, institution, and requested ranking metric.
- Select only allowlisted graph and vector operations.
- Never emit arbitrary Cypher or arbitrary AWS operations directly from user text.

2. ResearcherResolverAgent
- Resolve user-supplied names to canonical researcher IDs using the entity-resolution outputs.
- Return multiple candidates when ambiguity remains.
- Include source identifiers, affiliations, coauthor context, and confidence used for disambiguation.
- Abstain rather than silently choose the wrong researcher.

3. CollaborationMetricsAgent
- Retrieve Spark-computed publication count, distinct coauthor count, total coauthor occurrences, average team size, maximum team size, weighted degree, component, community, bridge measure, coreness, and time window as requested.
- Return exact stored values with metric version and run ID.

4. PathFinderAgent
- Execute bounded parameterized Neptune query templates for direct collaborators and shortest coauthorship paths between selected researchers.
- Return researcher IDs, edge weights, supporting publication IDs, years, and provenance for every hop.
- Enforce depth, result-count, and timeout limits.

5. CommunityAnalystAgent
- Retrieve community membership, community size, cross-community edges, bridge metrics, and selected neighboring communities.
- Distinguish high direct degree from high structural bridge importance.

6. SemanticContextAgent
- Query the appropriate S3 Vectors indexes for researcher profiles, community summaries, representative-paper abstracts, topic descriptions, and path summaries.
- Return semantic context with vector scores and source pointers.
- Never treat vector similarity as proof of a coauthorship edge or numerical graph metric.

7. EvidenceBuilderAgent
- Assemble a bounded EvidenceBundle containing canonical researcher IDs, metric records, graph paths, publication support, semantic context, identity-resolution confidence, and source provenance.
- Keep deterministic graph evidence separate from descriptive semantic context.

8. AnswerSynthesisAgent
- Generate a concise collaboration analysis from the EvidenceBundle.
- Create typed AnswerClaim records.
- Associate every material claim with one or more evidence IDs.
- Explain the difference between collaboration breadth, collaboration intensity, team size, connectivity, and bridge importance when relevant.
- State uncertainty and missing evidence.

9. ClaimVerificationAgent
- Verify that cited evidence exists.
- Check every researcher identity, publication title, coauthor count, team-size claim, path hop, community claim, bridge score, time window, and numerical value against the bundle.
- Return VERIFIED, PARTIALLY_SUPPORTED, UNSUPPORTED, or CONFLICTING.

10. Audit stage
- Persist QueryPlan, resolved researcher IDs, evidence IDs, metric versions, graph-run ID, prompt and model versions, token counts where available, latency, verification result, and answer hash.

Required controls:
- Version every prompt and JSON schema.
- Validate every model output before use.
- Retry malformed structured output only within a bounded policy.
- Treat retrieved text as untrusted data, not as instructions.
- Apply context and token budgets.
- Require an abstaining answer when researcher identity or evidence is insufficient.
- Never expose hidden chain-of-thought.

Run sbt check and the benchmark-query suite.
Report prompt versions, schemas, allowed plan operations, identity-resolution behavior, graph query templates, verification rules, abstention behavior, benchmark results, and known failure modes.
```

There is no required universal ranking formula. When a user asks for researchers with the most distinct coauthors, rank by `C_r`. When the user asks for strongest repeated collaboration, use the documented weighted measure. When the user asks for bridge researchers, use the selected bridge metric. A composite score is allowed only when its components, normalization, weights, missing-data behavior, and reason for use are explicit.

Gate:

- User text cannot become arbitrary database code.
- Ambiguous researcher names do not silently resolve to one identity.
- Every numerical and path claim has evidence IDs.
- Unsupported claims are removed, weakened, or explicitly labeled.
- Prompt injection tests pass.
- Deterministic graph retrieval and semantic retrieval are evaluated separately.
- Code review returns APPROVE.

## Phase 10: expose the runtime through RESTful microservices

Purpose:

Create independently scalable services for queries, evidence, graph exploration, jobs, health, and audit access.

Why:

The runtime has fast and slow paths. A simple evidence lookup should not wait behind a large graph expansion or embedding operation. Separate services make resource policies, timeouts, queues, and scaling rules explicit.

Use this work order:

```text
Use the service-engineer agent to implement ScholarChain RESTful microservices in Scala 3.

Required services:

1. Query API
- POST /v1/query
- Validate request.
- Create query ID and idempotency record.
- Start synchronous or asynchronous Graph-RAG workflow.
- Return answer or job reference.

2. Jobs API
- GET /v1/jobs/{jobId}
- GET /v1/jobs/{jobId}/result
- Report state, timestamps, stage, errors, and result link.

3. Evidence API
- GET /v1/evidence/{evidenceId}
- Return provenance, source record, source URI, graph path or text pointer, and compact supporting content.

4. Graph exploration API
- GET /v1/graph/nodes/{nodeId}
- GET /v1/graph/nodes/{nodeId}/neighbors
- Bound depth, edge types, result count, and timeout.

5. Explain and audit API
- GET /v1/explain/{queryId}
- Return QueryPlan, stages executed, prompt versions, model versions, evidence IDs, score components, counters, and verification status.
- Do not return hidden chain-of-thought.

6. Operations endpoints
- GET /healthz
- GET /readyz
- GET /metrics when the deployment model permits it

Required HTTP behavior:
- JSON request and response contracts.
- Path-based API versioning.
- Request IDs and trace IDs.
- Idempotency-Key support for POST operations.
- Pagination or cursoring for graph neighborhoods.
- Timeouts, bounded retries, and circuit breakers.
- Typed error model.
- Authentication and authorization appropriate to the course deployment.
- No secrets or raw credentials in responses or logs.
- Thin routes; application logic belongs in services and ports.

Required tests:
- Successful synchronous query.
- Asynchronous query path.
- Invalid JSON.
- Unsupported query constraint.
- Missing evidence.
- Idempotent repeated request.
- Timeout and downstream failure.
- Unauthorized request.
- Health and readiness distinction.
- Full query-to-evidence lifecycle with fakes.

Run sbt check.
Report route table, status-code mapping, timeout policy, dependency graph, authentication method, and exact test counts.
```

Gate:

- Routes do not embed retrieval algorithms.
- Error responses include trace IDs.
- Health checks do not expose secrets.
- Request and response examples match contract tests.
- At least one end-to-end API test reaches an evidence-backed answer using bounded fixtures.

## Phase 11: adversarial testing and full repository review

Purpose:

Attack the implementation before the cloud bill and grading process do it for you.

Why:

Implementation agents optimize for satisfying their work orders. An independent test agent and a read-only reviewer are needed to search for assumptions, missing edge cases, ownership violations, security failures, and untested behavior.

Use this work order for testing:

```text
Use the test-engineer agent on the complete ScholarChain repository produced through Phase 10.

Add adversarial tests without modifying production code.

Required categories:
- Malformed and truncated DBLP XML.
- Unicode normalization and confusable characters.
- Duplicate and conflicting DOI records.
- Common author names and reordered author lists.
- Very large blocking groups.
- Coauthor edges with unresolved or conflicting researcher endpoints.
- Empty and disconnected graphs.
- Distinct-degree, component, shortest-path, bridge, and k-core known-graph cases.
- Large-team pair expansion and common-name researcher-resolution cases.
- Missing topic, institution, abstract, or researcher-profile metadata.
- Duplicate vector keys and stale model versions.
- Prompt injection in title, abstract, and full-text chunks.
- LLM malformed JSON and fabricated identifiers.
- Unsupported answer claims.
- Neptune timeout.
- DynamoDB conditional-write conflict.
- S3 Vectors throttling or transient failure.
- Replayed workflow and idempotency.
- API authentication, authorization, malformed bodies, and timeouts.
- Logging redaction.
- Configuration omissions.

Run all tests that do not require live AWS. Run bounded AWS integration tests only under the approved profile.
Leave any production defect exposed by a failing test. Report it to the owning agent instead of changing production code.
Report exact test counts, failures, coverage by requirement, and residual risks.
```

Use this work order for review:

```text
Use the code-reviewer agent to perform an adversarial read-only review of the complete repository and the full current diff.

Review in this order:
1. Correctness and data loss.
2. Contract and schema drift.
3. Artifact ownership violations.
4. Security, secrets, IAM assumptions, and injection risks.
5. Hadoop and Spark distribution mistakes.
6. Entity-resolution over-merging and unreported uncertainty.
7. Storage idempotency and provenance.
8. RAG grounding and unsupported claims.
9. API behavior and failure handling.
10. Tests that would pass even if the behavior were broken.
11. Documentation claims not supported by implementation.
12. Cost and cleanup risks.

Verify every candidate finding against the actual files before reporting it.
For each finding provide severity, file and line, concrete failure input, expected impact, and owning agent.
Return APPROVE or REQUEST_CHANGES. Do not edit any file.
```

Repair loop:

```text
1. Orchestrator groups findings by owner.
2. Each owning agent receives only its findings plus necessary context.
3. Agent fixes its owned artifacts and runs its gate.
4. Test engineer reruns relevant adversarial tests.
5. Code reviewer rereads the complete diff.
6. Repeat until APPROVE or human escalation.
```

Gate:

- No critical or major verified finding remains.
- Every production behavior has a relevant test.
- All tests pass under their declared profiles.
- No reviewer wrote production code.
- Repair records identify owners and rerun evidence.

## Phase 12: create the AWS infrastructure in Terraform

Purpose:

Define the complete ScholarChain cloud environment as reviewed, reproducible code.

Why:

Manual cloud assembly creates drift, missing security controls, and a deployment that graders cannot reproduce. Terraform plans make intended changes visible before resources are created.

Use this work order:

```text
Use the infra-engineer agent to create the ScholarChain AWS infrastructure under infra/terraform and the approved operational scripts under scripts.

Required Terraform modules or equivalent organization:

1. Foundation
- Provider versions pinned.
- Remote state design documented.
- Required tags.
- Budget and cost-allocation tags where course accounts allow.

2. Network
- VPC in at least two Availability Zones.
- Public subnets only for approved ingress components.
- Private application and data subnets.
- Route tables, NAT or controlled egress, and VPC endpoints where justified.
- Security groups chained by service role rather than broad CIDR access.

3. Identity and encryption
- Least-privilege roles for EMR, ECS tasks, Step Functions, deployment execution, loaders, and runtime readers.
- Separate runtime and deployment permissions.
- KMS keys or approved AWS-managed encryption choices.
- Secrets Manager records referenced by ARN, never secret values in Terraform source or plans.

4. Data lake
- Raw, curated, graph, RAG, artifact, log, and report S3 buckets or prefixes.
- Versioning where needed.
- Encryption, public-access blocking, lifecycle rules, and deletion safeguards.
- Glue catalog resources when used.

5. EMR
- Hadoop and Spark applications.
- Managed scaling or instance-fleet policy.
- Log and bootstrap configuration.
- Bounded default capacity.
- Spot task capacity only when failure behavior is handled.

6. DynamoDB
- Required tables and indexes.
- On-demand or autoscaled provisioned capacity with justification.
- Point-in-time recovery where appropriate.

7. Neptune
- Cluster or serverless configuration.
- Subnet and parameter groups.
- Encryption, backups, deletion protection for non-ephemeral environments.
- Loader role and read-only runtime role.

8. S3 Vectors
- Vector bucket resources.
- Index resources for every required index.
- Encryption, tags, and access policies.
- Use current Terraform provider resources supported at implementation time and pin the provider version.

9. Optional OpenSearch
- Deploy only when used by an implemented and evaluated hot or hybrid tier.
- Define access, encryption, logging, and capacity policy.

10. Runtime compute
- ECR repositories with immutable Git SHA tags and scan-on-push.
- ECS cluster and Fargate task definitions.
- Services for query, graph retrieval, vector retrieval, ranking, answer synthesis, verification, and workers, or a justified consolidation that preserves independent scaling where needed.
- Internal service discovery and approved ingress.

11. Workflow and messaging
- Step Functions state machines.
- SQS queues and dead-letter queues.
- EventBridge rules when used.

12. Observability
- CloudWatch log groups.
- Dashboards and alarms.
- Metrics for EMR, ECS, SQS, Neptune, DynamoDB, S3 Vectors clients, API latency, LLM usage, and errors.

13. Cost and safety
- Bounded defaults.
- Environment-specific variable files without secrets.
- Deletion protection for stateful resources in persistent environments.
- Explicit cleanup mode for the course environment.

Required scripts:
- plan.sh
- deploy.sh
- rollback.sh
- smoke-test.sh
- run-bounded-pipeline.sh
- cleanup.sh

Script requirements:
- bash strict mode.
- No interactive prompts inside agent-run scripts.
- Refuse dirty source trees before deployment.
- Tag images by Git SHA.
- Print greppable step markers.
- Verify the deployed revision.
- Fail loudly with evidence.
- Never hide terraform plan output.
- Cleanup requires explicit human invocation and lists affected resources before deletion.

Run terraform fmt -check, terraform validate, a non-destructive plan, shell syntax checks, and security scans selected by the team.
Present the complete plan summary, add/change/destroy counts, estimated high-cost resources, stateful replacements, IAM changes, and required human actions. Do not apply.
```

Gate:

- Terraform plan contains no unexplained destroy or replacement of stateful resources.
- IAM policies are scoped to actual resources and actions.
- Buckets and databases are not public.
- Default capacity is bounded.
- Secrets do not appear in source or plan output.
- Human reviews and signs the plan before any apply.
- Code reviewer approves the infrastructure diff.

## Phase 13: create reproducible build, deployment, and experiment automation

Purpose:

Provide source-controlled commands that reproduce validation, packaging, Terraform planning, deployment, bounded pipeline execution, smoke testing, experiments, evidence archiving, and cleanup without depending on a separately administered CI or CD server.

Why:

A project is not reproducible when its successful deployment depends on undocumented commands remembered by one student. The authoritative procedures must live in the repository as inspectable scripts that a grader can run directly.

Use this work order:

```text
Use the infra-engineer agent to create or finalize the source-controlled automation under scripts/ and any optional GitHub Actions workflows that call those scripts.

Required scripts or equivalent commands:

1. scripts/check.sh
- Validate agent constitution files and JSON configuration.
- Run hook syntax checks.
- Run scalafmt check, sbt Test/compile, sbt test, contract validation, schema validation, and shell syntax checks.
- Run Terraform format and validate.
- Exit nonzero on any failed gate.

2. scripts/package.sh
- Build Hadoop and Spark artifacts.
- Build required service images.
- Record checksums and image tags derived from the Git commit SHA.

3. scripts/plan.sh
- Run Terraform plan for the selected environment.
- Record plan file, plan checksum, commit SHA, target account and Region, and a summary of add, change, destroy, IAM, and stateful-resource actions.
- Never apply automatically.

4. scripts/deploy.sh
- Refuse a dirty tree.
- Require an explicitly approved plan checksum or the documented human-approval mechanism.
- Apply or invoke the approved deployment path exactly as documented.
- Record deployed image digests and revisions.

5. scripts/smoke-test.sh
- Check health and readiness.
- Run a bounded researcher query.
- Fetch evidence for at least one returned claim.
- Verify idempotency and one expected error path.

6. scripts/run-bounded-pipeline.sh
- Run or submit the approved bounded Hadoop and Spark pipeline.
- Record dataset snapshot, run IDs, configuration, and output locations.

7. scripts/run-experiment.sh or an equivalent manifest-driven command
- Execute only approved experiment manifests.
- Record commit SHA, resource limits, start and end times, Region, and metric locations.

8. scripts/archive-evidence.sh
- Gather test reports, plan checksum, image digests, run manifests, selected CloudWatch metric exports, experiment outputs, and release metadata into a versioned evidence directory or approved S3 prefix.

9. scripts/cleanup.sh
- List resources targeted for removal.
- Require the documented human confirmation for destructive actions.
- Preserve required state, logs, or final reports according to the cleanup policy.

Automation requirements:
- Bash strict mode or an equivalently strict scripting language configuration.
- No secrets in source control or command output.
- Timeouts on cloud operations.
- Retry only safe idempotent actions.
- Greppable step markers and explicit exit codes.
- Commands must work from a clean checkout after documented prerequisites are installed.
- Optional GitHub Actions may call these scripts, but the scripts remain the authoritative reproducibility interface.

Run every non-destructive script in the bounded non-production environment.
Report command lines, required environment variables by name, human approval points, generated evidence, and rollback behavior.
```

Gate:

- A clean checkout can run all non-cloud validation through the documented script.
- Terraform planning is reproducible and the plan checksum is archived.
- Deployment cannot proceed without the documented human approval.
- Smoke tests exercise a real bounded collaboration query.
- The same scripts are used in the README reproduction instructions and final demonstration.

## Phase 14: apply and deploy through human approval

Purpose:

Create the approved cloud environment and deploy the validated application.

Why:

Authoring infrastructure and operating infrastructure are separate duties. The deployment agent executes approved machinery and reports reality; it does not improvise unreviewed resources.

Before starting:

- Human verifies the Terraform plan checksum.
- Human confirms the target AWS account and Region.
- Human confirms cost bounds.
- Human confirms no unexplained destroy or replacement.
- Human approves the documented deployment command and approved Terraform apply path.

Use this work order after approval:

```text
Use the deploy-engineer agent to deploy the exact approved ScholarChain commit and Terraform plan to the approved course environment.

Requirements:
- Refuse a dirty working tree.
- Record commit SHA, plan checksum, target account, Region, and environment.
- Execute only approved source-controlled deployment scripts.
- Do not edit Terraform, scripts, or application source.
- Wait for service stabilization with a bounded timeout.
- Verify deployed image digests and task revisions.
- Run smoke-test.sh.
- On failure, collect evidence and follow the approved rollback policy.
- Do not perform destructive data repair.
- Return a deployment report with outputs, health status, smoke results, revisions, alarms, and any rollback action.
```

Gate:

- Services are healthy and ready.
- Deployed image digests match the commit.
- Smoke query returns an evidence-backed response using bounded fixtures or loaded sample data.
- No critical alarm remains active.
- Deployment report is archived.

## Phase 15: run the data pipeline and elasticity experiments

Purpose:

Demonstrate that the system processes real data and changes resource levels in response to load.

Why:

An architecture diagram with autoscaling arrows proves only that the student knows how to draw arrows. The project must show measured scaling events, throughput, latency, backlog, and cost behavior.

Use this work order:

```text
Use the experiment-engineer agent to execute approved ScholarChain data and elasticity experiments without modifying production algorithms.

Experiment A: Hadoop and Spark baseline
- Run the bounded corpus at minimum EMR capacity.
- Record input records, output records, task counts, duration, shuffle, failures, and estimated cost.

Experiment B: Hadoop and Spark burst
- Run a larger manifest or higher partition count.
- Observe EMR managed scaling or the approved instance-fleet response.
- Record requested, provisioned, and released capacity over time.

Experiment C: embedding backlog
- Enqueue a controlled number of text chunks.
- Observe SQS queue depth, embedding-worker task count, throughput, retry count, and drain time.

Experiment D: query load
- Run at least four concurrency levels such as 1, 10, 50, and 100 concurrent clients, adjusted for budget.
- Measure p50, p95, p99 latency, throughput, error rate, ECS task count, CPU, memory, Neptune latency, DynamoDB throttles, vector-query latency, and LLM latency.

Experiment E: retrieval modes
- Compare graph-only, S3-Vectors-only, and fused retrieval.
- If OpenSearch is implemented, compare the hot or hybrid tier as a fourth mode.

Experiment F: failure and recovery
- Trigger one safe failure such as a worker termination, transient downstream failure, or poison message.
- Show retry, dead-letter, idempotency, and recovery behavior.

Rules:
- Every experiment has a committed YAML or JSON manifest.
- Raw metrics are immutable after collection.
- Derived plots and tables are reproducible from scripts.
- Record commit SHA, dataset snapshot, configuration, resource limits, start and end time, Region, and run IDs.
- Never silently discard failed runs.
- Do not tune the implementation during a run and report the result as one experiment.

Produce raw data, plots, a results summary, and a limitations section.
```

Required scaling rules include:

| Component | Required rule or policy | Required evidence |
|---|---|---|
| EMR | Managed scaling or justified fleet policy with bounded minimum and maximum | Node or capacity units over time, pending work, duration |
| Embedding workers | ECS target tracking or step scaling on SQS backlog per task | Queue depth, desired and running tasks, drain time |
| Graph retriever | ECS target tracking on CPU or request count with latency alarm | Task count, CPU, p95 latency |
| Vector retriever | ECS target tracking on CPU or request count | Task count, query latency, errors |
| Rank and synthesis services | Queue depth, CPU, or request-based scaling with bounded maximum | Task count, queue, p95 latency, LLM latency |
| DynamoDB | On-demand or autoscaled provisioned capacity | Consumed capacity and throttles |
| Step Functions and SQS | Retry and dead-letter policy rather than manual polling loops | Execution state, retries, dead-letter count |

Gate:

- At least one scale-out and one scale-in event are shown.
- Metrics use synchronized timestamps.
- Raw experiment data is preserved.
- Costs and limits are stated.
- Failures are reported, not edited out of existence.

## Phase 16: evaluate data quality, retrieval, answers, and the agentic factory

Purpose:

Evaluate the system scientifically rather than judging it from a few attractive answers.

Why:

A polished LLM paragraph can conceal bad entity links, weak retrieval, unsupported claims, or expensive execution. The project needs separate measurements for every important stage.

Use this work order:

```text
Use the experiment-engineer agent to run the approved evaluation suite and the documentation-engineer to prepare the results after raw outputs are frozen.

Required evaluation groups:

1. Entity resolution
- Precision, recall, F1, confusion matrix, coverage, unresolved rate, and metrics by matching path.

2. Graph correctness
- Referential integrity, duplicate rate, orphan rate, coauthor-edge support rate, known small-graph degree, component, path, community, bridge, and k-core tests, and sampled provenance audit.

3. Retrieval
- Recall at K.
- Precision at K when labels support it.
- Mean reciprocal rank.
- nDCG when graded relevance labels exist.
- Results for graph-only, vector-only, and fused retrieval.
- Optional OpenSearch comparison.

4. Answer quality
- Claim support rate.
- Coauthor-edge, graph-path, and supporting-publication validity.
- Identifier and numerical accuracy.
- Contradiction rate.
- Abstention quality.
- Human rating rubric for usefulness and clarity.

5. Performance and elasticity
- Throughput, p50, p95, p99, errors, scaling delay, recovery time, and estimated cost.

6. Agentic software factory
- First-pass acceptance rate by agent.
- Number of BLOCKED-ON events.
- Number of ownership violations caught.
- Number and severity of reviewer findings.
- Repair iterations per phase.
- Manual interventions.
- Tests or hooks that prevented an unsafe action.
- Agent-generated artifacts that required substantial human rewrite.

7. Reproducibility
- Clean-checkout build success.
- Replay of bounded pipeline.
- Deployment from approved plan.
- Ability to regenerate reported tables and plots.

Freeze raw outputs before writing conclusions.
Report confidence intervals or variability where repeated runs are feasible.
State threats to validity and missing data.
```

Gate:

- Evaluation data is not generated by the same prompt that produces the answer under evaluation without independent review.
- Benchmark questions and relevance labels are versioned.
- The report separates measured facts from interpretation.
- Negative results remain in the submission.

## Phase 17: produce documentation, final review, and release

Purpose:

Turn the implementation and experiments into a reproducible course submission.

Why:

A distributed system that only its authors can run is a temporary performance, not an engineering deliverable.

Use this work order:

```text
Use the documentation-engineer agent to create the complete ScholarChain documentation from verified repository state and archived experiment evidence.

Required documentation:
- README.md with student name, university email, project summary, architecture, prerequisites, exact build commands, exact local test commands, exact Terraform plan commands, deployment path, bounded data-run path, query examples, cleanup path, and known limitations.
- docs/architecture.md with build-time and runtime diagrams.
- docs/agents.md already owned by factory-engineer and referenced, not rewritten.
- docs/data-lineage.md tracing source dataset to Hadoop output, Spark output, stores, evidence, and answer.
- docs/threat-model.md covering prompt injection, data poisoning, credential exposure, over-permission, denial of service, destructive commands, and provenance tampering.
- docs/service-limits.md recording the current verified limits and Region availability used by the implementation.
- docs/runbook.md covering deployment, smoke tests, common failures, rollback, incident escalation, and cleanup.
- docs/evaluation.md with methods, raw-result pointers, tables, plots, uncertainty, and threats to validity.
- reports/final-report.md with problem, motivation, architecture, implementation, agentic workflow, experiments, results, costs, failures, lessons, and limitations.
- docs/demo-script.md for the final demonstration.
- An API specification or route reference.
- A complete deliverable index.

Rules:
- Replay commands before documenting them.
- Do not invent successful results.
- Link every result table to raw or derived evidence.
- State when an optional component was not implemented.
- Do not edit docs/agents.md or constitutional artifacts; route corrections to factory-engineer.

After documentation, use code-reviewer for a final read-only repository review and test-engineer for a final test run.
Create a release manifest containing commit SHA, image digests, Terraform plan checksum, dataset snapshots, run IDs, prompt versions, model versions, test counts, and artifact checksums.
```

Final gate:

- `sbt clean check` succeeds from a clean checkout.
- Terraform validates and the archived plan matches the deployed environment or documented final state.
- README commands have been replayed.
- The bounded pipeline can be rerun.
- Query and evidence examples work.
- Final reviewer returns APPROVE.
- Cleanup script has been rehearsed in a safe environment.
- Release manifest is complete.

## Detailed Hadoop requirements

The Hadoop implementation must document every mapper and reducer contract. A diagram that says "Hadoop processes DBLP" is insufficient.

For each job, document:

- Input format.
- Input key and value.
- Mapper output key and value.
- Combiner behavior when used.
- Partitioner behavior.
- Reducer input and output.
- Counter names.
- Reject conditions.
- Expected number of reducers.
- S3 input and output prefixes.
- Compression codec.
- Idempotency rule.
- Test fixture.

A recommended job chain is:

```text
J01 DblpExtractJob
  DBLP XML -> normalized DBLP WorkRecord

J02 SourceNormalizeJob
  OpenAlex/Crossref/OpenCitations/arXiv/S2/PWC -> normalized source records

J03 ExactIdentifierIndexJob
  normalized records -> DOI, arXiv, ORCID, OpenAlex, and S2 keyed indexes

J04 ExactIdentifierJoinJob
  keyed indexes -> exact matches and exact conflicts

J05 BlockingKeyJob
  unmatched records -> bounded title, author, year, venue, and coauthor blocks

J06 CandidateJoinJob
  blocks -> MatchCandidate feature records

J07 PublicationTeamJob
  normalized DBLP works -> author-paper records and publication-team records

J08 CoauthorPairExpansionJob
  publication teams -> unordered coauthor pair candidates with work and year provenance

J09 GraphCandidateExportJob
  normalized records, match decisions, authorship, and pair candidates -> Spark-ready collaboration inputs
```

The DBLP XML reader must not assume that arbitrary byte splits align with publication elements. Students may implement or adapt an XML input format that synchronizes on complete top-level records. The parser must be tested against entity declarations, multiline titles, Unicode, missing optional fields, repeated authors, and records near split boundaries.

A giant reducer group is a correctness and availability risk. The blocking design must include maximum block size, fallback keys, counters, and a policy for oversize groups. Simply allocating a larger reducer is not a strategy.

## Detailed Spark requirements

The Spark pipeline must consume Hadoop outputs rather than independently reparse all raw data. This preserves the intended chained workflow and makes the coauthorship graph traceable to the publication-team records produced by MapReduce.

For each Spark job, document:

- Input tables and schema versions.
- Output tables and schema versions.
- Selected time window or snapshot.
- Partition columns.
- Repartition and coalesce operations.
- Join strategies.
- Broadcast assumptions.
- Cache or persistence decisions.
- Checkpoint decisions.
- Expected shuffle boundaries.
- Driver memory assumptions.
- Invariants and counters.

Recommended output layout:

```text
s3://scholarchain-curated/
  works/snapshot=.../run_id=.../
  author-mentions/snapshot=.../run_id=.../
  researchers/snapshot=.../run_id=.../
  authorship/snapshot=.../run_id=.../
  coauthor-pair-candidates/snapshot=.../run_id=.../
  match-decisions/policy=.../run_id=.../

s3://scholarchain-graph/
  nodes/type=researcher/run_id=.../
  nodes/type=work/run_id=.../
  nodes/type=topic/run_id=.../
  edges/type=authored/run_id=.../
  edges/type=coauthored_with/run_id=.../
  edges/type=has_topic/run_id=.../
  metrics/type=researcher_collaboration/window=.../run_id=.../
  metrics/type=components/window=.../run_id=.../
  metrics/type=communities/window=.../run_id=.../
  metrics/type=bridges/window=.../run_id=.../
  metrics/type=kcore/window=.../run_id=.../
  path-evidence/window=.../run_id=.../
  semantic-summaries/window=.../run_id=.../
```

The team must include at least one small graph whose distinct degree, weighted degree, connected components, shortest paths, community behavior, bridge behavior, and k-core or equivalent result can be checked by hand. A billion-edge result is not trustworthy merely because it took a long time to compute.

## S3 Vectors design

Amazon S3 Vectors is the default durable semantic retrieval tier for ScholarChain. The vector store supplies semantic context for researchers and collaboration communities. It does not replace the exact coauthorship graph or Spark-computed metrics.

Recommended vector indexes are:

| Index | Stored semantic unit | Typical filter fields |
|---|---|---|
| `researcher-profile-v1` | Generated profile from representative papers, topics, institutions, years, and collaboration statistics | researcher ID, period, topic, institution |
| `collaboration-community-v1` | Generated community description from member topics, institutions, representative works, and aggregate graph statistics | community ID, period, dominant topic |
| `paper-abstract-v1` | One permitted abstract or compact paper summary | year, venue, topic, source, work ID |
| `collaboration-path-v1` | Natural-language rendering of a verified coauthor path | start researcher, end researcher, path length, period |
| `topic-institution-summary-v1` | Topic and institution summaries used to explain cross-community context | topic ID, institution ID, period |

Example vector metadata:

```json
{
  "researcherId": "openalex:A123",
  "documentType": "researcher-profile",
  "windowStartYear": 2015,
  "windowEndYear": 2026,
  "topicId": "openalex:T123",
  "institutionId": "ror:example",
  "textS3Uri": "s3://scholarchain-rag/profiles/researcher/A123.json",
  "textHash": "sha256:...",
  "embeddingModel": "model-id-and-version",
  "runId": "run-..."
}
```

Do not store long source text as vector metadata when an S3 pointer is sufficient. Metadata should support filtering, provenance, and source retrieval. Ordinary S3 remains the authoritative text store. Exact collaboration counts, edge weights, communities, path hops, and bridge scores must come from Neptune, DynamoDB, or Spark outputs, not from vector similarity.

## Optional OpenSearch tier

OpenSearch is optional. It is justified when the application implements one or more of the following:

- Hybrid BM25 and vector retrieval.
- Faceted search by year, venue, topic, author, or institution.
- A measured low-latency hot tier for frequently queried topics.
- Aggregations not provided by the S3 Vectors access pattern.

A team that deploys OpenSearch must evaluate it. Adding an expensive cluster because it appears in an architecture blog is not sophistication; it is cloud cosplay with a monthly invoice.

The optional tier must document:

- Which records are promoted.
- Promotion and eviction policy.
- Synchronization source.
- Rebuild procedure.
- Consistency expectations.
- Query routing policy.
- Measured latency and retrieval quality.
- Incremental cost.

## Runtime microservice graph

The runtime services and agents should be connected as an explicit workflow graph.

```text
Client
  |
  v
Query API
  |
  v
QueryPlannerAgent
  |
  v
ResearcherResolverAgent
  |
  +----------------------+----------------------+----------------------+
  |                      |                      |                      |
  v                      v                      v                      v
CollaborationMetrics   PathFinderAgent     CommunityAnalystAgent   SemanticContextAgent
  |                      |                      |                      |
  +----------------------+-----------+----------+----------------------+
                                     |
                                     v
                           EvidenceBuilderAgent
                                     |
                                     v
                           AnswerSynthesisAgent
                                     |
                                     v
                           ClaimVerificationAgent
                                     |
                                     v
                              Query Audit Store
```

The deterministic graph services are authoritative for counts, path hops, components, communities, and bridge metrics. The semantic context service explains topics, institutions, and representative work. The synthesis agent may interpret these results but may not alter them.

## REST API contract

The following API is the minimum required surface. Endpoint names may change when the submitted OpenAPI contract is internally consistent.

## POST /v1/query

Request:

```json
{
  "question": "Which researchers have the most distinct coauthors in distributed systems since 2015, which of them participated in the largest author teams, and which are the strongest bridges between collaboration communities?",
  "constraints": {
    "yearFrom": 2015,
    "yearTo": 2026,
    "topics": ["distributed systems"],
    "institutions": [],
    "venues": []
  },
  "analysis": {
    "rankingMetric": "DISTINCT_COAUTHOR_COUNT",
    "includeTeamSize": true,
    "includeBridgeMetrics": true,
    "includeCommunities": true,
    "includePaths": true
  },
  "retrieval": {
    "graphLimit": 100,
    "vectorLimit": 30,
    "maxPathDepth": 6
  },
  "output": {
    "includeEvidence": true,
    "includeScores": true,
    "includeUncertainty": true
  }
}
```

Synchronous response:

```json
{
  "queryId": "qry-01J...",
  "mode": "synchronous",
  "answer": {
    "summary": "...",
    "researchers": [
      {
        "researcherId": "openalex:A123",
        "displayName": "Example Researcher",
        "publicationCount": 87,
        "distinctCoauthorCount": 142,
        "weightedDegree": 211,
        "averageCoauthorsPerPaper": 4.6,
        "maximumCoauthorsOnOnePaper": 28,
        "maximumTeamWorkIds": ["dblp:conf/example/Example2024"],
        "componentId": "cc-1",
        "communityId": "community-17",
        "bridgeMetric": {"name": "approxBetweenness", "value": 0.812},
        "claimIds": ["claim-1", "claim-2"]
      }
    ]
  },
  "claims": [
    {
      "claimId": "claim-1",
      "text": "The researcher has 142 distinct coauthors in the selected 2015 to 2026 window.",
      "evidenceIds": ["ev-metric-17"],
      "verificationStatus": "VERIFIED",
      "uncertainty": "The value depends on the submitted researcher-identity resolution policy and dataset snapshots."
    }
  ],
  "links": {
    "evidence": "/v1/queries/qry-01J.../evidence",
    "explain": "/v1/explain/qry-01J..."
  }
}
```

Asynchronous response:

```json
{
  "queryId": "qry-01J...",
  "mode": "asynchronous",
  "jobId": "job-01J...",
  "status": "QUEUED",
  "statusUrl": "/v1/jobs/job-01J..."
}
```

## GET /v1/jobs/{jobId}

Response:

```json
{
  "jobId": "job-01J...",
  "queryId": "qry-01J...",
  "state": "RUNNING",
  "stage": "CLAIM_VERIFICATION",
  "createdAt": "2026-09-14T18:00:00Z",
  "updatedAt": "2026-09-14T18:00:12Z",
  "resultUrl": null,
  "error": null
}
```

## GET /v1/evidence/{evidenceId}

Response:

```json
{
  "evidenceId": "ev-work-33",
  "evidenceType": "TEXT_CHUNK",
  "workId": "doi:10.1234/example",
  "sourceDataset": "s2orc",
  "sourceRecordId": "s2:abc",
  "snapshot": "2026-08-01",
  "text": "A bounded supporting excerpt or generated path summary.",
  "textS3Uri": "s3://scholarchain-rag/chunks/...",
  "score": 0.842,
  "provenance": {
    "runId": "run-...",
    "textHash": "sha256:...",
    "schemaVersion": "evidence-v1"
  }
}
```

## GET /v1/graph/nodes/{nodeId}/neighbors

Parameters:

```text
direction=in|out|both
depth=1..3
limit=1..200
edgeTypes=COAUTHORED_WITH,AUTHORED,HAS_TOPIC,AFFILIATED_WITH,PUBLISHED_IN
```

The server must reject unbounded graph exploration.

## GET /v1/explain/{queryId}

Response content:

- Normalized QueryPlan.
- Retrieval modes selected.
- Parameterized query-template IDs.
- Indexes queried.
- Metadata filters.
- Score components and weights.
- Prompt versions.
- Model versions.
- Evidence IDs.
- Claim-verification outcomes.
- Latency and retry counters.
- Cache hits.

The endpoint must not reveal secret prompts, credentials, or private chain-of-thought.

## Error model

Required error classes include:

| HTTP status | Meaning |
|---|---|
| 400 | Malformed request or invalid field |
| 401 | Missing or invalid authentication |
| 403 | Authenticated caller lacks permission |
| 404 | Unknown query, job, node, or evidence ID |
| 409 | Idempotency conflict or incompatible state |
| 422 | Valid JSON with unsupported constraints or retrieval plan |
| 429 | Rate or budget limit exceeded |
| 502 | Downstream service failure |
| 503 | Service not ready or temporarily unavailable |
| 504 | Workflow or downstream timeout |
| 500 | Unexpected internal failure with trace ID |

Example:

```json
{
  "error": "UNSUPPORTED_RETRIEVAL_MODE",
  "message": "Hybrid retrieval is not enabled in this deployment.",
  "traceId": "trace-01J...",
  "retryable": false
}
```

## Example evidence-backed workflow

User question:

```text
Which researchers have the most distinct coauthors in distributed systems since 2015, and which of them are the strongest bridges between otherwise separate collaboration communities?
```

The runtime performs these steps:

1. QueryPlannerAgent identifies a researcher-ranking request with a 2015 to 2026 time window, a distributed-systems topic constraint, distinct-coauthor ranking, and bridge comparison.
2. ResearcherResolverAgent resolves any explicitly named researchers and validates canonical identities used by the retrieved rankings.
3. CollaborationMetricsAgent retrieves `P_r`, `C_r`, `T_r`, `A_r`, `M_r`, weighted degree, component, community, bridge metric, and coreness for the selected window.
4. PathFinderAgent retrieves bounded supporting coauthor paths and publication evidence for selected bridge claims.
5. CommunityAnalystAgent retrieves community sizes, cross-community links, and the evidence explaining why a researcher has high structural bridge importance.
6. SemanticContextAgent retrieves researcher and community profiles plus representative paper or topic summaries from S3 Vectors.
7. EvidenceBuilderAgent creates a bounded evidence bundle that keeps graph facts separate from semantic descriptions.
8. AnswerSynthesisAgent explains the difference between direct collaboration breadth and structural bridge importance.
9. ClaimVerificationAgent checks every name, count, metric, path hop, publication, and time window against the evidence bundle.
10. Unsupported claims are removed or marked uncertain, and the audit service stores the observable derivation.

An acceptable final answer structure is:

```text
Researcher 1
- Distinct coauthors in selected window: 142
- Publications: 87
- Average coauthors per paper: 4.6
- Maximum coauthors on one paper: 28
- Weighted collaboration degree: 211
- Collaboration community: 17
- Bridge metric: approximate betweenness 0.812
- Interpretation: broad collaboration network and strong cross-community position
- Evidence: metric record M17, coauthor edges E1 through E4, representative works W2 and W9

Researcher 2
- Distinct coauthors in selected window: 168
- Publications: 91
- Average coauthors per paper: 6.1
- Maximum coauthors on one paper: 41
- Weighted collaboration degree: 259
- Collaboration community: 23
- Bridge metric: approximate betweenness 0.311
- Interpretation: larger direct collaboration network than Researcher 1, but weaker structural bridge position because most collaborators lie in the same dense community
- Evidence: metric record M22, community record C23, representative works W11 and W19
```

The numbers above are illustrative placeholders for the API format. The submitted system must return real values from its deployed corpus and label every example in documentation that does not come from an actual run.

## Configuration

All environment-specific values must be externalized. A recommended configuration shape is:

```yaml
application:
  environment: "dev"
  region: "us-east-1"

storage:
  rawBucket: "${RAW_BUCKET}"
  curatedBucket: "${CURATED_BUCKET}"
  graphBucket: "${GRAPH_BUCKET}"
  ragBucket: "${RAG_BUCKET}"

neptune:
  endpoint: "${NEPTUNE_ENDPOINT}"
  port: 8182
  queryTimeoutMs: 5000

s3Vectors:
  vectorBucket: "${VECTOR_BUCKET}"
  indexes:
    researchers: "researcher-profile-v1"
    communities: "collaboration-community-v1"
    abstracts: "paper-abstract-v1"
    paths: "collaboration-path-v1"
    topicInstitutions: "topic-institution-summary-v1"

entityResolution:
  policyVersion: "er-v1"
  acceptThreshold: 0.93
  rejectThreshold: 0.35
  llmBandMin: 0.65
  llmBandMax: 0.93

retrieval:
  graphLimit: 100
  vectorLimit: 50
  contextTokenBudget: 12000
  fusionPolicyVersion: "fusion-v1"

models:
  embeddingModel: "${EMBEDDING_MODEL_ID}"
  synthesisModel: "${SYNTHESIS_MODEL_ID}"
  verificationModel: "${VERIFICATION_MODEL_ID}"

operations:
  synchronousDeadlineMs: 15000
  maxWorkflowRetries: 2
  maxConcurrentLlmCalls: 8
```

The values shown are examples, not required defaults. Thresholds and budgets must be justified and evaluated.

## Observability requirements

Every runtime request must have a trace ID propagated across services and workflow steps. Logs must be structured and must not contain secrets or full sensitive payloads.

Required metrics include:

- Hadoop records in, records out, rejects, conflicts, and oversize blocks.
- Spark stage duration, task failures, shuffle read and write, executor count, and skew indicators.
- Neptune query duration and error count.
- DynamoDB consumed capacity, throttles, conditional failures, and latency.
- S3 Vectors write throughput, query duration, rejected vectors, and retries from the application client.
- Optional OpenSearch query duration and error count.
- SQS queue depth, age of oldest message, and dead-letter count.
- ECS desired, pending, and running task counts.
- API request count, p50, p95, p99, status codes, and timeouts.
- LLM request count, model ID, latency, retry count, and token usage where available.
- Claim verification status counts.
- Evidence-bundle size.
- Answer abstention rate.

The final dashboard must make at least one elasticity run understandable without opening raw logs.

## Security requirements

The threat model must cover at least:

- Prompt injection in paper titles, abstracts, full text, institution descriptions, topic summaries, and generated profile text.
- Data poisoning through malicious or erroneous source records.
- Fabricated researcher identifiers, publication identifiers, coauthorship edges, and path links.
- Over-permissioned IAM roles.
- Secret exposure in logs, prompts, Terraform state, deployment-script output, or Git history.
- Unbounded graph queries.
- LLM cost exhaustion.
- Queue flooding.
- Malformed or decompression-bomb inputs.
- Cross-tenant or unauthorized evidence access when authentication is enabled.
- Destructive agent commands.
- Terraform state compromise.
- Provenance or audit-record tampering.

Required controls include:

- Treat retrieved documents as data, never as system instructions.
- Allowlisted query plans and parameterized graph queries.
- JSON schema validation for every model output.
- Bounded inputs, outputs, retries, graph depth, and concurrency.
- Least-privilege IAM roles.
- Separate deployment and runtime roles.
- Encryption in transit and at rest.
- Secrets Manager and role-based or environment-scoped credential injection.
- Immutable image tags.
- CloudTrail or equivalent account audit where available.
- Versioned prompts and model identifiers.
- Content hashes for evidence text.
- Conditional DynamoDB writes for audit records.
- Human approval for destructive and high-cost actions.

## Cost controls

The project must define a cost budget before deployment. At minimum:

- Use bounded EMR defaults.
- Terminate ephemeral EMR clusters after jobs complete.
- Avoid always-on OpenSearch unless the optional tier is implemented and evaluated.
- Use S3 lifecycle policies for intermediate data.
- Use DynamoDB on-demand mode for uncertain low-volume workloads or justify provisioned capacity.
- Set ECS service maximums.
- Set SQS-driven worker maximums.
- Set model-call concurrency and token budgets.
- Tag resources by course, project, environment, owner, and expiration date.
- Create cost alarms or budget notifications when the account permits it.
- Provide a cleanup script and resource inventory.

The final report must estimate cost by major experiment and explain the largest cost drivers.

## Required deliverables

The submission must include every deliverable below. A link in the README should point to each item.

| ID | Deliverable | Minimum contents |
|---|---|---|
| D01 | Private Git repository | Complete source, history, tags, and instructor access |
| D02 | Agentic constitution | `CLAUDE.md`, `docs/agents.md`, every `.claude/agents/*.md` file used in the project, settings, hooks, commands, MCP configuration, tool-version record, and instructions for invoking every agent |
| D03 | Agent run evidence | Phase prompts, final reports, human gates, repair records, and commit hashes |
| D04 | Deterministic build | Multi-project sbt build, format rules, pinned versions, and `sbt check` |
| D05 | Dataset package | Manifest, schemas, samples, license notes, checksums, and bounded retrieval scripts |
| D06 | Hadoop package | MapReduce jobs, tests, job contracts, counters, reject handling, and run scripts |
| D07 | Entity-resolution package | Features, policy, thresholds, LLM adjudication schema, gold set, and evaluation |
| D08 | Spark package | Graph builder, analytics, tests, output schemas, and bounded run results |
| D09 | Storage package | S3, Neptune, DynamoDB, S3 Vectors, and optional OpenSearch adapters and loaders |
| D10 | Runtime collaboration-analysis package | Query planning, graph and vector retrieval, fusion, synthesis, verification, prompts, and tests |
| D11 | Microservices package | REST services, API contract, health checks, authentication, and tests |
| D12 | Terraform package | Complete IaC, environment configuration, validation, plan, and security scan results |
| D13 | Reproducibility automation package | Source-controlled check, package, plan, deploy, smoke-test, bounded-pipeline, experiment, evidence-archive, and cleanup scripts plus optional CI workflow evidence |
| D14 | Deployment package | Release manifest, image digests, deployed revisions, smoke tests, and rollback evidence |
| D15 | Experiment package | Manifests, load generators, raw metrics, derived plots, elasticity evidence, and failure run |
| D16 | Evaluation package | Entity, graph, retrieval, answer, performance, factory, and reproducibility evaluations |
| D17 | Documentation package | README, architecture, data lineage, threat model, limits, runbook, evaluation, and API reference |
| D18 | Final report | Complete technical and experimental report in Markdown or instructor-approved format |
| D19 | Demonstration video | Narrated system demonstration with required evidence |
| D20 | Cleanup evidence | Resource inventory before and after cleanup, with retained-state explanation |

## Agent-generated deliverable evidence

For each phase, `docs/agent-runs/phase-NN/` must contain:

```text
prompt.md
agent-report.md
review-report.md when applicable
test-report.md when applicable
human-gate.md
repair-01.md when applicable
commit.txt
```

The human-gate file must state:

- What was reviewed.
- What was accepted or rejected.
- Any manual changes.
- Any remaining risk.
- The accepted commit hash.

Manual editing is not automatically prohibited, but it must be disclosed. The final report must distinguish:

- Agent-generated and accepted without code change.
- Agent-generated and repaired by another agent.
- Agent-generated and manually edited.
- Human-authored prompts, labels, decisions, and explanations.

A repository with no agent evidence does not satisfy the agentic workflow requirement, even when its code happens to work.

## Baseline submission

A baseline submission must satisfy all of the following:

- The repository builds with `sbt clean check` from a clean checkout.
- The agentic constitution and ownership rules are present and validated.
- DBLP plus at least three additional datasets are represented in the manifest and actual bounded pipeline.
- Hadoop MapReduce parses and normalizes real records.
- Entity resolution produces evaluated decisions.
- Spark creates the coauthorship graph and computes at least distinct coauthor count, weighted degree, team-size statistics, connected components, communities, one bridge measure, and k-core or a justified equivalent.
- Neptune stores and answers graph queries.
- DynamoDB stores run or query state.
- S3 Vectors stores and retrieves real embeddings.
- At least three independently deployable runtime services exist.
- A runtime query produces an answer with evidence IDs.
- Unsupported claims are rejected or labeled.
- Terraform creates the required environment or a documented instructor-approved subset.
- Source-controlled scripts reproduce build, test, Terraform planning, approved deployment, smoke testing, bounded data processing, experiment execution, evidence archiving, and cleanup.
- At least one elastic scale-out and scale-in event is measured.
- The README contains reproducible commands.
- The final report explains design decisions, results, failures, costs, and limitations.

Merely submitting agent definitions, prompts, diagrams, or generated stubs is not a baseline implementation.

## Minimum acceptance criteria

The core grade is zero when the central application is absent or nonfunctional. The following are central:

1. Real DBLP records are processed.
2. At least three additional real datasets are linked.
3. Hadoop MapReduce performs the initial distributed processing.
4. Spark consumes Hadoop outputs and performs graph analytics.
5. The graph is loaded into Neptune.
6. Operational state is stored in DynamoDB.
7. Embeddings are stored and queried in S3 Vectors.
8. Runtime services execute a graph plus vector RAG workflow.
9. The LLM returns evidence-backed claims.
10. Terraform defines the deployed environment.
11. Source-controlled automation reproduces validation, planning, deployment, bounded pipeline execution, smoke testing, experiment execution, evidence archiving, and cleanup.
12. Elastic behavior is instrumented and demonstrated.
13. The controlled reference-style agentic workflow generates and validates the deliverables.
14. The project can be built and explained by the submitting student or team.

## Final report structure

The final report should use coherent paragraphs and include at least these sections:

1. Problem and motivation.
2. The three collaboration research questions and required metrics.
3. Dataset selection and licenses.
4. Agentic software factory architecture.
5. Authority and ownership design.
6. Human gates and repair loops.
7. Hadoop pipeline.
8. Entity-resolution method and evaluation.
9. Spark coauthorship graph, collaboration metrics, paths, communities, bridge analysis, and temporal analytics.
10. Storage architecture.
11. S3 Vectors and optional OpenSearch design.
12. Runtime collaboration-analysis agents.
13. Microservice architecture and API.
14. Terraform architecture.
15. Build, deployment, experiment, and reproduction automation.
16. Security and threat model.
17. Elasticity experiments.
18. Retrieval and answer evaluation.
19. Agentic factory evaluation.
20. Cost analysis.
21. Failures and incident analysis.
22. Threats to validity.
23. Limitations.
24. Lessons learned.
25. Reproduction and cleanup instructions.

The report must explain why each major technology is used. A catalog of AWS product descriptions is not an architecture argument.

## Demonstration requirements

The final demonstration must show the following without relying only on prerecorded screenshots:

1. Private repository structure.
2. Agent ownership map.
3. At least one agent role file.
4. A dangerous-command hook safely blocking a probe.
5. A test-stop hook or equivalent deterministic gate.
6. A phase report and repair record.
7. A clean `sbt check` result.
8. A dataset manifest and actual source samples.
9. Hadoop job execution evidence and counters.
10. Spark job execution evidence and graph outputs.
11. Neptune graph query.
12. DynamoDB run or query record.
13. S3 Vectors query returning source pointers.
14. A complete user query through the API.
15. Evidence and explain endpoints for the answer.
16. Claim verification behavior, including one unsupported claim test.
17. Reproduction scripts, agent replay instructions, and a clean-checkout bounded run.
18. Terraform plan or deployed-resource evidence.
19. CloudWatch elasticity dashboard.
20. Scale-out and scale-in evidence.
21. One failure and recovery example.
22. Cleanup or resource inventory evidence.

Students must be able to explain any agent-generated file selected by the instructor or TA.

## Collaboration

Course discussion is encouraged. Students may discuss:

- AWS and local setup problems.
- Library and service documentation.
- General Hadoop and Spark debugging techniques.
- General Claude Code configuration and hook behavior.
- Generic Terraform and deployment-automation issues.
- Public dataset availability and license information.
- General methods for measuring retrieval and elasticity.

Students must not share:

- Their private repository.
- Complete agent role files tailored to this assignment.
- Complete prompts that encode their architecture.
- Source code.
- Terraform implementation.
- Dataset match policy and thresholds.
- Evaluation labels.
- Final reports or videos.
- Credentials, account IDs, or secret configuration.

When asking for help, reduce the problem to a small reproducible example that does not reveal the complete solution.

## Individual or team authorship

The instructor will announce whether the project is individual or team-based. When teams are permitted, the README must list every member's exact university-registered name and university email address. The final report must include a contribution table covering architecture, prompting, ratification, implementation review, datasets, experiments, documentation, and demonstration.

Using agents does not erase authorship. The submitting students are responsible for every committed artifact.

## Git logistics

The repository must be private until the instructor authorizes publication.

Required Git practices:

- Grant the instructor and assigned TA the requested access before the deadline.
- Commit early. A repository whose first meaningful commit appears after the deadline may receive no credit.
- Use one phase per commit unless a repair requires a clearly labeled follow-up commit.
- Tag the final submitted commit.
- Do not rewrite public or submitted history.
- Do not force push after the submission deadline.
- Do not commit secrets, `.env` files, Terraform state containing sensitive values, downloaded full datasets, build outputs, or large raw metrics unsuitable for Git.
- Store large artifacts in approved S3 locations and commit manifests plus checksums.
- Include a complete `.gitignore`.
- Use commit messages that identify the phase and owning agent.

Recommended commit form:

```text
phase-06 spark-engineer: add graph construction and analytics
```

Agent final reports do not replace commit messages or release notes.

## README requirements

The root `README.md` must include:

- Project title.
- Student or team identities.
- One-paragraph problem statement.
- Architecture summary.
- Agentic workflow summary.
- Required local software.
- AWS prerequisites.
- Environment variable names without secret values.
- Exact commands for formatting, compiling, testing, and packaging.
- Exact command for the bounded local or cloud sample.
- Exact Terraform format, validate, and plan commands.
- Exact source-controlled automation commands and required environment-variable names.
- Deployment and smoke-test commands.
- API query examples.
- Experiment reproduction commands.
- Final report and video links.
- Cleanup commands.
- Known limitations.
- Deliverable index.

The commands must work from the repository root unless the README explicitly changes directory.

## Submission logistics

Submission deadline: Wednesday, November 25, 2026 at 11PM CST.

The submission should include:

- URL of the private repository.
- Final tag and commit SHA created before the deadline.
- Every agent definition used by the project under `.claude/agents/`.
- `CLAUDE.md`, `docs/agents.md`, `.claude/settings.json`, all hooks, all project commands, and `.mcp.json` with no secret values.
- Detailed `Reproducing the agentic workflow` instructions in the README, including how to start Claude Code, validate the agent system, invoke each required agent through the orchestrator, replay at least one bounded phase, run test and review gates, and compare reproduced evidence with the archived run.
- Phase prompts, agent reports, test reports, review reports, human gates, repair records, and accepted commit hashes under `docs/agent-runs/`.
- Link to the demonstration video.
- Link to the deployed application when the deployment is still available.
- Link to the final report.
- Link to archived experiment results.
- Resource inventory and planned cleanup date.
- Any instructor-approved deviations.

Only the latest commit or submitted tag created before Wednesday, November 25, 2026 at 11PM CST will be graded unless the instructor states otherwise. A late commit does not become timely because an agent started generating it earlier.

## Evaluation rubric

The project is evaluated on 20 points.

| Category | Points | Full-credit evidence |
|---|---:|---|
| Agentic factory and agent reproducibility | 3.0 | Correct orchestrator and subagent model, one-writer ownership, hooks, permissions, reports, repair loops, human gates, submission of every agent, and exact replay instructions |
| Dataset engineering | 1.0 | DBLP plus at least three real linked datasets, manifest, licenses, checksums, schemas, and bounded scripts |
| Hadoop MapReduce | 2.0 | Correct distributed parsing, normalization, researcher/work blocking, author-team extraction, coauthor-pair preparation, counters, rejects, tests, and EMR run |
| Entity resolution | 1.5 | Evaluated researcher and work identity resolution, uncertainty, versioned policy, LLM abstention, gold set, metrics, and error analysis |
| Spark coauthorship analytics | 3.0 | Correct temporal weighted graph, distinct and weighted degree, team-size metrics, components, paths, communities, bridge measure, k-core or equivalent, temporal analysis, tests, and distributed execution |
| Storage architecture | 1.5 | Correct S3, Neptune, DynamoDB, S3 Vectors, provenance, idempotency, and optional OpenSearch discipline |
| Runtime agentic collaboration analysis | 2.0 | Typed planning, researcher resolution, graph metrics, path retrieval, community analysis, semantic context, evidence bundle, synthesis, verification, and abstention |
| Microservices and APIs | 1.0 | Versioned APIs, typed errors, idempotency, health, async jobs, security, and tests |
| Terraform and cloud security | 1.5 | Reproducible infrastructure, least privilege, encryption, bounded capacity, validated plan, and safe stateful resources |
| Reproducible build and deployment automation | 0.5 | Source-controlled validation, plan, deployment, smoke, bounded-pipeline, experiment, archive, and cleanup commands |
| Elasticity, observability, and resilience | 1.0 | Measured scale-out and scale-in, dashboards, failure recovery, synchronized metrics, and cost evidence |
| Evaluation quality | 1.0 | Separate identity, graph, retrieval, answer, performance, and factory evaluation with raw evidence |
| Documentation and demonstration | 1.0 | Reproducible README, agent replay instructions, report, runbook, diagrams, video, and oral command of the system |
| Total | 20.0 | |

## Evaluation deductions and failure conditions

The following deductions apply unless the instructor publishes a replacement rubric. Deductions are expressed against the 20-point project grade.

- Core functionality absent or unable to complete an evidence-backed collaboration query: project grade may be zero.
- Only a generic agent tutorial fork with TaskForge renamed and no ScholarChain collaboration pipeline: zero.
- Only diagrams, prompts, generated stubs, or service examples with no integrated system: zero.
- DBLP not actually processed: up to 5 points lost and core functionality may be considered absent.
- Fewer than three actual enrichment datasets: up to 2 points lost.
- Hadoop requirement replaced by a local loop, Spark operation, or managed import: up to 3 points lost.
- Coauthor-pair preparation is missing or incorrect for large author teams: up to 2 points lost.
- Spark coauthorship analytics absent or performed by collecting the graph to one process: up to 3 points lost.
- Distinct coauthor count, team-size statistics, connected components, communities, bridge analysis, or k-core or justified equivalent missing: up to 2 points lost depending on scope.
- Neptune absent without an instructor-approved substitute: up to 2 points lost.
- S3 Vectors absent without an instructor-approved substitute: up to 2 points lost.
- No evaluated researcher-identity resolution process: up to 2 points lost.
- LLM produces numerical, path, or identity claims without evidence IDs: up to 3 points lost.
- Claim verifier absent or ceremonial: up to 1.5 points lost.
- Terraform missing or incomplete: up to 2.5 points lost.
- Required source-controlled reproduction or deployment scripts missing or README commands fail: up to 2 points lost.
- No measured elasticity: up to 1.5 points lost.
- No independent reviewer or test-agent separation: up to 1.5 points lost.
- Not all agents used by the project are submitted: up to 2 points lost.
- Agent invocation and replay instructions are missing or insufficient for a grader to reproduce a bounded phase: up to 2 points lost.
- Agents share overlapping write ownership without documented control: up to 1 point lost.
- Constitutional files changed without recorded human ratification: up to 1 point lost per material event.
- Reviewer modifies production code: up to 1 point lost per event.
- Agent reports claim commands or tests that were not actually run: up to 2 points lost and possible academic-integrity review.
- Secrets committed or displayed: up to 4 points lost and immediate incident remediation required.
- Destructive or high-cost operation performed without approval: up to 4 points lost.
- Fewer than 25 meaningful unit, contract, integration, and adversarial tests across the repository: up to 2 points lost.
- Program does not build with documented commands: up to 4 points lost.
- Missing logging and trace IDs: up to 1 point lost.
- Hardcoded buckets, endpoints, account IDs, thresholds, or model IDs without configuration rationale: up to 1 point lost.
- Unjustified mutable shared state in distributed or concurrent code: up to 1 point lost.
- Documentation cannot explain partitioning, schemas, inputs, outputs, graph metrics, or provenance: up to 3 points lost.
- Results are reported without raw evidence or reproducible scripts: up to 2 points lost.
- Cloud resources are left running beyond the approved period without explanation: up to 2 points lost and account restrictions may follow.
- Student cannot explain selected agent-generated code, graph metrics, or architecture during the demonstration: up to 4 points lost.

The minimum project grade is zero.

## Required test inventory

The repository must contain at least 25 meaningful automated tests, but strong submissions will contain substantially more. The test inventory must include:

- Parser tests.
- Stable ID tests.
- Serialization tests.
- Hadoop mapper and reducer tests.
- Entity feature and threshold tests.
- Small known-graph Spark tests.
- Storage contract tests.
- Vector metadata tests.
- RAG structured-output tests.
- Prompt-injection tests.
- Claim-verification tests.
- API tests.
- Idempotency tests.
- Failure and retry tests.
- Configuration tests.
- At least one end-to-end bounded fixture.

A test that asserts only that a method returns a non-null value is not meaningful coverage.

## Incident and rollback requirements

At least one safe incident exercise is required. Examples include:

- An embedding worker receives malformed content and sends it to a dead-letter queue.
- A runtime service task is terminated and ECS replaces it.
- A downstream Neptune request times out and the query workflow returns a retryable result.
- A deployment smoke test fails and the service rolls back to the prior image revision.

The incident report must contain:

- Incident ID.
- Start and end time.
- Detection source.
- User-visible impact.
- Relevant trace and run IDs.
- Timeline.
- Root cause.
- Recovery action.
- Data-integrity assessment.
- Follow-up owner.
- Preventive test or control.

Destructive incidents must not be manufactured in a live shared course account.

## Cleanup requirements

The project must provide a documented and tested cleanup path. Cleanup must distinguish:

- Ephemeral EMR resources.
- ECS services and tasks.
- Load balancers and networking components.
- Neptune resources.
- DynamoDB tables.
- S3 Vectors indexes and vector buckets.
- Optional OpenSearch resources.
- ECR images.
- S3 buckets and retained evidence.
- Terraform state.
- KMS and Secrets Manager retention.

Before cleanup, create a resource inventory. After cleanup, create a second inventory and explain every retained resource. The cleanup agent or script must not delete evidence required for grading before the instructor approves its archival location.

## Optional extensions

Optional work receives credit only after the baseline is complete and measured.

Possible extensions include:

- OpenSearch hybrid hot tier with measured routing policy.
- Incremental dataset updates and graph delta loading.
- Temporal graph queries.
- Citation-context extraction from full text.
- Learned entity-resolution model compared against rules.
- Cross-encoder reranking.
- Multi-Region disaster-recovery design.
- EKS-based self-hosted embedding or LLM service.
- Ray-based distributed embedding generation.
- User feedback loop for relevance labels.
- Graph-based recommendation of underexplored research connections.
- FinOps controller that selects retrieval and model paths under a per-query budget.
- Formal policy checker for agent ownership and authority matrices.

An extension must include motivation, implementation, test, experiment, and cost impact.

## Academic integrity and permitted AI use

This assignment requires AI agents, so using an LLM is not merely permitted; it is part of the specification. That does not permit submitting another student's repository, prompts, labels, results, or report.

Students must not:

- Copy another team's source or agent constitution.
- Share a private solution repository.
- Reuse another team's evaluation gold set.
- Fabricate agent reports, command output, metrics, or cloud screenshots.
- Remove failed runs to make evaluation look cleaner.
- Claim a generated artifact passed tests when no test was run.
- Present placeholder or synthetic papers as real results.

Third-party open-source code must be attributed and its license must permit the intended use. Agent-generated code that substantially reproduces a known source does not erase attribution obligations.

## Practical advice

Start with a tiny corpus and a strict contract. Make every stage observable before increasing scale. A pipeline that cannot explain 1,000 records will not become wiser at 10 million records; it will merely become expensive and mysterious.

Keep deterministic work out of the LLM. DOI normalization, JSON validation, graph traversal templates, score computation, and access control belong in code. Use the LLM where language understanding and synthesis create value, and then verify its output.

Treat agent role files as executable organization design. A vague role description is a vague employee who works at machine speed. Narrow ownership and strong gates are cheaper than heroic debugging.

Commit often, keep prompts and reports, and make failures visible. The point of an agentic workflow is not to pretend agents never fail. The point is to make their failures routable, testable, and repairable.

## Reference links

Agentic workflow references:

- [AgenticScalaAppTutorial repository](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial)
- [AgenticScalaAppTutorial main tutorial](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/AgenticScalaAppTutorial.md)
- [Reference genesis prompts](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/docs/genesis-prompts.md)
- [Reference CLAUDE.md](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/CLAUDE.md)
- [Reference ownership map](https://github.com/0x1DOCD00D/AgenticScalaAppTutorial/blob/master/docs/agents.md)
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code MCP](https://code.claude.com/docs/en/mcp)

Course-format reference:

- [CS441 Fall 2025 Homework 3](https://github.com/0x1DOCD00D/CS441_Fall2025/blob/main/Homeworks/Homework3.md)

Dataset references:

- [DBLP XML](https://dblp.org/xml/)
- [OpenAlex snapshot](https://help.openalex.org/tutorials/download-the-snapshot/)
- [OpenCitations downloads](https://download.opencitations.net/)
- [Crossref public data file](https://www.crossref.org/services/metadata-retrieval/public-data-file/)
- [arXiv bulk data access](https://info.arxiv.org/help/bulk_data.html)
- [ORCID public data file](https://info.orcid.org/documentation/integration-guide/working-with-bulk-data/)
- [Semantic Scholar datasets API](https://api.semanticscholar.org/api-docs/datasets)
- [S2ORC](https://github.com/allenai/s2orc)
- [Papers with Code data](https://github.com/paperswithcode/paperswithcode-data)

AWS and big-data references:

- [Amazon EMR](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)
- [Hadoop MapReduce](https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)
- [Apache Spark](https://spark.apache.org/docs/latest/)
- [Amazon Neptune](https://docs.aws.amazon.com/neptune/latest/userguide/intro.html)
- [Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)
- [Amazon S3 Vectors](https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors.html)
- [S3 Vectors metadata filtering](https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-metadata-filtering.html)
- [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)
- [AWS Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)
- [Amazon ECS Service Auto Scaling](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html)
- [Amazon EMR managed scaling](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-scaling.html)
- [Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)

Delivery references:

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform S3 Vectors vector bucket resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3vectors_vector_bucket)
- [Terraform S3 Vectors index resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3vectors_index)
- [sbt](https://www.scala-sbt.org/)
- [Scala 3](https://docs.scala-lang.org/scala3/)

## Closing requirement

The completed project must demonstrate a full chain of accountable computation:

```text
source dataset
  -> versioned manifest
  -> Hadoop transformation
  -> entity decision
  -> Spark graph and score
  -> durable graph and vector storage
  -> runtime retrieval plan
  -> evidence bundle
  -> LLM claim
  -> independent claim verification
  -> API response
  -> audit record
```

It must also demonstrate a full chain of accountable software production:

```text
human intent
  -> orchestrator work order
  -> owning subagent
  -> generated artifact
  -> deterministic tests
  -> independent review
  -> owner repair
  -> human gate
  -> commit
  -> reproducible source-controlled deployment procedure
  -> measured deployment
```

If either chain is missing, ScholarChain is incomplete. The first chain makes the answer trustworthy. The second chain makes the system that produced the answer trustworthy.
