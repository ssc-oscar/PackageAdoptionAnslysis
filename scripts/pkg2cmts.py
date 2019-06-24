import sys
from collections import defaultdict


if len(sys.argv) != 2:
    sys.exit('Unexpected number of inputs\n')

pkg2cmts = defaultdict(set)


pkgfile = sys.argv[1]

pkgset = set()

f1 = open(pkgfile, 'r')
for line in f1:
    pkg = line.strip()
    pkgset.add(pkg)
f1.close()

for line in sys.stdin:
    items = line.strip().split(';')
    if items[1] != 'commit':
        continue
    sha = items[2]
    prj = items[0]
    if prj not in pkgset:
        continue
    pkg2cmts[prj].add(sha)

for i, j in pkg2cmts.items():
    print(i + ';' + str(len(j)) + ';' + ';'.join(j))
