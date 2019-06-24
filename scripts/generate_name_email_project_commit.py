from collections import defaultdict
import re
import sys

prefix_project = "https://github.com/"
prefix_commit = "commit"

file1dict = {}


def generate(file1, file2, pkgUrl, pkg):
    with open(file1, 'r') as f1:
        for line in f1:
            items = line.strip().split(' ')[0].split(';')
            if len(items) != 2:
                sys.exit("entry error:\n" + ';'.join(items) + '\n')
            project = items[0]
            atime = items[1]
            if project in file1dict:
                sys.exit("duplicate entry error:\n" + ';'.join(items) + '\n')
            file1dict[project] = atime
    with open(file2, 'r') as f2:
        for line in f2:
            items = line.strip().split(';')
            project = items[0]
            commit = items[1]
            author = items[4]
            atime = items[6].split(' ')[0]
            segments = author.split(' ')
            emailstr = re.match(r'<(.+)>', segments[-1])
            if emailstr != None:
                email = emailstr.group(1)
            else:
                sys.stderr.write("wrong email extration:\n" + author + '\n')
                continue
            if (len(segments) >= 3):
                firstname = segments[0]
                lastname = segments[-2]
            elif (len(segments) == 2):
                firstname = segments[0]
                lastname = ''
            else:
                sys.exit("wrong author name extration:\n" + author + '\n')

            # innerjoin
            if project not in file1dict:
                #sys.exit("project: " + project + ' not exist in pkg2atime.filter2.thatpoint\n')
                continue
            elif file1dict[project] != atime:
                #sys.exit("project: " + project + ' time does not match:' + file1dict[project] + ' vs ' + atime + '\n')
                continue
            else:
                print(','.join([firstname, lastname, email, '_'.join(project.split('_')[1:]), prefix_project + project.replace(
                    '_', '/', 1), prefix_project + project.replace('_', '/', 1) + '/' + prefix_commit + '/' + commit, pkg, pkgUrl]))


# tibble | tidyr | readr.
# data.table


if __name__ == "__main__":
    if(len(sys.argv) != 5):
        sys.exit("expected four input file names\n")
    file_p2atime = sys.argv[1]
    file_pct = sys.argv[2]
    pkgUrl = sys.argv[3]
    pkg = sys.argv[4]
    pkg = pkg.replace(',', ' | ')
    print(','.join(['First Name', 'Last Name', 'Email', 'Project',
                    'Project URL', 'Commit URL', 'Package', 'Package URL']))
    generate(file_p2atime, file_pct, pkgUrl, pkg)
