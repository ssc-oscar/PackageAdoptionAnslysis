import sys
from collections import defaultdict
import datetime
import operator
import gzip
# da4
# the input file need to be sorted by time first


# need to change file1 when you do another file source.

if len(sys.argv) != 2:
    sys.exit('number of input parameter error\n')

file1 = sys.argv[1]


#file1 = '/data/play/RthruMaps/pkgCmtTime.output.su.4filter2'

f1 = gzip.open(file1, 'r')


# the input file is sorted by atime, so cmts are randomly distributed


# first pass
# clustering or trasitive closure sets

pkgs2cmt = defaultdict(set)
cmt2pkgs = defaultdict(set)

pkgiterated = set()
cmtiterated = set()

pkg2clst = {}
clst2pkgs = defaultdict(set)

for line in f1:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    atime = items[2]

    cmt2pkgs[cmt].add(prj)
    pkgs2cmt[prj].add(cmt)
f1.close()

current_clst = 0

for pkg in pkgs2cmt:
    intermedia_list = []
    if pkg not in pkgiterated:
        intermedia_list.append(pkg)
        pkgiterated.add(pkg)
        clst2pkgs[str(current_clst)].add(pkg)
        pkg2clst[pkg] = current_clst

        while len(intermedia_list) != 0:
            targetpkg = intermedia_list.pop(0)
            for cmt in pkgs2cmt[targetpkg] - cmtiterated:
                cmtiterated.add(cmt)
                for ppkg in cmt2pkgs[cmt] - pkgiterated:
                    pkgiterated.add(ppkg)
                    intermedia_list.append(ppkg)
                    clst2pkgs[str(current_clst)].add(ppkg)
                    pkg2clst[ppkg] = current_clst

        current_clst += 1


# testing
# dump clst2pkgs
# for i, j in clst2pkgs.items():
#    print(str(i))
#    print(j)
# print(current_clst)

# now we have clusters, 2nd pass,

clst2time = {}

# each cluster's representor is a prj
clst2represent = {}

f2 = gzip.open(file1, 'r')

for line in f2:
    items = line.strip().split(';')
    prj = items[0]
    cmt = items[1]
    atime = items[2]

    if str(pkg2clst[prj]) not in clst2time:
        clst2time[str(pkg2clst[prj])] = atime.split(' ')[0]
        clst2represent[str(pkg2clst[prj])] = prj

f2.close()


clst2time_s = sorted(clst2time.items(), key=operator.itemgetter(1))

for i, j in clst2time_s:
    print(clst2represent[i] + ';' + j)


'''
# kind of calling toMonth.py
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


lastmonth = 'NULL'
monthapplications = 0
for pkg, time in clst2time_s:
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
'''
