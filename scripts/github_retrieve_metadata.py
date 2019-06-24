import sys
import re
import pymongo
import json
import time
import datetime
from requests.auth import HTTPBasicAuth
import requests

login = sys.argv[1]
passwd = sys.argv[2]
prefixes = sys.argv[3]
ownrepo = sys.argv[4]
dbname = sys.argv[5]

client = pymongo.MongoClient(host="da1.eecs.utk.edu")
# Get a reference to a particular database
db = client[dbname]

pullurl = 'https://api.github.com/repos/' + ownrepo + '/pulls?state=all'
repourl = 'https://api.github.com/repos/' + ownrepo
issuesurl = 'https://api.github.com/repos/' + ownrepo + '/issues?state=all'
eventsurl = 'https://api.github.com/repos/' + ownrepo + '/issues/events'
commitsurl = 'https://api.github.com/repos/' + ownrepo + '/commits'
commitcommentsurl = 'https://api.github.com/repos/' + ownrepo + '/comments'
pull_commentsurl = 'https://api.github.com/repos/' + ownrepo + '/pulls/comments'
issue_commentsurl = 'https://api.github.com/repos/' + ownrepo + '/issues/comments'

######################################################
# revisede for retrieve files change in pull requests.
# append this to pull file url ':number/files'
pull_filesurl = 'https://api.github.com/repos/' + ownrepo + '/pulls/'


urlList = [pullurl, repourl, issuesurl, eventsurl, commitsurl,
           commitcommentsurl, pull_commentsurl, issue_commentsurl]
# urlList = [pull_commentsurl, issue_commentsurl]

# do for followers following starred subscriptions orgs gists repos events
# received_events

# for general one
# coll_list =
# ['repos','pull_requests','followers','following','events','issues','subscriptions','orgs','gists','received_events','starred']


collpull = db['pull']
collrepo = db['repo']
collissues = db['issues']
collevents = db['events']
collcommits = db['commits']
collcomments = db['commit_comments']
collpullcomments = db['pull_comments']
collissuecomments = db['issue_comments']

# collpullfiles = db['pull_files']
collList = [collpull, collrepo, collissues, collevents,
            collcommits, collcomments, collpullcomments, collissuecomments]

# collList = [collpullcomments, collissuecomments]

# Reference a particular collection in the database
# coll = db [collName]


fileList = ['pull', 'repo', 'issues', 'events', 'commits',
            'commitcomments', 'pull_comments', 'issue_comments']


gleft = 0


def wait(left):
    while (left < 20):
        l = requests.get('https://api.github.com/rate_limit',
                         auth=(login, passwd))
        if (l.ok):
            left = int(l.headers.get('X-RateLimit-Remaining'))
            reset = long(l.headers.get('x-ratelimit-reset'))
            now = long(time.time())
            dif = reset - now
            if (dif > 0 and left < 20):
                sys.stderr.write("waiting for " + str(dif) +
                                 "s until" + str(left) + "s\n")
                time .sleep(dif)
        time .sleep(0.5)
    return left

# github api changed, no longer links[0]


def get(url, coll, prefixes):
    global gleft
    gleft = wait(gleft)
    values = []
    size = 0
    # sys.stderr.write ("left:"+ str(left)+"s\n")
    try:
        r = requests .get(url, auth=(login, passwd))
        time .sleep(0.5)
        if (r.ok):
            gleft = int(r.headers.get('X-RateLimit-Remaining'))
            lll = r.headers.get('Link')
            #links = ['']
            # if lll is not None:
            #    links = lll.split(',')
            t = r.text.encode('utf-8')
            size += len(t)
            # print t
            array = json.loads(t)
            ts = datetime.datetime.utcnow()
            # mid = 0
            # revised for pull files
            for el in array:
                # mid = el ['id']
                coll.insert(el)
            while ('; rel="next"' in lll):
                gleft = int(r.headers.get('X-RateLimit-Remaining'))
                gleft = wait(gleft)
                # extract next url
                ll = lll.replace(';', ',').split(',')
                url = ll[ll.index(' rel="next"') -
                         1].replace('<', '').replace('>', '').lstrip()
                #
                #url = links[0] .split(';')[0].replace('<', '').replace('>', '')
                # print(url)
                try:
                    r = requests .get(url, auth=(login, passwd))
                    if (r.ok):
                        #        print('OK')
                        lll = r.headers.get('Link')
                        # print(lll)
                #        print(lll)
                        #l = ['']
                        # if lll is not None:
                        #    links = lll .split(',')
                        t = r.text.encode('utf-8')
                        # print t
                        size += len(t)
                        array1 = json.loads(t)
                        # revised for pull files
                        for el in array1:
                            #              mid = el ['id']
                            coll.insert(el)
            #            array = array + array1
                    else:
                        lll = ''
                except requests.exceptions.ConnectionError:
                    sys.stderr.write('could not get ' + url + '\n')

                    # print u';'.join((u, repo, t)).encode('utf-8')
#            print url + ';' + t
            '''
            f = open(prefixes, 'w')
            json.dump(array, f)
            f.close()
            '''
        else:
            sys.stderr.write(url + ';ERROR')
        # coll.insert({'pull number': pull_number,
        #             'file numbers': len(array), 'file changes': array})
    except requests.exceptions.ConnectionError:
        sys.stderr.write(url + ';ERROR')
    except Exception as e:
        sys.stderr.write(url + ';' + str(e))


# url = pullurl
# urlList
# collList

for i in range(len(urlList)):
    try:
        get(urlList[i], collList[i], prefixes + fileList[i] + '.' + dbname)
    except Exception as e:
        sys.stderr.write(str(e))

'''
for pull in collpull.find({}, {'number': True}):
    try:
        urlhere = pull_filesurl + str(pull['number']) + '/files'
        get(urlhere, collpullfiles, pull['number'])
    except Exception as e:
        sys.stderr.write(str(e))
'''
