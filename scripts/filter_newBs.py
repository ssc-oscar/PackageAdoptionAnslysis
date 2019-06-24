import sys
import gzip

file1 = sys.argv[1]
field1 = sys.argv[2]
file2 = sys.argv[3]
field2 = sys.argv[4]
Isgzip = sys.argv[5]

if Isgzip != 0:
    f2 = gzip.open(file2, 'r')
    f1 = gzip.open(file1, 'r')
else:
    f2 = open(file2, 'r')
    f1 = open(file1, 'r')

donedict = set()
for line in f2:
    items = line.strip().split(';')
    donedict.add(items[int(field2) - 1])
f2.close()

for line in f1:
    items = line.strip().split(';')
    if items[int(field1) - 1] not in donedict:
        print(items[int(field1) - 1])
f1.close()
