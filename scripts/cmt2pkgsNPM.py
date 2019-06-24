from collections import defaultdict
import gzip
import sys

file1 = sys.argv[1]

f1 = gzip.open(file1, 'r')

blob2pkgs = defaultdict(set)

cmt2pkgs = defaultdict(set)

for line in f1:
    items = line.strip().split(';')
    if '' in items:
        items.remove('')
    blob2pkgs[items[0]] = set(items[1:])
f1.close()

for line in sys.stdin:
    items = line.strip().split(';')
    for b in items[1:]:
        if b in blob2pkgs:
            cmt2pkgs[items[0]].update(blob2pkgs[b])

for i, j in cmt2pkgs.items():
    print(i + ';' + ';'.join(j))
