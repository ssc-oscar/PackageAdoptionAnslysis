import sys

# file1 project.thatpoint file2: datatable.resp.time.s file3: tidy.resp.time.s
file1 = sys.argv[1]
file2 = sys.argv[2]
file3 = sys.argv[3]
listtuple2 = []
listtuple3 = []


def readin(listtuple, file2):
    f2 = open(file2, 'r')
    for line in f2:
        items = line.strip().split(';')
        if items[1] == '':
            continue
        listtuple.append((int(items[0]), int(items[1])))
    f2.close()


readin(listtuple2, file2)
readin(listtuple3, file3)


def readin2(listtuple, file2):
    f2 = open(file2, 'r')
    for line in f2:
        items = line.strip().split(';')
        if items[2] == '':
            items[2] = 0
        listtuple.append((int(items[0]), int(items[2])))
    f2.close()


listtuple22 = []
listtuple33 = []

readin2(listtuple22, file2)
readin2(listtuple33, file3)

# this way of calculating response average time is not used in our model.
def averagetime(pointtime, listtuple2):
    sum1 = 0
    issuenum = 0
    for i, j in listtuple2:
        if pointtime > j:
            sum1 += j - i
            issuenum += 1
    if issuenum == 0:
        avg1 = 'NULL'
    else:
        avg1 = float(sum1) / float(issuenum)

    return avg1

# listtuple contain created-time and closed_time


def unclosedissueratio(pointtime, listtuple):
    num = 0
    numall = 0
    for i, j in listtuple:
        numall += 1
        if pointtime > i:
            if j == 0 or j > pointtime:
                num += 1
        else:
            break
    if numall == 1:
        return 0
    return float(num) / float((numall - 1))
    #return float(num)


f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(' ')[0].split(';')
    prj = items[0]
    atime = items[1]
    overdatatable = averagetime(int(atime), listtuple2)
    overdata_unclosed = unclosedissueratio(int(atime), listtuple22)
    overtidy = averagetime(int(atime), listtuple3)
    overtidy_unclosed = unclosedissueratio(int(atime), listtuple33)
    print(prj + ';' + str(overdatatable) + ';' + str(overtidy) +
          ';' + str(overdata_unclosed) + ';' + str(overtidy_unclosed))
f1.close()
