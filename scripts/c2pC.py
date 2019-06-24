import sys
import gzip
import re
from collections import defaultdict

prjfile = sys.argv[1]

f1 = open(prjfile, 'r')

prjset = set()

for line in f1:
    prj = line.strip()
    prjset.add(prj)
f1.close()

# not sure if commit.[0-7].c2fb would be able to be handled within memory,
# but let's try

prefix = '/data/update/CRAN/'
# filter out C files
# these commits have C files
cmtset = defaultdict(set)
for i in range(8):
    g = gzip.open(prefix + 'commit.' + str(i) + '.c2fb', 'r')
    for line in g:
        items = line.strip().split(';')
        match = re.match(r'.*\.[cC]$', items[1].split('/')[-1])
        if match is None:
            continue
        cmtset[items[0]].add(items[1])
    g.close()

#stdin is zcat /data/update/CRAN/N*olist.gz
for line in sys.stdin:
    items = line.strip().split(';')
    if items[1] != 'commit':
        continue
    if items[0] not in prjset:
        continue
    cmt = items[2]
    prj = items[0]
    if cmt in cmtset:
        print(cmt + ';' + prj + ';' + ';'.join(cmtset[cmt]))
