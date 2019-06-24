import sys
from collections import defaultdict
import gzip

# we have: datatable.bpf.New2018CRAN and tidy.bpf.New2018CRAN
# da4, /data/update/CRAN/commit.[0-7].c2fb problematic, take first 3 fields as being valid
# => bfcp, match bf to get c
# gonna do a 8 pieces multi-process and merge


if len(sys.argv) != 4:
    sys.exit('unexpected number of inputs\n')

bpf = sys.argv[1]
c2fb = sys.argv[2]
piece = sys.argv[3]


bf2p = defaultdict(set)

f1 = open(bpf, 'r')
for line in f1:
    items = line.strip().split(';')
    b = items[0]
    p = items[1]
    f = '/' + items[2]
    bf2p[b + ';' + f].add(p)
f1.close()
f3 = open(piece, 'w')
f2 = gzip.open(c2fb, 'r')
for line in f2:
    items = line.strip().split(';')
    c = items[0]
    f = items[1]
    b = items[2]
    if b + ';' + f in bf2p:
        for i in bf2p[b + ';' + f]:
            f3.write(b + ';' + f + ';' + c + ';' + i + '\n')
f2.close()
f3.close()
