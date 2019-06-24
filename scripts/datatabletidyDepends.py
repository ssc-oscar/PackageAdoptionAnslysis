import sys
from collections import defaultdict

# downstreams direct dict
file1 = sys.argv[1]

downstreamdict = defaultdict(set)
f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0].split('|')[0]
    downstreamdict[prj].update(items[1].split(','))
f1.close()


targetpkg = sys.argv[2]
targets = targetpkg.split(',')


occuredpkgset = set()
list1 = targets
list2 = set()

while len(list1) != 0:
    print(','.join(list1))
    while len(list1) != 0:
        prj = list1.pop(0)
        if prj not in downstreamdict:
            continue
        for i in downstreamdict[prj]:
            if i not in occuredpkgset:
                list2.add(i)
                occuredpkgset.add(i)
    list1 = list(list2)[:]
    list2 = set()
