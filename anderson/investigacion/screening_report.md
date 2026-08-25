# Screening Report — Title/Abstract Pass (Stage 1, Phase 2)

**Scope reference:** `scope.txt` §4 (outcomes), §8 (comparison), §9 (inclusion levers)
**Session date:** 2026-08-25
**Dual screening status:** AI-assisted auto-screen complete; **co-reviewer human pass pending** (per scope.txt §5)

---

## 1. PRISMA Flow (Scopus only — first core database executed)

```
Records identified (total):             903   = 369 + 446 + 88
├── MAIN (codegen × benchmarks)        369
├── SUPP-1 (local/on-device coding)    446
└── SUPP-2 (model-family × benchmarks)  88

Duplicates removed (DOI/title):          94   → 809 unique
Records screened (title/abstract):      809
├── Excluded (no benchmark outcome):    427
├── Excluded (benchmark but no local-model signal):  244
└── Auto-included (benchmark + local family/feasibility):  138 → 116 after tighter local-family check

Full-text assessed (pending):          116  (co-reviewer pass + RoB)
```

**Note:** These are **Scopus-only** counts. The PRISMA flow must be re-run after WoS/IEEE/ACM/arXiv/ACL are added (arXiv API already returned 897 hits in the earlier pass — to be merged). Full flow diagram to be finalized once all databases are executed.

---

## 2. Screening Criteria Applied (per scope.txt §9)

**Include** (all must hold):
1. **Lever 3 (outcome):** reports ≥1 of the pre-specified benchmarks — HumanEval(+), MBPP(+), LiveCodeBench, BigCodeBench, SWE-bench (Verified/Pro)
2. **Lever 2 (population):** evaluates ≥1 feasible-local model family **OR** uses explicit local-deployment/on-device language
3. **Lever 1 (time):** 2023–2026 (codegen) / 2024–2026 (SWE)

**Exclude:** benchmark-only but no local model; local-model only but no pre-specified benchmark; no benchmark outcome at all; conference proceedings/editorials (blank-author rows); data-only tool/leaderboard papers (routed to data-source appendix).

---

## 3. Auto-Included Candidate Set (N = 116)

The tight screen required a **named feasible-local model family** (Qwen2.5-Coder, Qwen3-Coder, CodeLlama, CodeGemma, Gemma, StarCoder, DeepSeek-Coder/R1-Distill, Llama, Mistral, Phi-4, Yi-Coder, etc.) OR explicit local-deployment/on-device/quantization language, **plus** a pre-specified benchmark.

**Highest-priority subset — directly evaluate a feasible-local model on a pre-specified benchmark (core evidence for the RQ):**

| Year | Title (abbrev.) | Model(s) | Benchmarks |
|------|------------------|----------|-----------|
| 2025 | Locally-deployed Open-source LLMs for Code Generation: Promises and Challenges | (local deploy) | HumanEval |
| 2026 | Not All Local LLMs Are Equal: A Benchmark of Energy and Performance | (on-device) | HumanEval, MBPP, MBPP+ |
| 2025 | Closing the Loop: Code Generation and Intelligent Debugging | Llama | HumanEval, LiveCodeBench (16GB/quantiz) |
| 2025 | Automated Program Repair using Quantized Language Models and PEFT | CodeLlama, StarCoder, Llama, Qwen2.5 | HumanEval |
| 2025 | Implementation of System Code Generation ... QLoRA | Qwen2.5-Coder | HumanEval, HumanEval+ |
| 2025 | Efficient Beam Search for LLMs Using Trie-Based Decoding | Llama, Mistral, Mistral-Small, Phi-3 | HumanEval |
| 2024 | Generating Software Tests ... Fine-Tuned LLMs | Llama, Mistral (consumer hardware/quantiz) | HumanEval, MBPP |
| 2025 | Bridging the Language Gap ... Cross-Lingual | CodeLlama, CodeGemma, Gemma, Llama | MBPP |
| 2025 | A Taxonomy of Inefficiencies in LLM-Generated Python Code | CodeLlama, CodeGemma, Gemma, DeepSeek-Coder, Llama | HumanEval, HumanEval+ |
| 2025 | MACE: Modular Adaptive Code Engine | Qwen2.5-Coder-7B | HumanEval |

**Plus ~106 more** covering fine-tuning/alignment/repair/agents across feasible-local families and the pre-specified benchmark list (full list with DOIs available on request / in the extraction sheet).

---

## 4. Interpretation & Caveats (transparency)

- **Auto-screen over-includes.** Keyword hits for generic families (e.g., "Llama" appearing in a discussion of a closed model, or "local" meaning "local variable") inflate the set. The **human co-reviewer pass** is mandatory to confirm each of the 116 actually (a) evaluates a *feasible* local model (≤24 GB / ≤48 GB unified, per scope.txt §2) and (b) reports a usable score on a pre-specified benchmark. Expect a substantial reduction after that pass.
- **Missing DOIs (57+54+12).** ~123 records lack DOI (preprints/proceedings without DOI, or arXiv-only). These still have Title + Link for resolution; a few are conference-proceedings container records (blank-author) that are already noise — will be dropped.
- **SWE-bench results** are concentrated in agent/scaffold papers (SWE-Gym, MAGIS, AutoCodeRover, etc.) — many evaluate closed or large models, not feasible-local ones. The local-SWE evidence base is thin; this is itself a finding (SWE capability of local models is under-measured), which the meta-regression and gap analysis will report.
- **arXiv 897 hits** from the earlier pass are **not yet merged** here; they will add the preprint-heavy evaluation literature (e.g., Qwen2.5-Coder tech report) that Scopus indexing may lag on.

---

## 5. Next Steps

1. **Co-reviewer human pass** on the 116 (confirm feasibility + extractable score) → final included set + RoB table.
2. Merge arXiv + WoS/IEEE/ACM/ACL → re-run dedup + screening → complete PRISMA flow.
3. Extract model × benchmark × score rows with provenance tags (scope.txt §7) → merged dataset for meta-regression.
