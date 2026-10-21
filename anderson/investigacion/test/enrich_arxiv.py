#!/usr/bin/env python3
"""
Fill remaining publication dates from the arXiv API for DOI-less records.

Reads timeline_meta.json, queries arXiv by title for rows with no pub_date,
and writes the date back when a title match is confident.
"""
import json
import re
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

ATOM = "{http://www.w3.org/2005/Atom}"
UA = "prisma-timeline/1.0"


def norm(t):
    t = re.sub(r"[^a-z0-9 ]+", " ", (t or "").lower())
    return re.sub(r"\s+", " ", t).strip()


def score(a, b):
    import difflib
    return difflib.SequenceMatcher(None, norm(a), norm(b)).ratio()


def arxiv_lookup(title):
    q = urllib.parse.quote(f'ti:"{title}"')
    url = f"http://export.arxiv.org/api/query?search_query={q}&max_results=5"
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as r:
        root = ET.fromstring(r.read())
    best, bs = None, 0.0
    for e in root.findall(f"{ATOM}entry"):
        t = (e.findtext(f"{ATOM}title") or "").strip()
        s = score(title, t)
        if s > bs:
            bs, best = s, e
    if best is None or bs < 0.85:
        return None, bs
    published = (best.findtext(f"{ATOM}published") or "")[:10]
    return published, bs


def main():
    rows = json.load(open("timeline_meta.json", encoding="utf-8"))
    for i, r in enumerate(rows, 1):
        if r.get("pub_date"):
            continue
        try:
            date, s = arxiv_lookup(r["Title"].strip())
        except Exception as e:
            print(f"  error {i}: {type(e).__name__}", file=sys.stderr)
            continue
        if date:
            r["pub_date"] = date
            r["date_kind"] = f"arxiv:{s:.2f}"
            print(f"  {i:3} {date}  {r['Title'][:55]}")
        else:
            print(f"  miss {i:3} ({s:.2f}) {r['Title'][:55]}", file=sys.stderr)
        time.sleep(3)  # arXiv asks for >=3s between calls

    json.dump(rows, open("timeline_meta.json", "w", encoding="utf-8"),
              ensure_ascii=False, indent=1)

    import csv
    cols = ["idx", "pub_date", "date_kind", "year_source", "title", "first_author",
            "authors", "source", "doi", "doi_resolved", "crossref_status",
            "crossref_type", "link", "abstract"]
    with open("timeline_meta.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        for i, r in enumerate(rows, 1):
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


if __name__ == "__main__":
    main()
