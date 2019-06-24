import sys
import datetime

# file1 = ./update/datatable.resp.time.s
# file2 = ./update/tidy.resp.time.s


# if no reply before close one, close time is treated as first time as well.

# not gonna use it
def unixtime2timestamp(tmp):
    return datetime.datetime.fromtimestamp(int(tmp)).strftime('%Y')


if len(sys.argv) != 3:
    sys.exit('unexpected number of inputs\n')
file1 = sys.argv[1]
file2 = sys.argv[2]


def readin(file1, listtupple):
    f1 = open(file1, 'r')
    issue_id = 0
    for line in f1:
        items = line.strip().split(';')
        issuestart = items[0]
        issuereply = items[1]
        issueend = items[2]
        listtupple.append((issue_id, issuestart, issuereply, issueend))
        issue_id += 1
    f1.close()


'''
listtuple1 = []
listtuple2 = []
readin(file1, listtuple1)
readin(file2, listtuple2)
'''


def to_yeardot(tmp):
    tmp = str(tmp)
    day = tmp[-2:]
    month = tmp[4:6]
    year = tmp[0:4]
    return int(100 * (float(year) + float(month) / 12))
#+ float(day) / 30 / 12


def nexttime(tmp):
    return tmp + 60 * 60 * 24


def nextday(tmp):
    return unixtime2timestamp(tmp + 60 * 60 * 24)


def to_day(tmp):
    return tmp / (60 * 60 * 24) + 1


# current time = 1518102720

# don't exclude any record??? even though it's closed
# do it for everyday
# begin time : 1377272318 -> 2013082360
# end time: 1518090698 -> 20180208
# time gap between every tow days:  60 * 60 * 24
# output format: status;time;date;package(1,2)


def generatedata(f, list_id, end):
    fr = open(f, 'r')
    for line in fr:
        items = line.strip().split(';')
        issuestart = items[0]
        issuereply = items[1]
        issueend = items[2]
    #test_date = unixtime2timestamp(start)
    #test_time = int(start)
    #freshyear = test_date[:4]
    #sys.stderr.write('year at ' + freshyear + '\n')
        if issueend == '':
            print('0' + ';' + str(int(end) - int(issuestart)) +
                  ';' + str(unixtime2timestamp(issuestart)) + ';' + str(list_id))
        else:
            print('1' + ';' + str(int(issueend) - int(issuestart)) +
                  ';' + str(unixtime2timestamp(issuestart)) + ';' + str(list_id))

    fr.close()


generatedata(file1, 1, 1518102720)
generatedata(file2, 2, 1518102720)
