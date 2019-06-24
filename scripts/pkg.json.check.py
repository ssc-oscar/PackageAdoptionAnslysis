import json
import sys
import subprocess

deps = ['dependencies', 'devDependencies', 'optionalDependencies',
        'peerDependencies', 'bundledDependencies']
# these packages might not be full or right... e.g. ember can be
# ember-source, angular can be angular.js, and there are many tools to
# install instead of package.json

# screen -r 40849

targetedPKGs = ['vue', 'react', 'preact', 'ember', 'jquery', 'angular']

for line in sys.stdin:
    blob = line.strip()
    retjson = subprocess.check_output(
        "echo " + blob + " | perl -I ~audris/lib64/perl5 showpkgcnt.perl package.json ", shell=True)
    # print(retjson)

    try:
        ret = json.loads(retjson)
    except Exception as e:
        sys.stderr.write(e.message + '\n')
        continue
    for dep in deps:
        for pkg in targetedPKGs:
            if dep in ret and pkg in ret[dep]:
                name = 'NULL'
                version = 'NULL'
                if 'name' in ret:
                    name = ret['name']
                if 'version' in ret:
                    version = ret['version']
                print blob + ',' + dep + ',' + name + ',' + version + ',' + pkg
