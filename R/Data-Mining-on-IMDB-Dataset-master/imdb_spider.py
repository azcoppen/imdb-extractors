import csv
from multiprocessing import Pool
from BeautifulSoup import *
import urllib2
url = "http://www.imdb.com/random/title"


def f(x):
    with open('imdb.csv', 'a') as f:
        w = csv.writer(f)
        for i in xrange(1):
            data = urllib2.urlopen(url).read()

            title = BeautifulSoup(data).html.head.title.string
            title = title.replace(" - IMDb", '')    

            actors = []
            for item in BeautifulSoup(data, parseOnlyThese=SoupStrainer('span',{'itemprop': 'name'})):      
                actors.append(item.string)

            generas = []
	    for div in BeautifulSoup(data, parseOnlyThese=SoupStrainer('div',{'itemprop': 'genre'})):
	        for a in div.findAll('a'):
	            generas.append(a.string.strip())

	    row = [title.encode('utf-8'), actors, generas]
	    print row
        
	    w.writerow(row)

p = Pool(40)
p.map(f, range(10000))
