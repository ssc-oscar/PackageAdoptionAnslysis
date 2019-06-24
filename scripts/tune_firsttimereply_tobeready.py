import sys

prj2time1 = {}
prj2time2 = {}

prjlist = []

index = 0
predictedtime1 = 0
for line in sys.stdin:
    index += 1
    if index % 2 != 0:
        items = line.strip().split(';')
        prj = items[0]
        predictedtime1 = items[3]
        continue
    else:
        items = line.strip().split(';')
        prj = items[0]
        predictedtime2 = items[3]
        print(';'.join([prj, predictedtime1, predictedtime2]))
