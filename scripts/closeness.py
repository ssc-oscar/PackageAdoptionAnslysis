import sys
from collections import defaultdict

# package contribution
file1 = sys.argv[1]

file2 = sys.argv[2]

pkg2weight = defaultdict(list)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    pkg2weight[items[0]] = [float(items[1]), float(items[2])]
f1.close()

prj2score = defaultdict(list)
prj2pkg = defaultdict(set)

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    pkg = items[3]
    if pkg not in pkg2weight:
        continue
    if prj not in prj2pkg:
        prj2pkg[prj].add(pkg)
        prj2score[prj] = pkg2weight[pkg][:]
        continue
    if pkg not in prj2pkg[prj]:
        if pkg in pkg2weight:
            prj2pkg[prj].add(pkg)
            prj2score[prj][0] += pkg2weight[pkg][0]
            prj2score[prj][1] += pkg2weight[pkg][1]
            continue
        else:
            sys.stderr.write(
                'pkg:' + pkg + ' not found in weight. Requested from:\n' + line)
    # print(prj2score['martinbel_teradataR'])
f2.close()

for i, j in prj2score.items():
    print(i + ';' + ';'.join([str(j[0]), str(j[1])]))
