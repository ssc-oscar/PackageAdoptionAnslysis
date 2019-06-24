import sys

file1 = sys.argv[1]
pkg = sys.argv[2]

f1 = open(file1, 'r')
firstline_flag = 1

for line in f1:
    if firstline_flag == 1:
        firstline_flag = 0
        items = line.strip().split(';')
        index = items.index(pkg)
        continue
    else:
        items = line.strip().split(';')
        prj = items[0]
        if items[index] == '1':
            print prj
