import sys
import gzip

# update
file1 = sys.argv[1]
# old
file2 = sys.argv[2]
# conanical name
file3 = sys.argv[3]
update_set = set()
old_set = set()

conancialname = {}

with gzip.open(file3, 'r') as f3:
    for line in f3:
        items = line.strip().split(';')
        conancialname[items[0]] = items[1]

with gzip.open(file1, 'r') as f1:
    for line in f1:
        update_set.add(line.strip().split(';')[0])

with open(file2, 'r') as f2:
    for line in f2:
        prj = line.strip().split(';')[0]
        if prj in conancialname:
            prj = conancialname[prj]
        old_set.add(prj)

inter = update_set & old_set

print('old set size: ' + str(len(old_set)))
print('new set size: ' + str(len(update_set)))
print('common set size:' + str(len(inter)))
