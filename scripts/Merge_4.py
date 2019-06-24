# merge 4 p2c c2b b2pk => pcbpk
import sys
from collections import defaultdict
import gzip

cmtSet = set()
p2c = defaultdict(set)
# p2c
f1 = open(sys.argv[1], 'r')
for line in f1:
    items = line.strip().split(';')
    p2c[items[0]].update(set(items[1:]))
    cmtSet.update(set(items[1:]))

#c2b, gzipped
c2b = defaultdict(set)
blobSet = set()
f2 = gzip.open(sys.argv[2], 'r')
for line in f2:
    items = line.strip().split(';')
    c = items[0]
    b = items[1]
    if c in cmtSet:
        c2b[items[0]].add(b)
        blobSet.add(b)

#b2pkg, gzipped
b2pkg = defaultdict(set)
pkgSet = set()
f3 = gzip.open(sys.argv[3], 'r')
for line in f3:
    items = line.strip().split(';')
    b = items[0]
    #pkg = items[1:]
    if b in blobSet:
        b2pkg[b].update(set(items[1:]))
        pkgSet.update(set(items[1:]))


for p, clist in p2c.items():
    for c in clist:
        if c in c2b:
            for b in c2b[c]:
                if b in b2pkg:
                    for pk in b2pkg[b]:
                        print(';'.join([p, c, b, pk]))
