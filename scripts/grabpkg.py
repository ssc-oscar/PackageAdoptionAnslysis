import sys


pkg = sys.argv[1]
fields = sys.argv[2]


fieldRange = fields.strip().split(',')
fieldBegin = int(fieldRange[0])
fieldEnd = -1
if len(fieldRange) == 2:
    fieldEnd = int(fieldRange)


for line in sys.stdin:
    items = line.strip().split(';')
    if fieldEnd == -1:
        if pkg in set(items[fieldBegin - 1:]):
            print line.strip()
    else:
        if pkg in set(items[fieldBegin - 1:fieldEnd]):
            print line.strip()
