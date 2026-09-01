# Paper Plan — PRISMA Meta-Analysis: Locally-Runnable LLMs vs Closed Proprietary Models

**Mode:** academic-paper `plan` (Socratic chapter-by-chapter) · **Status:** IN PROGRESS — session checkpoint
**Saved:** 2026-09-01 · **Resume point:** Methodology chapter, round 2 (three unresolved "forks")

---

## [PLAN MODE CHECKPOINT]

```
Completed chapters:   Introduction (converged), Literature Review (converged)
In-progress chapter:  Methodology (round 1 done; round 2 = three forks, unanswered)
Remaining chapters:   Methodology round 2 → Results → Discussion → Conclusion
                      → Step 2.5 Contribution sharpening → Step 3 Argument stress test
                      → structure_architect outline → final Chapter Plan
Convergence status:
  Introduction:       C1 ✔ (thesis confirmed)  C2 ✔ (competition-first arc)
                      C3 partial (evidence = to-verify)  C4 ✔ (honest "not verified")
  Literature Review:  C1 ✔  C2 ✔ (funnel thread)  C3 ✘ (no sources read yet)
                      C4 ✔ (honest low score)
  Methodology:        C1 ✔  C3 ✔ (protocol decisions mapped)  C4 ✔ (comparability
                      named unprompted)  — round 2 pending
Commitment tracking:  Intro: no prediction · LitReview: "low score, honest" ·
                      Methodology: no prediction → pattern: weakness predictions
                      consistently avoided (raise at stress test)
INSIGHT Collection:   thesis_statement, introduction_summary (below)
```

**How to resume:** start a new session, attach this file, and say: *"Resume plan mode for this paper from the Methodology chapter, round 2 — the three forks."*

---

## 1. Paper Configuration Record (Plan Mode)

| Parameter | Value |
|-----------|-------|
| **Topic** | PRISMA-based meta-analysis of coding/SWE benchmark performance: locally-runnable LLMs vs closed proprietary models, 2023–2026 |
| **Discipline** | CS / ML (evidence profile: `cs_ml` — arXiv preprints admissible) |
| **Research Question** | PICOS-complete (see §2) |
| **Paper Type / Structure** | IMRaD with PRISMA 2020 overlay; Related Work = "Literature Review" chapter |
| **Citation Format** | TBD (likely APA 7 or IEEE — decide at intake of full mode) |
| **Existing Materials** | Idea + PICOS question only. No search, no data, no drafts |
| **Positioning** | Practitioner position, **performance-only scope, declared** |
| **Operational Mode** | plan |

---

## 2. Research Question (PICOS-complete, locked)

> **Among evaluations of LLMs on coding/software-engineering benchmarks (2023–2026), how has the performance of locally-runnable LLMs (≤24 GB VRAM class) evolved across model release dates, and how large is the remaining gap to the best closed proprietary models?**

| PICOS | Definition |
|-------|-----------|
| **P** | Empirical evaluations of LLMs on coding/SWE benchmarks |
| **I** | LLMs **natively designed** for the ≤24 GB VRAM consumer class (quantized frontier giants EXCLUDED — decision recorded 2026-09-01) |
| **C** | Best closed proprietary (API-only) models |
| **O** | Benchmark scores: SWE-bench family, LiveCodeBench, BigCodeBench |
| **S** | Benchmark evaluation studies, incl. arXiv preprints (declared grey-lit policy) |

**Planned analyses:** RQ1 = meta-regression (performance ~ release date). RQ2 = comparative meta-analysis (local vs closed gap).

---

## 3. INSIGHT Collection

```
[INSIGHT: thesis_statement] — CONFIRMED by user
Core thesis: "The performance gap between locally-runnable LLMs (≤24 GB VRAM
class) and the best closed proprietary models remains large through 2026, and
where local models are viable is conditional — on the benchmark family used
to measure them, and on deployment factors (privacy, cost, offline use) that
benchmark evidence cannot itself establish."
Thesis type: comparative + evaluative (temporal meta-regression; between-class
pooled gap; benchmark family + scaffold as pre-declared moderators)
Scope: coding/SWE benchmark studies 2023–2026; viability beyond agentic coding
explicitly flagged as beyond-data implication.

[INSIGHT: introduction_summary]
Conceptual contribution of the Intro: the open-weight ≠ locally-runnable
distinction, stated early, reframes a media debate as a measurable question.
Arc: Competition-first (open-weight frontier rivalry → local deployability
bottleneck → unquantified gap → RQ).
```

---

## 4. Chapter Summaries

### 4.1 Introduction — CONVERGED, user-confirmed

- **Core purpose:** Open-weight models now rival closed frontier models; local deployability is the real bottleneck; no pooled evidence quantifies where locally-runnable models stand.
- **Core argument:** The "local models caught up" question is answerable — nobody has answered it with pooled evidence.
- **Supporting evidence (to-verify via search):** (1) open-weight vs closed frontier competition; (2) hardware inflection / consumer-GPU capability data; (3) absence of existing synthesis (review-check search).
- **Potential risks:** unverified gap claim; size-vs-locality critique (native-only class makes "local" ≈ "small").
- **Scope sentence (goes in final Intro paragraph):** performance evidence for the deployment decision; cost, latency, privacy **declared out of scope**.
- **Expected length:** ~800–1,000 words.

### 4.2 Literature Review / Related Work — CONVERGED

- **Core purpose:** Funnel: local/SLM landscape → how coding performance is measured → what prior syntheses cover → the empty slot.
- **Themes (3):** (1) Local/SLM landscape (Llama, Mistral, Qwen, Gemma, Phi families); (2) Benchmark methodology (design, criticisms, contamination, saturation); (3) Prior syntheses (differentiation targets).
- **Thread (final-paragraph sentence):** Funnel — landscape → measurement → synthesis gap.
- **Critical stance:** **Anti-interchangeability** — benchmarks measure different constructs; must not be pooled as if identical. (This stance motivates the benchmark-family moderator: Related Work and Methods make the same promise.)
- **Supporting evidence:** all to-verify by search phase.
- **Potential risks:** differentiation targets unknown until review-check runs.
- **Expected length:** ~1,200–1,800 words.

### 4.3 Methodology — IN PROGRESS (round 1 done)

**Decisions locked (round 1):**

| Question | Decision |
|----------|----------|
| Why meta-analysis (vs running models ourselves)? | Release-date trend requires formal synthesis across models/time — no single lab paper shows it |
| If only 4–8 eligible studies? | **Proceed, report honestly** — wide CIs, "evidence base is thin" framing (which supports the gap claim). No pre-declared SR fallback |
| Risk of bias | Adapted checklist per study (harness/scaffold disclosed? contamination addressed? independent vs self-report?) + dual independent screening with third-reviewer resolution |
| Biggest limitation (named unprompted) | Cross-study comparability → handled by scaffold moderator + heterogeneity reporting (I², prediction intervals) |

**Methods section inventory (fixed for PRISMA papers):** protocol & registration (OSF pre-registration, PRISMA 2020 checklist) → eligibility criteria → information sources → search strategy → selection process → data collection (extraction items) → risk of bias → synthesis methods. Roughly half is already populated by decisions above.

**ROUND 2 — THREE OPEN FORKS (unanswered; resume here):**

1. **Effect measure.** Raw % pooling is forbidden by their own anti-interchangeability stance. Options discussed: (a) stratified pooling within benchmark family; (b) standardized mean differences (SMD) within benchmark, pooled across; (c) within-study local-vs-closed gaps, pooled.
2. **Dependent observations.** One study → many model×benchmark pairs, not independent. Options: declare now + defer mechanics (multilevel/RVE) to analysis phase; restrict to one effect per study (loses data); learn first.
3. **Time axis.** Release date as x vs evaluation date; benchmark version drift (SWE-bench → Verified, Aug 2024; LiveCodeBench rotating problems). Options: release date + version covariate; freeze version (shrinks K); evaluation date (weaker).

### 4.4 Results, Discussion, Conclusion — NOT STARTED

Standard PRISMA-IMRaD content; to negotiate after Methodology converges:
- Results: PRISMA flow numbers, study characteristics table, pooled estimates, meta-regression, moderator analyses, sensitivity analyses. Golden rule: report, don't interpret.
- Discussion: dialogue with prior syntheses; the conditional-viability interpretation; limitations (comparability, selective reporting, contamination, grey lit); future research.
- Conclusion: answer RQ1 + RQ2 in two sentences; practitioner takeaway scoped to performance.

---

## 5. Decision Log (all locked, chronological)

| # | Decision | Value |
|---|----------|-------|
| 1 | Independent variable | Model class: locally-runnable (NOT deployment site) |
| 2 | Hardware cutoff | ~24 GB VRAM class |
| 3 | Evidence sources | Scopus + WoS + arXiv |
| 4 | Benchmarks | Recent SWE benchmarks (SWE-bench family, LiveCodeBench, BigCodeBench) |
| 5 | Quantized frontier giants | **Excluded** — native ≤24 GB only (consequence: fewer studies; size-vs-locality critique to defend) |
| 6 | Intro arc | Competition-first |
| 7 | Lit themes | SLM landscape + benchmark methodology + prior syntheses (3 themes, funnel thread) |
| 8 | Positioning | Practitioner, performance-only, declared out-of-scope for cost/latency/privacy |
| 9 | Critical stance | Anti-interchangeability of benchmarks |
| 10 | Sufficiency fallback | Proceed regardless, report honestly (no SR fallback declared — revisit if K < 4) |
| 11 | Moderators pre-declared | Scaffold/harness; benchmark family; (quantization N/A now) |

---

## 6. Verification Tasks (feeding the search phase)

1. **Existing-reviews check (before main search):** review-type filtered search in Scopus/WoS (e.g., `(local* OR "on-device" OR "small language model*") AND LLM* AND ("systematic review" OR "meta-analysis" OR survey)`, Doc Type = Review) + arXiv survey keywords + OSF Registries + hand-search ACM Computing Surveys / TMLR / EMNLP resources tracks. Outcomes: (a) nothing → gap verified; (b) exists but no quantification/moderators → differentiate in Intro; (c) near-duplicate → pivot (window/moderators/outcomes).
2. **Protocol registration:** OSF pre-registration before extraction begins.
3. **Citations needed for Intro claims:** open-weight frontier competition; consumer-hardware inflection.
4. **Build search strings per Lit theme** (themes = search-string families).
5. **Extraction spreadsheet columns (draft):** study, venue, date; model; release date; params/arch; benchmark + version; score; scaffold/harness; prompting; hardware; self-report vs independent.

---

## 7. Project Pipeline (order of operations — Intro is written near the END)

```
1. PROTOCOL   define question, criteria, databases          ← plan mode (this doc)
2. SEARCH     systematic search (Scopus/WoS/arXiv)          ← evidence enters here
3. SCREEN     inclusion/exclusion → PRISMA flow diagram
4. EXTRACT    scores + metadata per study
5. ANALYZE    pooling, meta-regression, moderators
6. WRITE      Methods → Results → Discussion → Intro LAST → Abstract LAST
```

**Core distinctions learned (teaching appendix):**
- PRISMA = reporting guideline (what to document); meta-analysis = statistical pooling. A meta-analysis is only possible if primary studies report comparable quantitative outcomes; otherwise it degrades to systematic review.
- Open-weight ≠ locally-runnable (DeepSeek-R1 is open-weight, unrunnable at home). This distinction is the paper's conceptual reframing.
- RQ ≠ thesis: the question asks; the thesis is the claim the data must test.
- Effect sizes from different benchmarks are not naively poolable (anti-interchangeability has statistical teeth).
- In a meta-analysis, the search IS the data collection; Methods is written *about* decisions made during planning.

---

## 8. Next Steps

1. Resume plan mode → answer the three Methodology forks (§4.3).
2. Finish Results / Discussion / Conclusion chapter dialogues.
3. Step 2.5 contribution sharpening; Step 3 argument stress test (expect the delayed weak-point predictions to surface there).
4. structure_architect → full outline; argument_builder → final Chapter Plan with word counts.
5. Then: literature/search phase (tasks §6), then `full` mode for drafting.
