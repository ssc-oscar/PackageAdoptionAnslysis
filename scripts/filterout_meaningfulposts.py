import pymongo
import sys

DB = sys.argv[1]
Coll = sys.argv[2]
client = pymongo.MongoClient(host="da1.eecs.utk.edu")

db = client[DB]
coll = db[Coll]

for i in coll.find({}):
    print(i['ViewCount'] + ',' + i['AnswerCount'] + ',' + i['Score'])
