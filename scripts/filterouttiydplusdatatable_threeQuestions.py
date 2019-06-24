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
targets = list(map(lambda x: x.replace('.', '\\.'), TARGETS.split(',')))


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
#coll2 = db['Posts_title_body_question_0' + 'tidy_readr_tibble']
#coll3 = db['Posts_title_body_question_5' + 'tidy_readr_tibble']
#coll4 = db['Posts_title_body_question_20' + 'tidy_readr_tibble']
coll2 = db['Posts_title_body_question_0' + targets[0]]
coll3 = db['Posts_title_body_question_5' + targets[0]]
coll4 = db['Posts_title_body_question_20' + targets[0]]
#coll2 = db['Posts_title_body_all_tidy_readr_tibble']
#coll2 = db['Posts_title_body_tidy_readr_tibble']
# assume we only concern about questions, ignore answers

# print(targets)
#targets[0] = targets[0].replace('.', '\.')

target = '|'.join(targets)
print(target)

Id_list = set()

for prj in prj2timestamp:
    if len(excludes) != 0:
        results = coll.find({field1: {'$regex': target, '$not': re.compile(
            excludes[0]), '$options': 'i'}, 'PostTypeId': "1"}, {'_id': 0}, no_cursor_timeout=True)
    else:
        results = coll.find(
            {field1: {'$regex': target, '$options': 'i'}, 'PostTypeId': "1"}, {'_id': 0}, no_cursor_timeout=True)
#    print(len(list(results)))
    for i in results:
        #print("at least have one in results")
        if i['Id'] not in Id_list:
            if int(i['Score']) >= 0 and int(i['Score']) < 5:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll2.insert(i)
                Id_list.add(i['Id'])
            if int(i['Score']) >= 5 and int(i['Score']) < 20:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll3.insert(i)
                Id_list.add(i['Id'])
            if int(i['Score']) >= 20:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll4.insert(i)
                Id_list.add(i['Id'])

    if len(excludes) != 0:
        results = coll.find({field2: {'$regex': target, '$not': re.compile(
            excludes[0]), '$options': 'i'}, 'PostTypeId': "1"}, {'_id': 0}, no_cursor_timeout=True)
    else:
        results = coll.find(
            {field2: {'$regex': target, '$options': 'i'}, 'PostTypeId': "1"}, {'_id': 0}, no_cursor_timeout=True)
#    print(len(list(results)))
    for i in results:
        if i['Id'] not in Id_list:
            if int(i['Score']) >= 0 and int(i['Score']) < 5:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll2.insert(i)
                Id_list.add(i['Id'])
            if int(i['Score']) >= 5 and int(i['Score']) < 20:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll3.insert(i)
                Id_list.add(i['Id'])
            if int(i['Score']) >= 20:
                # convert to int
                i['Score'] = int(i['Score'])
                i['CommentCount'] = int(i['CommentCount'])
                #i['AnswerCount'] = int(i['AnswerCount'])
                #i['ViewCount'] = int(i['ViewCount'])
                coll4.insert(i)
                Id_list.add(i['Id'])
