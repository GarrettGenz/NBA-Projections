import datetime
import os, sys, time
from subprocess import call

endpoint = 'sportsdatabases.cki9udpbxnex.us-west-2.rds.amazonaws.com'
database = 'nbadb'
user = 'nbadb'
password = 'nbadb'

start_year = 2016
current_year = datetime.datetime.now().year
                                    
def find_str(s, char):
    index = 0

    if char in s:
        c = char[0]
        for ch in s:
            if ch == c:
                if s[index:index+len(char)] == char:
                    return index

            index += 1

    return -1
    
def find_between( s, first, last = "" ):
    try:
        start = s.index( first ) + len( first )
        if len(last) == 0:
            end = len(s) + 1
        else:
            end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""
        
def delete_files(days_old, path):
    now = time.time()
    cutoff = now - (days_old * 86400)
    
    files = os.listdir(path)
    for xfile in files:
        if os.path.isfile(path + xfile):
            t = os.stat(path + xfile)
            c = t.st_ctime
            print path + xfile 
            
            if c < cutoff:
                print 'Removing ' + path + xfile
                os.remove(path + xfile) 