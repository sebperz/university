#!/usr/bin/env python3
"""
WoS Export Screening — PRISMA title/abstract pass for the local-LLM coding review.

Processes the three WoS exports (MAIN / SUPP-1 / SUPP-2) per search_strategy.md
section 2.2, deduplicates intra-WoS and against the Scopus corpus, applies the
same title/abstract levers as the Scopus screen (screening_report.md section 2),
and emits an append-ready candidate file.

Usage:
  python3 wos_screen.py             # dry-run: write log + candidates, print stats
  python3 wos_screen.py --append    # also append candidates to included_candidates_116.csv
"""

import csv
import re
import sys
from collections import Counter

CANDIDATES_FILE = "included_candidates_116.csv"
LOG_FILE = "wos_screening_log.csv"
NEW_CANDIDATES_FILE = "wos_candidates_screen.csv"

WO_SOURCES = [
    ("MAIN", "wos_MAIN.csv"),
    ("SUPP-1", "/tmp/opencode/wos/wos_SUPP1.csv"),
    ("SUPP-2", "/tmp/opencode/wos/wos_SUPP2.csv"),
]
SCOPUS_SOURCES = ["scopus_MAIN.csv", "scopus_SUPP1.csv", "scopus_SUPP2.csv"]

BENCH_PATTERNS = [
    ("HumanEval", re.compile(r"\bhuman\s?eval(?!uat)", re.I)),
    ("MBPP", re.compile(r"\bmbpp\b", re.I)),
    ("LiveCodeBench", re.compile(r"\blivecodebench\b", re.I)),
    ("BigCodeBench", re.compile(r"\bbigcodebench\b", re.I)),
    ("SWE-bench", re.compile(r"\bswe[\s-]?bench\b", re.I)),
]

FAMILY_PATTERNS = [
    r"\bqwen\b",
    r"\bcode\s?llama\b",
    r"\bcode\s?gemma\b",
    r"\bgemma\b",
    r"\bstarcoder\b",
    r"\bdeepseek[\s-]?coder\b",
    r"\bdeepseek[\s-]?r1[\s-]?distill\b",
    r"\bllama\b",
    r"\bmistral\b",
    r"\bphi[\s-]?[34]\b",
    r"\byi[\s-]?coder\b",
    r"\byi[\s-]?\d+b\b",
]

LOCAL_LANG_PATTERNS = [
    r"\bon[\s-]?device\b",
    r"\bself[\s-]?hosted\b",
    r"\bopen[\s-]?weights?\b",
    r"\bquantiz",
    r"\bconsumer\s(?:hardware|gpu|cpus?)\b",
    r"\bedge\sdevice",
    r"\bpersonal\scomputer",
    r"\bcommodity\shardware\b",
    r"\blocally[\s-]?(run|ran|running|executable|executable|deployed|executed|hosted|serving|available)\b",
    r"\b(?:run|runs|running|executed|executing|deployed|deploying|hosted|served|serving)\s+locally\b",
    r"\blocal\s(?:llm|llms|model|models|inference|deployment|execution|serving|environment|device|devices|machine|machines|computer|computers|hardware|chatbot|assistant)\b",
    r"\b(?:on[\s-]premise|on[\s-]prem)\b",
]

FAMILY_RE = [re.compile(p, re.I) for p in FAMILY_PATTERNS]
LOCAL_RE = [re.compile(p, re.I) for p in LOCAL_LANG_PATTERNS]


def norm_title(t):
    return re.sub(r"[^a-z0-9]+", "", t.lower())


def norm_doi(d):
    d = (d or "").strip().lower()
    d = re.sub(r"^(https?://)?(dx\.)?doi\.org/", "", d)
    return d.rstrip(".,")


def load_wos():
    records = []
    for tag, path in WO_SOURCES:
        with open(path, newline="", encoding="utf-8-sig") as f:
            for r in csv.DictReader(f):
                records.append({
                    "search": tag,
                    "title": (r.get("Article Title") or "").strip(),
                    "year": (r.get("Publication Year") or "").strip(),
                    "doi": norm_doi(r.get("DOI")),
                    "authors": (r.get("Authors") or "").strip(),
                    "source": (r.get("Source Title") or "").strip(),
                    "abstract": (r.get("Abstract") or "").strip(),
                    "keywords": (r.get("Author Keywords") or "").strip(),
                    "keywords_plus": (r.get("Keywords Plus") or "").strip(),
                    "ut": (r.get("UT (Unique WOS ID)") or "").strip(),
                    "doi_link": (r.get("DOI Link") or "").strip(),
                })
    return records


def load_scopus_keys():
    dois, titles = set(), set()
    for path in SCOPUS_SOURCES:
        with open(path, newline="", encoding="utf-8-sig") as f:
            for r in csv.DictReader(f):
                if r.get("DOI"):
                    dois.add(norm_doi(r["DOI"]))
                if r.get("Title"):
                    titles.add(norm_title(r["Title"]))
    return dois, titles


def screen(rec):
    """Return (decision, reason, benchmarks). decision in {include, ...}"""
    year_raw = rec["year"]
    try:
        year = int(year_raw)
    except ValueError:
        return "excluded", "no-year", set()
    text = " ".join([
        rec["title"], rec["abstract"], rec["keywords"], rec["keywords_plus"],
    ])
    benchmarks = {name for name, rx in BENCH_PATTERNS if rx.search(text)}
    if year < 2023 or year > 2026:
        return "excluded", "out-of-time-window", benchmarks
    if benchmarks == {"SWE-bench"} and year < 2024:
        return "excluded", "swe-window-2024plus", benchmarks
    if not benchmarks:
        return "excluded", "no-prespecified-benchmark", benchmarks
    family_hit = any(rx.search(text) for rx in FAMILY_RE)
    local_hit = any(rx.search(text) for rx in LOCAL_RE)
    if not (family_hit or local_hit):
        return "excluded", "benchmark-no-local-signal", benchmarks
    return "included", "benchmark+local-family-or-deployment", benchmarks


def main():
    append = "--append" in sys.argv

    wos = load_wos()
    per_search = Counter(r["search"] for r in wos)

    scopus_dois, scopus_titles = load_scopus_keys()

    seen = {}
    unique = []
    intra_dupes = 0
    scopus_dupes = 0
    for rec in wos:
        key_doi = rec["doi"] or None
        key_title = norm_title(rec["title"])
        if (key_doi and key_doi in seen) or key_title in seen:
            intra_dupes += 1
            continue
        if key_doi:
            seen[key_doi] = True
        seen[key_title] = True
        if (rec["doi"] and rec["doi"] in scopus_dois) or key_title in scopus_titles:
            scopus_dupes += 1
            continue
        unique.append(rec)

    decisions = []
    counts = Counter()
    included = []
    for rec in unique:
        decision, reason, benchmarks = screen(rec)
        counts[f"{decision}:{reason}"] += 1
        decisions.append((rec, decision, reason, benchmarks))
        if decision == "included":
            included.append(rec)

    with open(LOG_FILE, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["decision", "reason", "benchmarks", "search", "year", "title", "doi", "ut"])
        for rec, decision, reason, benchmarks in sorted(decisions, key=lambda d: d[1]):
            w.writerow([
                decision, reason, ";".join(sorted(benchmarks)), rec["search"],
                rec["year"], rec["title"], rec["doi"], rec["ut"],
            ])

    with open(NEW_CANDIDATES_FILE, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["Title", "Year", "DOI", "Link", "Source", "Abstract"])
        for rec in sorted(included, key=lambda r: (r["year"], r["title"].lower())):
            link = rec["doi_link"] or (
                f"https://www.webofscience.com/wos/woscc/full-record/{rec['ut']}"
                if rec["ut"] else ""
            )
            w.writerow([rec["title"], rec["year"], rec["doi"], link, rec["source"], rec["abstract"]])

    if append:
        with open(CANDIDATES_FILE, "a", newline="", encoding="utf-8") as f_out, \
             open(NEW_CANDIDATES_FILE, newline="", encoding="utf-8") as f_in:
            reader = csv.reader(f_in)
            next(reader)
            writer = csv.writer(f_out)
            n = 0
            for row in reader:
                writer.writerow(row)
                n += 1

    print(f"WoS records identified: {len(wos)}  {dict(per_search)}")
    print(f"Intra-WoS duplicates removed: {intra_dupes}")
    print(f"Duplicates vs Scopus removed: {scopus_dupes}")
    print(f"Records screened (title/abstract): {len(unique)}")
    for k, v in sorted(counts.items()):
        print(f"  {k}: {v}")
    print(f"Auto-included: {len(included)}")
    if append:
        print(f"Appended {len(included)} rows to {CANDIDATES_FILE}")


if __name__ == "__main__":
    main()
