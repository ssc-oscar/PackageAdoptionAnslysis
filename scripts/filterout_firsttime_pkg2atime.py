import sys
import re

output = {}
for line in sys.stdin:
    items = line.strip().split(';')
    if items[0] not in output:
        if re.match(r'\d+\s+', items[1]):
            output[items[0]] = items[1]
        else:
            sys.stderr.write(line)

for i, j in output.items():
    print(i + ';' + j)
