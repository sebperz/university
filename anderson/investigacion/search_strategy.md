# Search Strategy — PRISMA-S

**Project:** Coding & software-engineering capability of locally-runnable LLMs (2023–2026), evolution vs. closed frontier.
**Session date:** 2026-08-25
**Scope reference:** `scope.txt` (Sections 4, 8, 9)
**Reporting standard:** PRISMA 2020 (Item 7) + PRISMA-S (Items 4–8)
**Search cutoff:** ~July 2026

---

## 1. Search Blocks (PICO mapping)

| Block | Concept | Terms |
|-------|---------|-------|
| **A** | LLM / code model (P+I) | `"large language model*"`, `"language model*"`, `"code language model*"`, `"coding model*"`, `"foundation model*"`, `LLM`, `LLMs` |
| **B** | Coding / software engineering domain (I) | `"code generation"`, `"code completion"`, `"code synthesis"`, `"program synthesis"`, `"software engineering"`, `"software development"`, `"automated program repair"`, `"code repair"`, `"bug fix*"`, `"code intelligence"` |
| **C** | Local / on-device / self-hosted feasibility (P) | `local`, `"on-device"`, `"self-hosted"`, `"open-weight*"`, `quantiz*`, `"consumer hardware"`, `"consumer GPU"`, `"edge device*"`, `"personal computer*"`, `"commodity hardware"` |
| **D** | Pre-specified outcome benchmarks (O) | `HumanEval`, `MBPP`, `LiveCodeBench`, `BigCodeBench`, `"SWE-bench"` |

**Inclusion lever alignment (scope.txt §9):** the benchmark block (D) is the strongest pre-specified lever — benchmark names are rare, specific tokens, giving high precision with high recall. Block C (local/feasibility) is intentionally NOT AND-ed into the main string: feasibility is defined by model family + VRAM budget, not by paper terminology, so a hard C-AND would lose the majority of qualifying studies.

---

## 2. Main Search String (per database)

Three strings per database:
1. **MAIN** — benchmark-anchored (Block A AND B AND D): the core corpus.
2. **SUPP-1** — local/on-device coding (Block A AND B AND C): catches coding-capability papers that do not name a standard benchmark in title/abstract.
3. **SUPP-2** — model-designation sweep: catches evaluations reported under a model family name without an abstract-level benchmark mention.

Merged + deduplicated (title-based + Semantic Scholar ID, see bibliography protocol Step 4.5).

---

### 2.1 Scopus

**MAIN:**
```
TITLE-ABS-KEY (
  ( "large language model*" OR "language model*" OR "code language model*" OR "coding model*" OR "foundation model*" OR LLM OR LLMs )
  AND
  ( "code generation" OR "code completion" OR "code synthesis" OR "program synthesis" OR "software engineering" OR "software development" OR "automated program repair" OR "code repair" OR "bug fix*" OR "code intelligence" )
  AND
  ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" )
)
```

**SUPP-1:**
```
TITLE-ABS-KEY (
  ( "large language model*" OR "language model*" OR "code language model*" OR LLM OR LLMs )
  AND
  ( "code generation" OR "code completion" OR "software engineering" OR "program synthesis" OR coding )
  AND
  ( local OR "on-device" OR "self-hosted" OR "open-weight*" OR quantiz* OR "consumer hardware" OR "edge device*" OR "personal computer*" )
)
```

**SUPP-2:**
```
TITLE-ABS-KEY (
  ( "Qwen2.5-Coder" OR "Qwen3-Coder" OR CodeLlama OR CodeGemma OR StarCoder OR "DeepSeek-Coder" OR "Llama-3" OR "Gemma-3" OR Mistral OR "Phi-4" )
  AND
  ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" )
)
```

**Filters (Scopus):** `PUBYEAR > 2022 AND PUBYEAR < 2027`; Language: English; Document types: Article, Conference Paper, Review, Preprint (where available).

---

### 2.2 Web of Science

**MAIN:**
```
TS=(
  ( "large language model*" OR "language model*" OR "code language model*" OR "coding model*" OR "foundation model*" OR LLM OR LLMs )
  AND
  ( "code generation" OR "code completion" OR "program synthesis" OR "software engineering" OR "software development" OR "bug fix*" OR "automated program repair" )
  AND
  ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" )
)
```

**SUPP-1:**
```
TS=(
  ( "large language model*" OR "language model*" OR LLM OR LLMs )
  AND
  ( "code generation" OR "code completion" OR "software engineering" OR "program synthesis" OR coding )
  AND
  ( local OR "on-device" OR "self-hosted" OR "open-weight*" OR quantiz* OR "consumer hardware" OR "edge device*" )
)
```

**SUPP-2:**
```
TS=( ( "Qwen2.5-Coder" OR "Qwen3-Coder" OR CodeLlama OR CodeGemma OR StarCoder OR "DeepSeek-Coder" OR "Llama-3" OR "Gemma-3" OR Mistral OR "Phi-4" ) AND ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" ) )
```

**Filters (WoS):** `PY=(2023-2026)` (SWE block restricted to 2024-2026 at screening); Language: English; Document types: Article, Proceedings Paper, Early Access, Preprint (where indexed).

---

### 2.3 IEEE Xplore

**MAIN:**
```
( ("All Metadata":"large language model") OR ("All Metadata":"language model") OR ("All Metadata":"code language model") OR ("All Metadata":"coding model") OR ("All Metadata":"foundation model") OR ("All Metadata":LLM) )
AND
( ("All Metadata":"code generation") OR ("All Metadata":"code completion") OR ("All Metadata":"program synthesis") OR ("All Metadata":"software engineering") OR ("All Metadata":"software development") )
AND
( ("All Metadata":HumanEval) OR ("All Metadata":MBPP) OR ("All Metadata":LiveCodeBench) OR ("All Metadata":BigCodeBench) OR ("All Metadata":"SWE-bench") )
```

**SUPP-1:**
```
( ("All Metadata":"large language model") OR ("All Metadata":"language model") OR ("All Metadata":LLM) )
AND
( ("All Metadata":"code generation") OR ("All Metadata":"code completion") OR ("All Metadata":"software engineering") OR ("All Metadata":"program synthesis") )
AND
( ("All Metadata":local) OR ("All Metadata":"on-device") OR ("All Metadata":"self-hosted") OR ("All Metadata":"open-weight") OR ("All Metadata":quantiz*) )
```

**SUPP-2:**
```
( ("All Metadata":"Qwen2.5-Coder") OR ("All Metadata":"Qwen3-Coder") OR ("All Metadata":CodeLlama) OR ("All Metadata":CodeGemma) OR ("All Metadata":StarCoder) OR ("All Metadata":"DeepSeek-Coder") OR ("All Metadata":"Llama-3") OR ("All Metadata":"Gemma-3") OR ("All Metadata":Mistral) OR ("All Metadata":"Phi-4") )
AND
( ("All Metadata":HumanEval) OR ("All Metadata":MBPP) OR ("All Metadata":LiveCodeBench) OR ("All Metadata":BigCodeBench) OR ("All Metadata":"SWE-bench") )
```

**Filters (IEEE):** Year 2023–2026; Content type: Journals, Conferences, Early Access.

---

### 2.4 ACM Digital Library

**MAIN:**
```
[[Abstract: "large language model"] OR [Abstract: "language model"] OR [Abstract: "code language model"] OR [Abstract: "coding model"] OR [Abstract: LLM]]
AND
[[Abstract: "code generation"] OR [Abstract: "code completion"] OR [Abstract: "program synthesis"] OR [Abstract: "software engineering"] OR [Abstract: "software development"]]
AND
[[Abstract: HumanEval] OR [Abstract: MBPP] OR [Abstract: LiveCodeBench] OR [Abstract: BigCodeBench] OR [Abstract: "SWE-bench"]]
```

**SUPP-1:**
```
[[Abstract: "large language model"] OR [Abstract: "language model"] OR [Abstract: LLM]]
AND
[[Abstract: "code generation"] OR [Abstract: "code completion"] OR [Abstract: "software engineering"] OR [Abstract: "program synthesis"]]
AND
[[Abstract: local] OR [Abstract: "on-device"] OR [Abstract: "self-hosted"] OR [Abstract: "open-weight"] OR [Abstract: quantiz*]]
```

**SUPP-2:**
```
[[Abstract: "Qwen2.5-Coder"] OR [Abstract: "Qwen3-Coder"] OR [Abstract: CodeLlama] OR [Abstract: CodeGemma] OR [Abstract: StarCoder] OR [Abstract: "DeepSeek-Coder"] OR [Abstract: "Llama-3"] OR [Abstract: "Gemma-3"] OR [Abstract: Mistral] OR [Abstract: "Phi-4"]]
AND
[[Abstract: HumanEval] OR [Abstract: MBPP] OR [Abstract: LiveCodeBench] OR [Abstract: BigCodeBench] OR [Abstract: "SWE-bench"]]
```

**Note:** verify ACM field codes (`[Abstract: ...]`) against current ACM DL advanced-search help; fall back to `[[All: ...]]` if abstract field is restricted.

**Filters (ACM):** Year 2023–2026; Types: Research Articles, Conference Proceedings.

---

### 2.5 arXiv (full-text)

**MAIN:**
```
all:"large language model" OR all:"code language model" OR all:"foundation model" OR all:LLM
AND
all:"code generation" OR all:"code completion" OR all:"program synthesis" OR all:"software engineering" OR all:"software development"
AND
all:HumanEval OR all:MBPP OR all:LiveCodeBench OR all:BigCodeBench OR all:"SWE-bench"
```

**SUPP-1:**
```
all:"large language model" OR all:LLM
AND
all:"code generation" OR all:"code completion" OR all:"software engineering"
AND
all:local OR all:"on-device" OR all:"self-hosted" OR all:"open-weight" OR all:quantiz*
```

**SUPP-2:**
```
all:"Qwen2.5-Coder" OR all:"Qwen3-Coder" OR all:CodeLlama OR all:CodeGemma OR all:StarCoder OR all:"DeepSeek-Coder" OR all:"Llama-3" OR all:"Gemma-3" OR all:Mistral OR all:"Phi-4"
AND
all:HumanEval OR all:MBPP OR all:LiveCodeBench OR all:BigCodeBench OR all:"SWE-bench"
```

**Note:** arXiv search does not support `*` wildcards; explicit variants used. Category filters (cs.CL, cs.SE, cs.LG, cs.AI) and date range (from 2023-01-01 to 2026-07-31) applied.

---

### 2.6 ACL Anthology

ACL search is Google-style (limited boolean). Use the phrase-form query:

**MAIN:**
```
"large language model" AND ("code generation" OR "software engineering") AND (HumanEval OR MBPP OR "SWE-bench")
```

**SUPP-1:**
```
("large language model" OR LLM) AND ("code generation" OR "code completion") AND (local OR "on-device" OR "self-hosted")
```

**Note:** ACL Anthology covers NLP venues (ACL, EMNLP, NAACL, COLING, LREC) — most relevant for SWE-bench/LiveCodeBench style NLP-adjacent evals; expect fewer hits than Scopus/arXiv.

---

### 2.7 Gap-fillers (cross-check only, not screened)

**Semantic Scholar API query:**
```
("large language model" OR "code language model") AND ("code generation" OR "software engineering") AND (HumanEval OR MBPP OR "SWE-bench")
```

**Google Scholar keyword string:**
```
"large language model" AND ("code generation" OR "software engineering") AND (HumanEval OR MBPP OR "SWE-bench") 2023..2026
```

Used to verify recall of the core databases; results are cross-checked, not screened as primary records.

---

## 3. Filters Summary (all databases)

| Filter | Setting |
|--------|---------|
| Time window | 2023-01-01 → 2026-07-31 (codegen); SWE-bench family restricted to 2024–2026 at screening |
| Language | English (title/abstract screening) |
| Document types | Journal article, conference paper, preprint (arXiv/SSRN-style), repository report (leaderboard data — see gray-lit appendix) |
| Deduplication | Title/DOI exact + Semantic Scholar ID (bibliography agent Step 4.5); keep most-complete record |

---

## 4. PRISMA-S Documentation Notes

- Full strategy reported for Scopus (primary database) per PRISMA-S Item 5; all other databases carry syntax-adapted variants (documented above, Item 6).
- Search dates, per-database hit counts, and per-database result sets to be recorded at execution time (Items 4, 7).
- Restriction to English is documented (Item 8); no other language, publication-type, or source restrictions beyond those above.
- Search strings will be peer-checked against PRESS checklist (PRISMA-P guidance) before execution.
