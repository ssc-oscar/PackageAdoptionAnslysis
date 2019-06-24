import sys
import gzip
from collections import defaultdict

file1 = sys.argv[1]
file2 = sys.argv[2]

CRAN_package_set = set()
conancialname = {}
pkg2projects = defaultdict(set)
with open(file1, 'r') as f1:
    for line in f1:
        CRAN_package_set.add(line.strip().split(';')[0])

with gzip.open(file2, 'r') as f2:
    for line in f2:
        items = line.strip().split(';')
        conancialname[items[0]] = items[1]


for line in sys.stdin:
    items = line.strip().split(';')
    packages = items[5:]
    project = items[2]
    for pkg in packages:
        if pkg in CRAN_package_set:
            if project in conancialname:
                project = conancialname[project]
            pkg2projects[pkg].add(project)

for pkg, projects in pkg2projects.items():
    print(';'.join([pkg] + list(projects)))
