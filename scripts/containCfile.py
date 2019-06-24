import sys

CfileT = sys.argv[1]
thatpoint = sys.argv[2]

CfileTdict = {}


f1 = open(CfileT, 'r')
for line in f1:
    items = line.strip().split(' ')[0].split(';')
    CfileTdict[items[0]] = items[1]
f1.close()

f2 = open(thatpoint, 'r')
for line in f2:
    items = line.strip().split(' ')[0].split(';')
    prj = items[0]
    atime = items[1]
    if prj in CfileTdict and int(CfileTdict[prj]) < int(atime):
        print(prj + ';' + '1')
    else:
        print(prj + ';' + '0')
f2.close()
