#!/usr/bin/env python3
"""
Scopus Search Runner — PRISMA-S hit counts for the local-LLM coding review.

Auth model (Elsevier Scopus API):
  - Mandatory : X-ELS-APIKey    (free key from https://dev.elsevier.com)
  - Optional  : X-ELS-Insttoken (issued by your institution's librarian,
                tied to your API key; raises quota + unlocks fields)

Usage:
  export SCOPUS_API_KEY="your-key"
  export SCOPUS_INSTTOKEN="your-insttoken"    # optional
  python3 scopus_search.py [--raw] [--out results.json]

Prints per-string hit counts (usable for the PRISMA flow diagram) and saves
matching record metadata (eid, title, year) to results.json.

If a string returns an error (401 = bad key, 403 = missing insttoken,
429 = rate limit), it is reported but does not stop the run.
"""

import os
import sys
import json
import time
import argparse
import urllib.parse
import urllib.request

API_URL = "https://api.elsevier.com/content/search/scopus"

API_KEY = os.environ.get("SCOPUS_API_KEY", "")
INSTTOKEN = os.environ.get("SCOPUS_INSTTOKEN", "")

# MAIN, SUPP-1, SUPP-2 per search_strategy.md section 2.1 (Scopus)
STRINGS = {
    "MAIN-codegen": (
        '( TITLE-ABS-KEY ( "large language model*" OR "language model*" OR '
        '"code language model*" OR "coding model*" OR "foundation model*" OR LLM OR LLMs ) '
        'AND TITLE-ABS-KEY ( "code generation" OR "code completion" OR "code synthesis" OR '
        '"program synthesis" OR "software engineering" OR "software development" OR '
        '"automated program repair" OR "code repair" OR "bug fix*" OR "code intelligence" ) '
        'AND TITLE-ABS-KEY ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" ) )'
    ),
    "SUPP-1-local": (
        '( TITLE-ABS-KEY ( "large language model*" OR "language model*" OR LLM OR LLMs ) '
        'AND TITLE-ABS-KEY ( "code generation" OR "code completion" OR "software engineering" OR '
        '"program synthesis" OR coding ) '
        'AND TITLE-ABS-KEY ( local OR "on-device" OR "self-hosted" OR "open-weight*" OR '
        'quantiz* OR "consumer hardware" OR "edge device*" OR "personal computer*" ) )'
    ),
    "SUPP-2-model": (
        '( TITLE-ABS-KEY ( "Qwen2.5-Coder" OR "Qwen3-Coder" OR CodeLlama OR CodeGemma OR '
        'StarCoder OR "DeepSeek-Coder" OR "Llama-3" OR "Gemma-3" OR Mistral OR "Phi-4" ) '
        'AND TITLE-ABS-KEY ( HumanEval OR MBPP OR LiveCodeBench OR BigCodeBench OR "SWE-bench" ) )'
    ),
}


def build_headers():
    headers = {
        "Accept": "application/json",
        "X-ELS-APIKey": API_KEY,
    }
    if INSTTOKEN:
        headers["X-ELS-Insttoken"] = INSTTOKEN
    return headers


def run_search(label, query, count=25):
    params = urllib.parse.urlencode({
        "query": query,
        "count": count,
        "date": "2023-2026",
    })
    url = f"{API_URL}?{params}"
    req = urllib.request.Request(url, headers=build_headers())
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")
        return {"label": label, "error": f"HTTP {e.code}", "detail": body[:300]}
    except Exception as e:  # network
        return {"label": label, "error": str(e)}

    total = None
    records = []
    se = data.get("search-results", {})
    if isinstance(se, dict):
        total = se.get("opensearch:totalResults")
        for entry in se.get("entry", []):
            if entry.get("error"):
                continue
            records.append({
                "eid": entry.get("eid"),
                "title": entry.get("dc:title"),
                "year": entry.get("prism:coverDate"),
                "source": entry.get("prism:publicationName"),
                "doi": entry.get("prism:doi"),
            })
    result = {"label": label, "total": total, "records": records}
    print(f"  {label:<16} total={total}")
    return result


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", action="store_true", help="print raw record JSON")
    ap.add_argument("--out", default="scopus_results.json")
    args = ap.parse_args()

    if not API_KEY:
        print("ERROR: set SCOPUS_API_KEY env var (get a free key at https://dev.elsevier.com)")
        sys.exit(1)

    print(f"Scopus API key set: {'yes' if API_KEY else 'no'}")
    print(f"Insttoken set:      {'yes' if INSTTOKEN else 'no'}")
    print("Running searches (2023-2026)...\n")

    results = []
    for label, query in STRINGS.items():
        results.append(run_search(label, query))
        time.sleep(1)  # be polite to rate limits

    with open(args.out, "w") as f:
        json.dump(results, f, indent=2)
    print(f"\nSaved per-record metadata to {args.out}")

    if args.raw:
        print("\n--- Raw records ---")
        print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
