from __future__ import print_function
import sys
from collections import defaultdict


prj2pkgs = defaultdict(set)

pkgTimes = {}
Allpkgs = set()

for line in sys.stdin:
    items = line.strip().split(';')
    prj2pkgs[items[0]] = set(items[1:])
    Allpkgs.update(set(items[1:]))
    for p in items[1:]:
        if p not in pkgTimes:
            pkgTimes[p] = 0
        else:
            pkgTimes[p] += 1

meaningfulPkgs = set()

for i, j in pkgTimes.items():
    meaningfulPkgs.add(i)

immuteableOrder = list(meaningfulPkgs)
print("projects;" + ';'.join(immuteableOrder))

for prj in prj2pkgs:
    if len(prj2pkgs[prj] & meaningfulPkgs) != 0:
        print(prj, end='')
        for i in immuteableOrder:
            if i in prj2pkgs[prj]:
                print (";1", end='')
            else:
                print (";0", end='')
        print('')
