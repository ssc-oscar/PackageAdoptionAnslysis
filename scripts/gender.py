import sys
import gzip
from collections import defaultdict

if len(sys.argv) != 4:
    sys.exit('incorrect number of inputs')

# pkg2Allcmttime
file1 = sys.argv[1]
# thatpoint
file2 = sys.argv[2]
# gender file (gziped file)
file3 = sys.argv[3]
pkg2atime = {}

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    ctime = items[1].split(' ')[0]
    if ctime.isdigit():
        pkg2atime[items[0]] = int(ctime)
f2.close()

pkg2aus = defaultdict(set)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    ctime = items[3].split(' ')[0]
    if ctime.isdigit():
        prj = items[0]
        if prj in pkg2atime:
            if int(ctime) < pkg2atime[prj]:
                pkg2aus[prj].add(items[2])
f1.close()

genderdict = {}
f3 = gzip.open(file3, 'r')
for line in f3:
    items = line.strip().split(';')
    genderdict[items[0]] = items[1]
f3.close()

for pkg, aus in pkg2aus.items():
    gendist = {}
    gendist['Unknow'] = 0
    gendist['Undetermined'] = 0
    gendist['Female'] = 0
    gendist['Male'] = 0
    for au in aus:
        if au not in genderdict:
            gendist['Unknow'] += 1
            continue
        gendist[genderdict[au]] += 1
    print(pkg + ';' + ';'.join(map(str,
                                   [gendist['Male'], gendist['Female'], gendist['Undetermined'], gendist['Unknow']])))
