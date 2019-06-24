import pymongo
import datetime
import time
import calendar
import re
import sys
# datatable v.s. readr, tidyr, tibble


client = pymongo.MongoClient(host="da1.eecs.utk.edu")
# Get a reference to a particular database


def timestamp2unixtime(tmp):
    return int(calendar.timegm(time.strptime(tmp, '%Y-%m-%dT%H:%M:%SZ')))

# comments are all in issue_comments


def issueandfirstreponse(dbname):
    db = client[dbname]
    #collpull = db['pull']
    collissues = db['issues']
    collcomments = db['issue_comments']
    # for issue in collissues.find({'$and': [{'created_at': {'$gte':
    # "2012-01-06T00:00:00Z"}}, {'closed_at': {'$lte':
    # "2013-01-06T00:00:00Z"}}]}):

    for entry in collissues.find({}):
        c_time = timestamp2unixtime(entry['created_at'])
        # test closed_at time would be what? if null == None
        closed_time = entry['closed_at']
        if closed_time == None:
            closed_time = ''
        else:
            closed_time = timestamp2unixtime(closed_time)
        if entry['comments'] == 0:
            print(str(c_time) + ';' + ';' + str(closed_time))
            continue
        url = entry['url']
        time_list = []
        for record in collcomments.find({'issue_url': url}):
            time_list.append(timestamp2unixtime(record['created_at']))
        if len(time_list) == 0:
            sys.stderr.write(url+'\n')
        else:
            print(str(c_time) + ';' + str(min(time_list)) + ';' + str(closed_time))


if len(sys.argv) > 2:
    for i in sys.argv[1:]:
        issueandfirstreponse(i)
elif len(sys.argv) == 2:
    issueandfirstreponse(sys.argv[1])
else:
    sys.exit('unexpected number of inputs\n')
