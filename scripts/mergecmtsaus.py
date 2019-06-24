import sys

file1 = sys.argv[1]
file2 = sys.argv[2]

prj2cmtaus = {}
f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj2cmtaus[items[0]] = ';'.join(items[1:])
f1.close()


f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    if items[0] not in prj2cmtaus:
        prj2cmtaus[items[0]] = ';'.join(items[1:])
    else:
        if int(items[1]) > int(prj2cmtaus[items[0]].split(';')[0]):
            prj2cmtaus[items[0]] = ';'.join(items[1:])
f2.close()

for prj, cmtaus in prj2cmtaus.items():
    print(prj + ';' + cmtaus)
