import sys
import datetime as d

file1 = sys.argv[1]
file2 = sys.argv[2]
years = sys.argv[3]

current_year = d.datetime.now().year

pkg2changes = {}

with open(file2, 'r') as f2:
    for line in f2:
        items = line.strip().split(';')
        year = items[-1].split(' ')[0].split('-')[0]

        if items[0] not in pkg2changes:
            if int(current_year) - int(year) <= int(years):
                pkg2changes[items[0]] = 1
            else:
                pkg2changes[items[0]] = 0
        else:
            if int(current_year) - int(year) <= int(years):
                pkg2changes[items[0]] += 1

with open(file1, 'r') as f1:
    for line in f1:
        items = line.strip().split(';')
        print(
            ';'.join([items[0], str(len(items) - 1), str(pkg2changes[items[0]])]))
