import sys
from bisect import bisect
import datetime

if len(sys.argv) != 2:
    sys.exit('number of parameters error\n')

# file1 each project point(sorted)
# file2
file1 = sys.argv[1]


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
lastvalue = 0
lastatime = ''
line_index = 0

prj2numsA = {}
f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    atime = items[1]

    if atime != lastatime:
        prj2numsA[prj] = line_index
        lastvalue = line_index
        lastatime = atime
    else:
        prj2numsA[prj] = lastvalue

    line_index += 1
f1.close()
# recent ones
# unit month
# I exclude that day say 9/8  - 12/8, will exclude 9/8, start from 9/9,
# exclude 12/8, end on 12/7
period = 6
atimeslist = []
prj2numsR = {}
f2 = open(file1, 'r')
for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    atime = items[1].split(' ')[0]
    try:
        date = today(atime)
    except Exception as e:
        sys.stderr.write(str(e) + '\n')
        continue
    datestart = properdate(date, period)
    dateend = int(''.join(date.split('-'))) - 1  # exclude that same day
    recentapps = bisect(atimeslist, dateend) - bisect(atimeslist, datestart)

    prj2numsR[prj] = recentapps

    intatime = int(''.join(date.split('-')))
    atimeslist.append(intatime)
f2.close()

for i, j in prj2numsA.items():
    if i in prj2numsR:
        print(i + ';' + str(j) + ';' + str(prj2numsR[i]))

# 2. exclude forks
# only require a different file1. which only includes the ordered
# applications of non forks.
