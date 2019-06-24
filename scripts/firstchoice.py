import sys

if len(sys.argv) != 5:
    sys.exit('incorrect number of input parameters\n')

file1 = sys.argv[1]
file2 = sys.argv[2]
file3 = sys.argv[3]
file4 = sys.argv[4]


target1 = {}
f1 = open(file1, 'r')
for line in f1:
    prj, atime = line.strip().split(';')
    target1[prj] = atime
f1.close()

target2 = {}
f2 = open(file2, 'r')
for line in f2:
    prj, atime = line.strip().split(';')
    if prj not in target1:
        target2[prj] = atime
    else:
        if int(atime) < int(target1[prj]):
            target2[prj] = atime
            del target1[prj]
f2.close()

f3 = open(file3, 'w+')
for key, value in target1.items():
    f3.write(key + ';' + value + '\n')
f3.close()

f4 = open(file4, 'w+')
for key, value in target2.items():
    f4.write(key + ';' + value + '\n')
f4.close()
