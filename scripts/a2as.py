import sys
from collections import defaultdict

# all these elses are here to deal with empty p or au
#a2p, p2a
file1 = sys.argv[1]
file2 = sys.argv[2]

a2p = defaultdict(set)
p2a = defaultdict(set)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    if items[1] != '':
        a2p[items[0]].update(items[1:])
    else:
        a2p[items[0]] = set()
f1.close()


f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    p = items[0]
    if p != '':
        for i in items[1:]:
            if i not in a2p:
                # exclude loops
                p2a[p].add(i)
f2.close()

a2as = defaultdict(set)

for i, j in a2p.items():
    if len(j) != 0:
        for p in j:
            if p in p2a:
                a2as[i].update(p2a[p])
    else:
        a2as[i] = set()
for k, j in a2as.items():
    print(k + ';' + ','.join(j))
