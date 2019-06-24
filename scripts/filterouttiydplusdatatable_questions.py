import sys
import re
import pymongo
import json
import datetime

client = pymongo.MongoClient(host="da1.eecs.utk.edu")

DB = sys.argv[1]
COLL = sys.argv[2]
field = sys.argv[3]
# allow multiple comma seperated targets simultaneoulsy, up to 2 maybe..
TARGETS = sys.argv[4]
targets = map(lambda x: x.replace('.', '\\.'), TARGETS.split(','))


# for whatever reason, double backslash fits data.table case ....

fields = field.split(',')
field1 = fields[0]
field2 = fields[1]

if len(sys.argv) < 5:
    sys.exit('unexpected number of inputs')
elif len(sys.argv) == 5:
    excludes = []
else:
    excludes = sys.argv[5:]


# stdin assumes project + ';' + timestamp
def unixtime2timestamp(tmp):
    return datetime.datetime.fromtimestamp(int(tmp)).strftime('%Y-%m-%dT%H-%M-%S.500')


prj2timestamp = {}
for line in sys.stdin:
    items = line.strip().split(';')
    prj = items[0]
    timestamp = unixtime2timestamp(items[1])
    prj2timestamp[prj] = timestamp


db = client[DB]
coll = db[COLL]
#coll2 = db['Posts_title_body_' + 'datatable']
coll2 = db['Posts_title_body_tidy_readr_tibble']
# assume we only concern about questions, ignore answers

# print(targets)
#targets[0] = targets[0].replace('.', '\.')

target = '|'.join(targets)
print(target)

Id_list = set()

for prj in prj2timestamp:
    if len(excludes) != 0:
        results = coll.find({field1: {'$regex': target, '$not': re.compile(excludes[0]), '$options': 'i'},
                             'PostTypeId': '1'}, {'_id': 0})
    else:
        results = coll.find({field1: {'$regex': target, '$options': 'i'},
                             'PostTypeId': '1'}, {'_id': 0})
#    print(len(list(results)))
    for i in results:
        if i['Id'] not in Id_list:
            #            print(i['Score'])
            if int(i['Score']) > 0:

                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                i['AnswerCount'] = int(i['AnswerCount'])
                i['ViewCount'] = int(i['ViewCount'])
                coll2.insert(i)
                Id_list.add(i['Id'])

    if len(excludes) != 0:
        results = coll.find({field2: {'$regex': target, '$not': re.compile(excludes[0]), '$options': 'i'},
                             'PostTypeId': '1'}, {'_id': 0})
    else:
        results = coll.find({field2: {'$regex': target, '$options': 'i'},
                             'PostTypeId': '1'}, {'_id': 0})

    for i in results:
        if i['Id'] not in Id_list:
            if int(i['Score']) > 0:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                i['AnswerCount'] = int(i['AnswerCount'])
                i['ViewCount'] = int(i['ViewCount'])
                coll2.insert(i)
                Id_list.add(i['Id'])
        # coll2.insert(i)
