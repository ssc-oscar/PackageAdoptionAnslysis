import re

import sys
for line in sys.stdin:
    items = line.strip().split(';')
    if items[1] != '':
        l = []
        l.append(items[0])
        for i in items[1:]:
            if not (re.search(r'[^a-zA-Z0-9.]', i) or re.match(r'[0-9]', i) or re.match(r'.*\..*\..*', i)):
                if i != '':
                    l.append(i)
        if len(l) >= 2:
            print(';'.join(l))
