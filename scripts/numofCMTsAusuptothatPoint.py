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
outputdict = {}
pkg2aus = defaultdict(set)

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
    if items[3] == '':
        sys.stderr.write(';'.join(items) + ' missing atime stamp\n')
        continue
    items[3] = re.sub(r' .*$', r'', items[3])
    if items[0] not in dict1:
        sys.stderr.write(';'.join(items) +
                         ' missing project in ' + file1 + '\n')
        continue
    try:
        if int(items[3]) < int(dict1[items[0]]):
            if items[0] not in outputdict:
                outputdict[items[0]] = 1
            else:
                outputdict[items[0]] += 1
            pkg2aus[items[0]].add(items[2])
    except Exception as e:
        sys.stderr.write(str(e) + '\n')
        sys.stderr.write(items[3] + ';' + dict1[items[0]] + '\n' + line)
f2.close()

for i, j in outputdict.items():
    print(i + ';' + str(j) + ';' + str(len(pkg2aus[i])))
# complementary
for k in set(dict1.keys()) - set(outputdict.keys()):
    print(k + ';0;0')
