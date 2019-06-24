import sys


if len(sys.argv) < 5:
    sys.exit('error in number of parameters\n')


file1 = sys.argv[1]
field_index1 = int(sys.argv[2])
file2 = sys.argv[3]
field_index2 = int(sys.argv[4])
Yes = True
if len(sys.argv) == 5 or int(sys.argv[5]) > 0:
    Yes = True
else:
    Yes = False

set1 = set()

f1 = open(file1, 'r')
for line in f1:
    set1.add(line.strip().split(';')[field_index1 - 1])
f1.close()

f2 = open(file2, 'r')
if Yes:
    for line in f2:
        if line.strip().split(';')[field_index2 - 1] in set1:
            print line.strip()
else:
    for line in f2:
        if line.strip().split(';')[field_index2 - 1] not in set1:
            print line.strip()
f2.close()
