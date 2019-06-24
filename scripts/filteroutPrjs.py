import sys

threshold = int(sys.argv[1])

for line in sys.stdin:
    items = line.strip().split(';')
    if int(items[1]) > threshold:
        print(items[0])
