import sys
import re


if len(sys.argv) != 3:
    sys.exit('Usage error, input don\'t match')

# pkg2atime(that point) = file1
# pkg2cmt2atime(all commits) = file2
file1 = sys.argv[1]
file2 = sys.argv[2]

dict1 = {}
outputdict = {}

f1 = open(file1, 'r')

for line in f1:
    items = line.strip().split(';')
    items[1] = re.sub(r' .*$', r'', items[1])
    dict1[items] = items[1]
f1.close()


f2 = open(file2, 'r')

for line in f2:
    items = line.strip().split(';')
    if items[2] == '':
        sys.stderr.write(';'.join(items) + ' missing atime stamp\n')
        continue
    items[2] = re.sub(r' .*$', r'', items[2])
    if items[0] not in dict1:
        sys.stderr.write(';'.join(items) +
                         ' missing project in ' + file1 + '\n')
        continue
    if int(items[2]) < int(dict1[items[0]]):
        if items[0] not in outputdict:
            outputdict[items[0]] = 0
        else:
            outputdict[items[0]] += 1
f2.close()

for i, j in outputdict.items():
    print(i + ';' + str(j))
