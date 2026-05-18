Questionnaire answers for submission

1) Trigger choice for onboarding flow

I chose Standing Order because the project uses OpenClaw's built-in scheduling/standing-order mechanism to kickoff conversational flows (the repo contains cron/standing-order style triggers rather than an external webhook listener). Trade-offs: Standing Orders are simple to set up, map naturally to time-based or recurring workflows, and keep orchestration inside OpenClaw; they avoid exposing an HTTP endpoint and needing external delivery guarantees. The downside is reduced flexibility for externally-initiated events (webhooks allow immediate, external triggers and can integrate with other services), and standing orders rely on the gateway's scheduler (which may require careful scaling if many timed jobs are needed).

2) Prompt engineering strategy for `skills/daily-quiz/SKILL.md`

My strategy used explicit, constraint-first prompting to guarantee consistent, high-quality, and correctly formatted output. Concretely:
- Clear goal statement: what the agent must produce (a daily brief for Telegram).
- Hard constraints: exact counts ("exactly 5" interview-style questions; "3–5" tidbits), output format (Telegram Markdown), and language/level rules.
- Tooling invocation: instruct use of `web_search` to ground facts and cite recent sources when needed.
- Examples & templates: include a short exemplar output block showing exact Markdown structure (headings, bullets, code/quote usage) so the model can mirror formatting.
- Safety and diversity: ask for topic variation, shuffling/randomization, and to avoid repetition across days.
- Determinism controls: recommend temperature/seeding (or model param hints) and explicit separators so the gateway can parse output reliably.

These constraints are reflected in the committed `skills/daily-quiz/SKILL.md` (exact counts, Telegram Markdown output, and web_search use).

3) Local model (Ollama) — advantages and disadvantages for this app

Advantages:
- Privacy: user data and prompts never leave the host, improving data control.
- Cost predictability: avoids per-request cloud billing for many small queries.
- Offline/edge capability: can run without internet access after model artifacts are present.

Disadvantages:
- Resource demands: inference requires significant CPU/RAM (or GPU), increasing hosting cost and complexity.
- Operational overhead: model downloads, updates, and local management (e.g., Ollama image blobs) complicate deployment and CI.
- Scalability: a single local model instance limits concurrent throughput compared to autoscaling cloud inference.
- Model freshness: cloud providers can offer newer models and managed safety/monitoring features faster.


4) Main scalability bottleneck and mitigations for hundreds of users

Bottleneck: LLM inference and model-host resources (single Ollama instance + gateway doing synchronous calls). Other constraints include synchronous cron-style bursts (many users receiving jobs at the same time) and memory-store contention.

Mitigations:
- Move inference to a horizontally-scalable pool of model workers (multiple Ollama/serving instances or use managed cloud LLM endpoints) behind a request queue.
- Introduce an async job queue (Redis/RabbitMQ) so user notifications are enqueued and processed at a controlled rate, smoothing bursts.
- Cache generated content for repeated requests and reuse embeddings/semantic caches.
- Partition memory storage by user shard or use a scalable DB (Postgres, DynamoDB) with indexed queries.
- If running locally, use smaller specialized models for majority traffic and escalate only difficult requests to larger models.

5) Adaptive difficulty — schema and skill changes

Memory schema additions (augment `user_profile_{{user.id}}`):
- `performance_history`: list of {question_id, timestamp, difficulty_level, outcome: correct|incorrect, response_time_sec}
- `proficiency_score`: numeric or per-topic map (e.g., {algorithms: 0.7, systems: 0.45})
- `last_reviewed`: timestamp per topic

Skill changes:
- `daily-quiz` reads `performance_history` and `proficiency_score` to select difficulty: use recent accuracy to escalate or de-escalate question difficulty.
- Implement a spaced-repetition weighting (SM-2 or decayed success rate) to prioritize weaker topics and re-ask missed questions later.
- After each quiz interaction, write back the outcome to `performance_history` and update `proficiency_score`.
- Optionally include a short explanation and an easy/hard variant toggle so that the skill can instruct the model to generate scaled prompts.

These changes let the agent personalize question difficulty over time by using stored performance signals to bias generation and selection.

---

Repository note: See the added file [answers.md](answers.md) for these responses.
