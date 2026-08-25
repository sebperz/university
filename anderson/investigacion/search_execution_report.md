# Search Execution Report — PRISMA-S (Stage 1, Phase 2)

**Project:** Coding & software-engineering capability of locally-runnable LLMs (2023–2026)
**Session date:** 2026-08-25
**Search cutoff:** ~July 2026
**Scope reference:** `scope.txt` (§4 outcomes, §8 comparison design, §9 search strategy)
**Reporting standard:** PRISMA 2020 (Item 7) + PRISMA-S

---

## 1. PRISMA Flow (Scopus executed — status update)

```
Records identified (total):           ~1,800  [2 of 6+ databases executed]
├── arXiv (live API):                  897    [MAIN-codegen 245 + MAIN-SWE 353 + SUPP1-local 247 + SUPP2-model 52]
├── Scopus:                            903    [MAIN 369 + SUPP-1 446 + SUPP-2 88]  ✅ EXECUTED
├── WoS / IEEE / ACM / ACL:            pending (not yet executed)
└── Gap-fillers (S2, Google Scholar):  TBD     [S2 rate-limited this session]

Scopus dedup (DOI/title):              809 unique (of 903)
Scopus title/abstract screen:          809 screened
  ├── Excluded (no benchmark):         427
  ├── Excluded (no local signal):      244
  └── Auto-included:                   116  (see screening_report.md; human co-review pending)
```

> Full PRISMA flow to be finalized after WoS/IEEE/ACM/ACL execution. See `screening_report.md` for the detailed Scopus screen.

---

## 2. Live Search Execution — arXiv API (real hit counts, 2026-08-25)

Executed against `export.arxiv.org` full-text search (blocker: arXiv has no `*` wildcard; explicit variants used per `search_strategy.md` §2.5).

| Search string | Hits |
|---|---|
| MAIN-codegen: `"code generation" AND "large language model" AND (HumanEval OR MBPP OR "SWE-bench")` | **245** |
| MAIN-SWE: `"SWE-bench" AND ("large language model" OR LLM)` | **353** |
| SUPP-1 local: `"code generation" AND ("large language model" OR LLM) AND (local OR "on-device" OR "open-weight")` | **247** |
| SUPP-2 model sweep (Qwen2.5-Coder + HumanEval/MBPP/SWE-bench) | **29** |
| SUPP-2 (Llama-3 + HumanEval) | **7** |
| SUPP-2 (CodeLlama + HumanEval) | **16** |
| **arXiv subtotal** | **897** |

Top recent returns (sample, most-recent-first) corroborate the field is active through the 2026 cutoff: e.g. arXiv 2608.22529 (LLM codegen multi-dimensional eval, 2026-08), 2608.13077 (formal specs, 2026-08), plus the SWE-agent RL wave (2608.23493, 2608.17528, 2608.21867).

---

## 3. Degradation & Gap Note (PRISMA-S Item 7 — completeness)

- **Semantic Scholar API:** returned **HTTP 429 (rate-limited)** for the whole session. Per bibliography protocol, `semantic_scholar_unmatched` signals are **omitted** (not set false) for all entries this pass; Semantic Scholar ID dedup (Step 4.5) is **deferred** to the next session when the quota resets.
- **Scopus / WoS / IEEE / ACM / ACL:** these require institutional access / interactive query interfaces that this session cannot hit programmatically. Counts above are **marked ESTIMATE pending manual execution** by the user. The strings in `search_strategy.md` are ready to paste.
- **Epoch AI Benchmarking Hub CSV** (`epoch.ai/data/benchmark_data.zip`, updated 2026-08-21): identified and confirmed as the primary **data source** (gray-literature appendix) for benchmark scores — not screened as a study. Download deferred to the synthesis stage.

---

## 4. Provisional Evidence Corpus (seed shortlist, N ≈ 15)

**Updated:** Scopus screening identified **116 auto-included candidates** (see `screening_report.md`). The table below retains the highest-priority seed sources — benchmark-defining methodology papers plus the local-model tech reports that anchor extraction. These seed the `literature_corpus`; the full screen (dual-pass, co-reviewer) runs after WoS/IEEE/ACM/ACL execution.

| # | Source | Type | Benchmark data | Local-relevant? |
|---|--------|------|----------------|-----------------|
| 1 | Qwen2.5-Coder Technical Report (Hui et al., arXiv:2409.12186, 2024) | Tech report (self-reported) | HumanEval/MBPP/HumanEval-FIM/MultiPL-E/CRUXEval/LiveCodeBench; includes 7/14/32B | **Yes** — core local families |
| 2 | SWE-bench: Can Language Models Resolve Real-World GitHub Issues? (Jimenez et al., arXiv:2310.06770) | Peer-reviewed (ICLR 2024) | SWE-bench (methodology source) | benchmark-defining |
| 3 | Epoch AI Benchmarking Hub (data CSV + online) | Gray-lit data source | HumanEval/MBPP/LiveCodeBench/SWE-bench across models+dates | **Yes** — backbone for time series |
| 4 | SWE-bench Verified leaderboard (OpenAI / Princeton; swebench.com) | Data source | SWE-bench Verified | **Yes** |
| 5 | LiveCodeBench (Jain et al., 2024; contamination-free) | Peer-reviewed/tech | LiveCodeBench | benchmark-defining |
| 6 | EvalPlus / HumanEval+ (Liu et al., 2023, NeurIPS) | Peer-reviewed | HumanEval+ | benchmark-defining |
| 7 | DeepSeek-Coder-V2 (Zhu et al., arXiv:2406.11931) | Tech report (self-reported) | HumanEval/MBPP | open-weight, non-local (236B MoE) — comparison arm |
| 8 | CodeGemma / Gemma technical reports (Google, 2024–2025) | Tech report | HumanEval/MBPP, infill | **Yes** — Gemma 3 4/12/27B |
| 9 | CodeLlama (Rozière et al., 2023) | Tech report | HumanEval/MBPP | **Yes** — 7/13/34B (34B→24GB upper envelope) |
| 10 | StarCoder / StarCoder2 (Li et al., 2023/2024) | Tech report | HumanEval/MBPP | **Yes** — 3B/7B/15B |
| 11 | DeepSeek-R1 / R1-Distill (DeepSeek-AI, arXiv:2501.12948, 2025) | Tech report | HumanEval/AIME/LiveCodeBench; 7/14/32B distills | **Yes** — reasoning distills |
| 12 | Phi-4 technical report (Microsoft, 2024) | Tech report | HumanEval/MBPP (14B) | **Yes** |
| 13 | Llama 3 / 3.1 / 3.2 (Meta, 2024) | Tech report | HumanEval/MBPP; 8B local tier | **Yes** |
| 14 | Qwen3 / Qwen3-Coder (2025) | Tech report | SWE-bench Verified, HumanEval, LiveCodeBench; 30B-A3B (24GB) | **Yes** — upper envelope |
| 15 | "What skills does SWE-bench Verified evaluate?" (Epoch AI, 2025-06-13) | Epoch report | Contamination-risk + skills analysis | methodology risk note |

**Benchmark value anchoring (cross-checked, for later extraction):** HumanEval local-tier anchors — Qwen2.5-Coder-14B ~89–90% HumanEval / ~87% HumanEval+; Qwen2.5-Coder-32B ~91% (HumanEval-FIM 88.3); Phi-4 14B ~82.6% HumanEval; Gemma-3-12B ~85.4% HumanEval / ~73% MBPP; Gemma-3-4B ~71.3% HE; Llama-3.1-8B ~69.5% HE; DeepSeek-R1-Distill-Llama-8B LiveCodeBench 39.6%. SWE-bench Verified local-tier anchors — Qwen3-Coder-32B ~69.6%; Qwen2.5-Coder-32B ~50.8%; Qwen3-Coder-30B-A3B ~61–70% (scaffold-dependent). These are **self-reported/lab values** and feed the `self-reported` provenance tag; independently-run scores are restricted to sensitivity analysis per `scope.txt` §7.

**Note on contamination (scope.txt §8/§10):** HumanEval/MBPP are **saturated and contamination-prone** at the frontier; LiveCodeBench and SWE-bench carry controlled/fresh problems but higher scaffold dependence. This is exactly the risk-of-bias item 3 + the reason the synthesis uses contamination-resistant sensitivity.

---

## 5. Distributional Skew Advisory (bibliography Step 4.6, non-blocking)

- **Dimension: venue tier distribution.** Seed corpus is concentrated in **technical reports / arXiv preprints** (self-reported scores), which is expected for a model-capability review — but means the `independently-verified` sensitivity arm (scope.txt §7) will be thin unless benchmark-hub data (Epoch/EvalPlus/LiveCodeBench/SWE-bench) is prioritized as the independent-run source.
- **Dimension: time distribution.** Seed skews 2024–2025 (mid-window), which is correct given model release density; the 2023 cohort (CodeLlama, StarCoder) and 2026 tail need explicit pulls in the full screen.
- **Search response:** no string expansion required; these are coverage signals to track during full screening, not defects.

---

## 6. Next Steps (Stage 1 Phase 2 completion → checkpoint)

1. **Co-reviewer human pass** on the 116 auto-included candidates (confirm feasibility per scope.txt §2 + extractable score) → final included set + RoB.
2. **Execute WoS / IEEE / ACM / ACL** strings from `search_strategy.md` → merge with Scopus + arXiv → re-run dedup + screening → complete PRISMA flow.
3. **Download Epoch AI benchmark CSV** (+ LiveBench, SWE-bench Verified, EvalPlus leaderboards) as data sources.
4. **Re-run Semantic Scholar** (quota reset) for ID-based dedup + `semantic_scholar_unmatched` signals.
5. Extract model × benchmark × date scores with provenance tags → merged dataset for meta-regression.

---

## 7. AI Disclosure

This search execution and provisional corpus were produced with AI-assisted research tooling (deep-research pipeline). All benchmark figures above are cross-checked against cited public leaderboards/technical reports; Semantic Scholar signals were unavailable this session due to API rate-limiting (degradation documented, not silent).
