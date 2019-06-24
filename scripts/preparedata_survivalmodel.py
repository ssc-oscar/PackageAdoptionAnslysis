import sys
import datetime
# file1 = ./update/pkg2atime.thatpoint.s


# if no reply before close one, close time is treated as first time as well.
def unixtime2timestamp(tmp):
    return datetime.datetime.fromtimestamp(int(tmp)).strftime('%Y')


if len(sys.argv) != 2:
    sys.exit('unexpected number of inputs\n')
file1 = sys.argv[1]

f1 = open(file1, 'r')
for line in f1:
    print(line.strip().split(' ')[0] + ';1')
    print(line.strip().split(' ')[0] + ';2')
    #items = line.strip().split(' ')[0].split(';')
    #print(';'.join([items[0], unixtime2timestamp(items[1]), '1']))
    #print(';'.join([items[0], unixtime2timestamp(items[1]), '2']))
f1.close()
