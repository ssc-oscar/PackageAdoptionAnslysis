from collections import defaultdict
import gzip
import sys

file1 = sys.argv[1]

f1 = gzip.open(file1, 'r')

blob2pkgs = defaultdict(set)

cmt2pkgs = defaultdict(set)

for line in f1:
    items = line.strip().split(';')
    cmt2pkgs[items[0]] = set(items[1:])
f1.close()

for line in sys.stdin:
    items = line.strip().split(';')
    if items[0] in cmt2pkgs:
        for prj in items[1:]:
            print(prj + ';' + ';'.join(cmt2pkgs[items[0]]))
