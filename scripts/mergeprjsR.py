import sys
from collections import defaultdict

prj2pkgs = defaultdict(set)
for line in sys.stdin:
    items = line.strip().split(';')
    prj2pkgs[items[0]].update(set(items[1:]))

for prj, pkgs in prj2pkgs.items():
    print(prj + ';' + ';'.join(pkgs))
