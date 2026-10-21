#!/usr/bin/env python3
"""
Build the metadata layer for timeline.csv.

Input : included_candidates_116.csv  (Title, Year, DOI, Link, Source, Abstract)
Output: timeline_meta.json / timeline_meta.csv

Enriches each candidate with Crossref publication dates (online-first preferred),
first author, and a resolved DOI where the candidate row had none.

No third-party dependencies: urllib + csv only.
"""
import csv
import json
import re
import difflib
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

MAILTO = "sebperz@example.org"  # polite pool; replace with a real address if desired
SRC = "included_candidates_116.csv"
UA = f"prisma-timeline/1.0 (mailto:{MAILTO})"


def get_json(url, timeout=25, retries=4):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(req, timeout=timeout) as r:
                return json.load(r)
        except urllib.error.HTTPError as e:
            if e.code in (429, 500, 502, 503, 504) and attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
        except (urllib.error.URLError, TimeoutError):
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise


def norm_title(t):
    t = re.sub(r"<[^>]+>", "", t or "")
    t = re.sub(r"[^a-z0-9 ]+", " ", t.lower())
    return re.sub(r"\s+", " ", t).strip()


def date_from(msg):
    """Return (date_str, kind). Prefer earliest public appearance."""
    candidates = []
    for key in ("published-online", "published", "issued", "published-print"):
        dp = (msg.get(key) or {}).get("date-parts") or []
        if dp and dp[0] and dp[0][0]:
            parts = dp[0] + [None, None]
            y, m, d = parts[0], parts[1], parts[2]
            if isinstance(y, str):
                try:
                    y = int(y)
                except ValueError:
                    continue
            if y < 1990 or y > 2030:
                continue
            if m:
                s = f"{y:04d}-{int(m):02d}"
                s = s + f"-{int(d):02d}" if d else s
            else:
                s = f"{y:04d}"
            candidates.append((s, key))
    if not candidates:
        # Deposit date is a last resort: it is not a publication date.
        dp = (msg.get("created") or {}).get("date-parts") or []
        if dp and dp[0] and dp[0][0]:
            y = int(dp[0][0]); m = dp[0][1] if len(dp[0]) > 1 else None
            candidates.append((f"{y:04d}-{int(m):02d}" if m else f"{y:04d}", "created"))
    if not candidates:
        return "", ""
    # earliest string sorts correctly for zero-padded ISO
    candidates.sort(key=lambda x: x[0])
    return candidates[0]


def by_doi(doi):
    url = f"https://api.crossref.org/works/{urllib.parse.quote(doi)}?mailto={MAILTO}"
    msg = get_json(url)["message"]
    return msg, "doi"


def by_title(title):
    q = urllib.parse.quote(title)
    url = (f"https://api.crossref.org/works?query.bibliographic={q}"
           f"&rows=5&select=DOI,title,author,published-online,published-print,issued,"
           f"container-title,type&mailto={MAILTO}")
    items = get_json(url)["message"]["items"]
    want = norm_title(title)
    best, score = None, 0.0
    for it in items:
        for cand in it.get("title") or []:
            s = difflib.SequenceMatcher(None, want, norm_title(cand)).ratio()
            if s > score:
                best, score = it, s
    if best and score >= 0.90:
        return best, f"title-match:{score:.2f}"
    return None, f"unresolved:{score:.2f}"


def enrich(row):
    title = row["Title"].strip()
    doi = row["DOI"].strip()
    msg, how = None, ""
    try:
        if doi:
            msg, how = by_doi(doi)
        else:
            msg, how = by_title(title)
    except Exception as e:  # network / 404 / malformed
        msg, how = None, f"error:{type(e).__name__}"
    out = dict(row)
    out["crossref_status"] = how
    if not msg:
        out.update(pub_date="", date_kind="", first_author="", authors="",
                   doi_resolved="", crossref_title="", crossref_type="")
        return out
    d, kind = date_from(msg)
    authors = msg.get("author") or []
    names = []
    for a in authors:
        fam = a.get("family") or ""
        giv = a.get("given") or ""
        names.append((fam + ", " + giv).strip(", ") if fam else (a.get("name") or ""))
    out["pub_date"] = d
    out["date_kind"] = kind
    out["first_author"] = names[0] if names else ""
    out["authors"] = "; ".join(n for n in names if n)
    out["doi_resolved"] = (msg.get("DOI") or "").lower()
    out["crossref_title"] = (msg.get("title") or [""])[0]
    out["crossref_type"] = msg.get("type") or ""
    return out


def main():
    with open(SRC, newline="", encoding="utf-8", errors="replace") as f:
        rows = list(csv.DictReader(f))
    print(f"loaded {len(rows)} candidates", file=sys.stderr)

    results = [None] * len(rows)

    def work(i):
        r = enrich(rows[i])
        results[i] = r
        time.sleep(0.2)
        return i

    with ThreadPoolExecutor(max_workers=3) as ex:
        for n, _ in enumerate(ex.map(work, range(len(rows))), 1):
            if n % 20 == 0:
                print(f"  {n}/{len(rows)}", file=sys.stderr)

    with open("timeline_meta.json", "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=1)

    cols = ["idx", "pub_date", "date_kind", "year_source", "title", "first_author",
            "authors", "source", "doi", "doi_resolved", "crossref_status",
            "crossref_type", "link", "abstract"]
    with open("timeline_meta.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        for i, r in enumerate(results, 1):
            w.writerow({
                "idx": i,
                "pub_date": r.get("pub_date", ""),
                "date_kind": r.get("date_kind", ""),
                "year_source": r["Year"].strip(),
                "title": r["Title"].strip(),
                "first_author": r.get("first_author", ""),
                "authors": r.get("authors", ""),
                "source": r["Source"].strip(),
                "doi": r["DOI"].strip(),
                "doi_resolved": r.get("doi_resolved", ""),
                "crossref_status": r.get("crossref_status", ""),
                "crossref_type": r.get("crossref_type", ""),
                "link": r["Link"].strip(),
                "abstract": r["Abstract"].strip(),
            })

    ok = sum(1 for r in results if r.get("pub_date"))
    print(f"dated {ok}/{len(results)}; wrote timeline_meta.json / timeline_meta.csv",
          file=sys.stderr)


if __name__ == "__main__":
    main()
