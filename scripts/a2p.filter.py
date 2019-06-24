import sys

matched = sys.argv[1].split(',')

for line in sys.stdin:
    items = line.strip().split(';')
    author = items[0]
    tmp = []
    for i in items[1:]:
        if i not in matched:
            tmp.append(i)
    print(author + ';' + ';'.join(tmp))
