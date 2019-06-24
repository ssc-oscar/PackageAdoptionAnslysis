import sys
# result in long format:

for line in sys.stdin:
    items = line.strip().split(';')
    if len(items) < 3 or len(items) != int(items[1]) + 2:
        sys.stderr.write(';'.join(items) + ' don\'t fit format\n')
        continue
    for i in range(int(items[1])):
        print(items[0] + ';' + items[i + 2])
