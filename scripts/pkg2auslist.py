import sys
import re
from collections import defaultdict

if len(sys.argv) != 3:
    sys.exit('Usage error, input don\'t match')

# pkg2atime(that point) = file1
# pkg2cmt2au2atime(all commits) = file2
file1 = sys.argv[1]
file2 = sys.argv[2]

dict1 = {}
outputdict = defaultdict(set)


# look, here I only output the numbers, no details on authors and cmts

f1 = open(file1, 'r')

for line in f1:
    items = line.strip().split(';')
    items[1] = re.sub(r' .*$', r'', items[1])
    dict1[items[0]] = items[1]
f1.close()


f2 = open(file2, 'r')

for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    auth = items[2]
    ctime = items[3].split(' ')[0]
    if ctime.isdigit():
        if prj in dict1:
            if int(ctime) < int(dict1[prj]):
                outputdict[prj].add(auth)
f2.close()

for i, j in outputdict.items():
    print(i + ';' + ';'.join(j))
