import sys
from collections import defaultdict

file1 = sys.argv[1]
file2 = sys.argv[2]

pkgcmtdict = defaultdict(set)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    if prj not in pkgcmtdict or cmt not in pkgcmtdict[prj]:
        print(';'.join(items))
        pkgcmtdict[prj].add(cmt)
f1.close()

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    if prj not in pkgcmtdict or cmt not in pkgcmtdict[prj]:
        print(';'.join(items))
        pkgcmtdict[prj].add(cmt)
f2.close()
