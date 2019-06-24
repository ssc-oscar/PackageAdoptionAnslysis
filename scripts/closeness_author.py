import sys
from collections import defaultdict

# author contribution
file1 = sys.argv[1]

file2 = sys.argv[2]

auth2weight = defaultdict(list)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    auth2weight[items[0]] = [float(items[1]), float(items[2])]
f1.close()

prj2score = defaultdict(list)
#prj2auth = defaultdict(set)

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    auths = items[1:]
    prj2score[prj] = [0, 0]
    for auth in auths:
        if auth in auth2weight:
            prj2score[prj][0] += auth2weight[auth][0]
            prj2score[prj][1] += auth2weight[auth][1]
    prj2score[prj][0] /= float(len(auths))
    prj2score[prj][1] /= float(len(auths))
f2.close()

for i, j in prj2score.items():
    print(i + ';' + ';'.join(map(str, j)))
