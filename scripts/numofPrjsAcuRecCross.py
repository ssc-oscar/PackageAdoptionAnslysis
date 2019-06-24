import sys
from bisect import bisect
import datetime

if len(sys.argv) != 4:
    sys.exit('number of parameters error\n')

# file1 each project point(sorted) for package 1
# file2 each project point(sorted) for package 2
# file3 the prefix name for 1to2 and 2to1 result
file1 = sys.argv[1]
file2 = sys.argv[2]
prefix = sys.argv[3]


def today(unixtime):
    return str(datetime.datetime.fromtimestamp(int(unixtime)).strftime('%Y-%m-%d'))

# gonna a yyyymmdd number


def properdate(ymd, period_len):
    dayst = 0
    yearst = 0
    monthst = 0
    YMD = ymd.split('-')
    month = int(YMD[1])
    year = int(YMD[0])
    dayst = int(YMD[2])
    if month <= period_len:
        monthst = 12 + month - period_len
        yearst = year - 1
    else:
        yearst = year
        monthst = month - period_len
    if monthst < 10:
        monthst = '0' + str(monthst)
    if dayst < 10:
        dayst = '0' + str(dayst)

    return int(str(yearst) + str(monthst) + str(dayst))


# 1. include forks
# accumulative
# new one
list1 = []
list2 = []

da2ti = {}
ti2da = {}

f1 = open(file1, 'r')
for line in f1:
    atime = line.strip().split(';')[1].split(' ')[0]
    list1 .append(int(atime))
f1.close()
f2 = open(file2, 'r')
for line in f2:
    atime = line.strip().split(';')[1].split(' ')[0]
    list2 .append(int(atime))
f2.close()

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    atime = int(items[1].split(' ')[0])
    index = bisect(list2, atime)
    if index != 0 and list2[index - 1] == atime:
        da2ti[prj] = bisect(list2, atime - 1)
    else:
        da2ti[prj] = index
f1.close()

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    atime = int(items[1].split(' ')[0])
    index = bisect(list1, atime)
    if index != 0 and list1[index - 1] == atime:
        ti2da[prj] = bisect(list1, atime - 1)
    else:
        ti2da[prj] = index
f2.close()

# recent ones
# unit month
# I exclude that day say 9/8  - 12/8, will exclude 9/8, start from 9/9,
# exclude 12/8, end on 12/7
period = 6
da2tiRe = {}
ti2daRe = {}


def listtime2listdate(un2date):
    date = today(un2date)
    intatime = int(''.join(date.split('-')))
    return intatime


list1 = map(listtime2listdate, list1)
list2 = map(listtime2listdate, list2)

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    atime = items[1].split(' ')[0]
    date = today(atime)
    datestart = properdate(date, period)
    dateend = int(''.join(date.split('-'))) - 1  # exclude that same day
    recentapps = bisect(list2, dateend) - bisect(list2, datestart)
    da2tiRe[prj] = recentapps
f1.close()

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    atime = items[1].split(' ')[0]
    date = today(atime)
    datestart = properdate(date, period)
    dateend = int(''.join(date.split('-'))) - 1  # exclude that same day
    recentapps = bisect(list1, dateend) - bisect(list1, datestart)
    ti2daRe[prj] = recentapps
f2.close()

# outputs:da2tiRe ti2daRe da2ti ti2da
# prefix
file3 = prefix + '.1to2'
file4 = prefix + '.2to1'
f3 = open(file3, 'w')
f4 = open(file4, 'w')
for i, j in da2ti.items():
    f3.write(i + ';' + str(j) + ';' + str(da2tiRe[i]) + '\n')
for i, j in ti2da.items():
    f4.write(i + ';' + str(j) + ';' + str(ti2daRe[i]) + '\n')

f3.close()
f4.close()

# 2. exclude forks
# only require a different file1. which only includes the ordered
# applications of non forks.
