import sys

if len(sys.argv) != 3:
    sys.exit('incorrect number of inputs')


#file1 = pkgAllCmtTime.output.su
#file2 = pkg2atime.thatpoint.s
prj2starttime = {}

file1 = sys.argv[1]
file2 = sys.argv[2]

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    ctime = items[3].split(' ')[0]
    if ctime.isdigit():
        if prj in prj2starttime:
            if int(ctime) < prj2starttime[prj]:
                prj2starttime[prj] = int(ctime)
        else:
            prj2starttime[prj] = int(ctime)
    else:
        sys.stderr.write(line)
f1.close()

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(' ')[0].split(';')
    prj = items[0]
    if prj not in prj2starttime:
        sys.stderr.write(prj + ';ERROR\n')
        continue
    end = int(items[1])
    print(prj + ';' + str(end - prj2starttime[prj]))
f2.close()
