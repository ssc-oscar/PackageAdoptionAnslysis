import gzip
import sys
from collections import defaultdict


# file1 = '/data/basemaps/gz/c2pFullI.forks'
# file2 = '/data/play/RthruMaps/Rprj2pkgs.all'
file1 = sys.argv[1]
file2 = sys.argv[2]

fork_map = {}
tmp_result = defaultdict(list)

f1 = gzip.open(file1, 'r')
for line in f1:
    key, value = line.strip().split(';')
    fork_map[key] = value
f1.close()

f2 = open(file2, 'r')
firstline = f2.readline()
prjlist = firstline.strip().split(';')[1:]


# I use the canonical name
# as long as one fork installed a package, this canonical row installed
# this package.
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    if prj not in fork_map:
        tmp_result[prj] = map(int, items[1:])
    else:
        if fork_map[prj] not in tmp_result:
            tmp_result[fork_map[prj]] = map(int, items[1:])
        else:
            tmp_result[fork_map[prj]] = map(lambda x: x[0] | x[1], zip(
                tmp_result[fork_map[prj]], map(int, items[1:])))
f2.close()

# reduce num of columns
value_sum = [0] * len(prjlist)
for prj, values in tmp_result.items():
    value_sum = map(sum, zip(values, value_sum))


output_slice = []
for i, j in enumerate(value_sum):
    if j > 0:
        output_slice.append(i)

# output
print('projects;' + ';'.join([prjlist[i] for i in output_slice]))
for prj, values in tmp_result.items():
    print(prj + ';' + ';'.join([str(values[i]) for i in output_slice]))
