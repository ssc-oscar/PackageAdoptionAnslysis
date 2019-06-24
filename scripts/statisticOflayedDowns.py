import sys
from collections import defaultdict

file1 = sys.argv[1]
file2 = sys.argv[2]

f1set = set()
f2set = set()
f1layers = f2layers = 0

f1dict = {}
f2dict = {}

f1 = open(file1, 'r')
f2 = open(file2, 'r')
# ignore first line
firstline = True
for line in f1:
    if firstline:
        firstline = False
        continue
    f1set.update(line.strip().split(','))
    f1layers += 1
    for x in line.strip().split(','):
        f1dict[x] = f1layers
f1.close()

firstline = True
for line in f2:
    if firstline:
        firstline = False
        continue
    f2set.update(line.strip().split(','))
    f2layers += 1
    for x in line.strip().split(','):
        f2dict[x] = f2layers
f2.close()


print('1st pkg\'s downstreams in num: ' + str(len(f1set)))
print('1st pkg\'s downstreams in layers: ' + str(f1layers))
print('2nd pkg\'s downstreams in num: ' + str(len(f2set)))
print('2nd pkg\'s downstreams in layers: ' + str(f2layers))
print('overlaps of packages in num: ' + str(len(f1set & f2set)))
print('overlaps ratio for each: ' + str(float(len(f1set & f2set)) /
                                        float(len(f1set))) + '\t' + str(float(len(f1set & f2set)) / float(len(f2set))))


# downstreams direct dict
file3 = sys.argv[3]

downstreamdict = defaultdict(set)
f3 = open(file3, 'r')
for line in f3:
    items = line.strip().split(';')
    prj = items[0].split('|')[0]
    downstreamdict[prj].update(items[1].split(','))
f3.close()

file4 = sys.argv[4]


def numofDownstreams(targets):
    occuredpkgset = set()
    list1 = [targets]
    list2 = set()
    downstreams = set()
    while len(list1) != 0:
        # print(','.join(list1))
        while len(list1) != 0:
            prj = list1.pop(0)
            if prj not in downstreamdict:
                continue
            for i in downstreamdict[prj]:
                if i not in occuredpkgset:
                    list2.add(i)
                    occuredpkgset.add(i)
        downstreams.update(list2)
        list1 = list(list2)[:]
        list2 = set()
    return len(downstreams)


f4 = open(file4, 'w')
# weight each package
#f1set - f2set
for f1u in f1set - f2set:
    f4.write(f1u + ';' + '1;0\n')
#f2set - f1set
for f2u in f2set - f1set:
    f4.write(f2u + ';' + '0;1\n')
#f1set & f2set
for f12 in f1set & f2set:
    alllayers = f1dict[f12] + f2dict[f12]
    f1weight = float(1) / float(alllayers) * f2dict[f12]
    f2weight = float(1) / float(alllayers) * f1dict[f12]
    f4.write(f12 + ';' + str(f1weight) + ';' + str(f2weight) + '\n')
f4.close()

for shared in f1set & f2set:
    sys.stderr.write(shared + ';' + str(f1dict[shared]) + ';' +
                     str(f2dict[shared]) + ';' + str(numofDownstreams(shared)) + '\n')


# overlaps on each layer
f1 = open(file1, 'r')
f2 = open(file2, 'r')
f1layered = defaultdict(set)
f2layered = defaultdict(set)
# ignore first line
firstline = True
layerindex = 0
for line in f1:
    if firstline:
        firstline = False
        continue
    layerindex += 1
    f1layered[str(layerindex)].update(line.strip().split(','))
f1.close()

firstline = True
layerindex = 0
for line in f2:
    f1layered[layerindex]
    if firstline:
        firstline = False
        continue
    layerindex += 1
    f2layered[str(layerindex)].update(line.strip().split(','))
f2.close()

layerindex = 1
while layerindex <= min(len(f1layered.keys()), len(f2layered.keys())):
    common = len(f1layered[str(layerindex)] & f2layered[str(layerindex)])
    if common == 0:
        print('layer ' + str(layerindex) + ' has no packages in common')
    else:
        print('layer ' + str(layerindex) + ': ' + '\t' + str(float(
            common) / float(len(f1layered[str(layerindex)]))) + '\t' + str(float(common) / float(len(f2layered[str(layerindex)]))))
    layerindex += 1
