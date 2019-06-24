import datetime
import sys
import re
import operator

# filter the time when one project firstly use it and tune time to month
# stdin: /data/play/RthruMaps/pkgCmtTime.output2.su pkgCmtTime.output.su

# now, remove forks simply by detecting the appendeix part.

# need to fill month gap

pkg2time = {}


if len(sys.argv) != 2:
    sys.exit('unexpected number of inputs\n')
# fork == 0, nothing got changed, fork == 1, remove fork
fork = sys.argv[1]

twelveMonth = []
for i in range(1, 10):
    twelveMonth.append('0' + str(i))
for j in range(3):
    twelveMonth.append('1' + str(j))


def tomonth(unixtime):
    return str(datetime.datetime.fromtimestamp(int(unixtime)).strftime('%Y-%m'))

# return a list


def fillgap(MonthA, MonthB):
    yearA, monthA = MonthA.split('-')
    yearB, monthB = MonthB.split('-')
    ret = []
    if int(yearA) < int(yearB):
        tophalf = twelveMonth[twelveMonth.index(monthA) + 1:]
        bomhalf = twelveMonth[0:twelveMonth.index(monthB)]
        for i in tophalf:
            ret.append(yearA + '-' + i)
        # fill empty years
        for h in range(int(yearA) + 1, int(yearB)):
            for hh in twelveMonth:
                ret.append(str(h) + '-' + hh)
        for j in bomhalf:
            ret.append(yearB + '-' + j)
        return ret
    else:
        for i in range(twelveMonth.index(monthA) + 1, twelveMonth.index(monthB)):
            ret.append(yearA + '-' + twelveMonth[i])
        return ret


for line in sys.stdin:
    items = line.strip().split(';')
    if fork == '0':
        pkg = items[0]
    else:
        # now, remove forks simply by detecting the appendeix part.
        pkg = re.sub(r'.*_([^_]*$)', r'\1', items[0])
    #
    if pkg in pkg2time:
        continue
    pkg2time[pkg] = items[1].split(' ')[0]

# I guess since the UNIX time for these data are with constant length, can
# do a rough sort as follows:
pkg2time_s = sorted(pkg2time.items(), key=operator.itemgetter(1))

lastmonth = 'NULL'
monthapplications = 0
for pkg, time in pkg2time_s:
    #print(pkg + ';' + tomonth(time))
    if tomonth(time) == lastmonth:
        monthapplications += 1
    else:
        if lastmonth != 'NULL':
            print(lastmonth + ';' + str(monthapplications))
            # here to fill month gap
            for i in fillgap(lastmonth, tomonth(time)):
                print(i + ';' + '0')
        lastmonth = tomonth(time)
        monthapplications = 1
print(lastmonth + ';' + str(monthapplications))
