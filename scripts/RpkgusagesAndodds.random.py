import gzip
import sys
from collections import defaultdict
import scipy.stats as stats
import numpy as np
import random
# file1 = 'Rprj2pkgs.all.nonforks'

random.seed()

file1 = sys.argv[1]
constant = int(sys.argv[2])
file2 = sys.argv[3]
exclude = sys.argv[4]

tmp_result = defaultdict(list)


f1 = open(file1, 'r')
firstline = f1.readline()
pkglist = firstline.strip().split(';')[1:]
output_slice = random.sample(range(len(pkglist)), constant)


sys.stderr.write("first section done\n")

#value_array = np.zeros(len(prjlist), dtype=np.int32)
#value_sum = [0] * len(prjlist)
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    tmp_result[prj] = [int(items[1:][i]) for i in output_slice]
    #value_sum = map(sum, zip(map(int, items[1:]), value_sum))
    #value_array += np.array(list(map(int, items[1:])))
f1.close()
sys.stderr.write("first section done\n")
# exclude projects not use any of the randomly selected package set
if int(exclude) > 0:
    keys = list(tmp_result.keys())[:]
    for key in keys:
        value = tmp_result[key]
        if sum(value) == 0:
            del tmp_result[key]


# output
print('projects;' + ';'.join([pkglist[i] for i in output_slice]))
for prj, values in tmp_result.items():
    print(prj + ';' + ';'.join(map(str, values)))
sys.stderr.write("second section done\n")


def InaNotInb(a, b):
    return len(list(filter(lambda x: x[0] > x[1], zip(a, b))))


def InaInb(a, b):
    return len(list(filter(lambda x: x[0] == 1 and x[1] == 1, zip(a, b))))


def NotaNotb(a, b):
    return len(list(filter(lambda x: x[0] == 0 and x[1] == 0, zip(a, b))))


# create fisher test for every pair of packages and save:
# pkg matrix

pkgnames = [pkglist[i] for i in output_slice]
f3 = open(file2, 'w+')
pkg2vector = defaultdict(list)
pkg2vector_exclude = defaultdict(list)

for i in range(len(output_slice)):
    tmp = []
    for key, values in tmp_result.items():
        tmp.append(values[i])
    pkg2vector[pkgnames[i]] = tmp

sys.stderr.write("third section done\n")


for i in range(len(pkgnames)):
    for j in range(i + 1, len(pkgnames)):
        a = pkg2vector[pkgnames[i]]
        b = pkg2vector[pkgnames[j]]
        oddsratio, pvalue = stats.fisher_exact(
            [[InaInb(a, b), InaNotInb(b, a)], [InaNotInb(a, b), NotaNotb(a, b)]])
        f3.write(pkgnames[i] + ';' + pkgnames[j] + ';' + ';'.join(map(str, [InaInb(a, b), InaNotInb(
            b, a), InaNotInb(a, b), NotaNotb(a, b)])) + ';' + str(oddsratio) + ';' + str(pvalue) + '\n')

f3.close()


sys.stderr.write("done done\n")
