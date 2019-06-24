import sys

# file1 ->  update/a2as.datatable
# file2 ->  update/a2as.tidy
file1 = sys.argv[1]
file2 = sys.argv[2]

datatable = {}
tidy = {}

f1 = open(file1, 'r')
for line in f1:
    items = line.strip().split(';')
    author11 = items[0]
    datatable[author11] = 1
    for i in items[1].split(','):
        datatable[i] = 2
f1.close()

f2 = open(file2, 'r')
for line in f2:
    items = line.strip().split(';')
    author21 = items[0]
    tidy[author21] = 1
    for i in items[1].split(','):
        tidy[i] = 2
f2.close()

f1set = set(datatable.keys())
f2set = set(tidy.keys())

for f1u in f1set - f2set:
    print(f1u + ';' + '1;0')
#f2set - f1set
for f2u in f2set - f1set:
    print(f2u + ';' + '0;1')
#f1set & f2set
for f12 in f1set & f2set:
    alllayers = datatable[f12] + tidy[f12]
    f1weight = float(1) / float(alllayers) * tidy[f12]
    f2weight = float(1) / float(alllayers) * datatable[f12]
    print(f12 + ';' + str(f1weight) + ';' + str(f2weight))
