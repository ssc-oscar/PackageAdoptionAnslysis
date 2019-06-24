# scrape down the R CRAN PACKAGE list:
from bs4 import BeautifulSoup
import requests
url = 'https://cran.r-project.org/src/contrib/Archive/'


r = requests.get(url)
t = r.text.encode('utf-8')
soup = BeautifulSoup(t, 'html.parser')
for row in soup.body.table.findAll('tr'):
    cols = row.findAll('td')
    if len(cols) == 0:
        continue
    # print(len(cols))
    # print(cols)
    a = cols[1].find('a')
    if a:
        if a.contents[0] != 'Parent Directory':
            package = a.contents[0]
            r1 = requests.get(url + package)
            t1 = r1.text.encode('utf-8')
            soup1 = BeautifulSoup(t1, 'html.parser')
            for row1 in soup1.body.table.findAll('tr'):
                cols1 = row1.findAll('td')
                if len(cols1) == 0:
                    continue
                # print(len(cols))
                # print(cols)
                a1 = cols1[1].find('a')
                if a1:
                    if a1.contents[0] != 'Parent Directory':
                        a2 = cols[2].find('a')
                        if a2:
                            print(
                                ';'.join(package[:-1], a1.contents[0], a2.contents[0]))
                            #year = a2.contents[0].strip().split(' ')[0].split('-')[0]
