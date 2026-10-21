#!/usr/bin/env python3
"""Fill missing first authors from the arXiv API for DOI-less records."""
import csv
import re
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


def lookup(title):
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
        return None
    names = [a.findtext(f"{ATOM}name") for a in best.findall(f"{ATOM}author")]
    return names[0] if names else None


rows = list(csv.DictReader(open("timeline.csv", encoding="utf-8")))
fields = list(rows[0].keys())
for r in rows:
    if r["first_author"]:
        continue
    try:
        a = lookup(r["title"])
    except Exception as e:
        print("error", r["title"][:40], type(e).__name__)
        a = None
    if a:
        r["first_author"] = a
        print(f"  {r['pub_date']:10} {a:25} {r['title'][:50]}")
    else:
        print(f"  miss {r['title'][:60]}")
    time.sleep(3)

with open("timeline.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    w.writerows(rows)
