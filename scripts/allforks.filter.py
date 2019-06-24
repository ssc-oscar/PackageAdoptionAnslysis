import sys
from collections import defaultdict
import datetime
import operator
import re
import gzip
# da4
# the input file need to be sorted by time first


# need to change file1 when you do another file source.

if len(sys.argv) != 3:
    sys.exit('number of input parameter error\n')

file1 = sys.argv[1]
file2 = sys.argv[2]

#file1 = '/data/play/RthruMaps/pkgCmtTime.output.su.4filter2'
#file2 = '/data/basemaps/gz/c2pFullI.forks'
f1 = open(file1, 'r')
f2 = gzip.open(file2, 'r')

# the input file is sorted by atime, so cmts are randomly distributed

allforks = {}
reverse_forks = defaultdict(set)
prj2time = {}

for line in f2:
    key, value = line.strip().split(';')
    allforks[key] = value
f2.close()

for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    atime = items[2]
    if prj not in prj2time:
        if re.match(r'\d+\s+', atime):
            prj2time[prj] = atime.split(' ')[0]
            if prj in allforks:
                reverse_forks[allforks[prj]].add(prj)
            else:
                reverse_forks[prj].add(prj)
f1.close()
for key, value in reverse_forks.items():
    representor = sorted(
        map(lambda x: (x, prj2time[x]), value), key=lambda tup: tup[1])[0]
    print(representor[0] + ';' + str(representor[1]))
