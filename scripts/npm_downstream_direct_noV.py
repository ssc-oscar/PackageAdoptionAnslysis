import sys
#import pymongo
from collections import defaultdict

file1 = sys.argv[1]
#file1 = '/data/play/eco-network/folder4permission/npm_layered_dependency_npms.npms_all_20180517'


direct_downstream = defaultdict(set)

f1 = open(file1, 'r')

for line in f1:
    items = line.strip().split(',')
    if items[2] != '1':
        down = items[0]
        up = items[1]
        direct_downstream[up].add(down)

for i, j in direct_downstream.items():
    print(i + ';' + ','.join(list(j)))
