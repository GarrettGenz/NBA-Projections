# -*- coding: utf-8 -*-

from bs4 import BeautifulSoup
import psycopg2
import urllib2
import config

def main():
    try:
        conn = conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    except:
        print "I am unable to connect to the database"
        
    cur = conn.cursor()
    
    url = urllib2.urlopen('http://www.rotowire.com/basketball/nba_lineups.htm').read()
    soup = BeautifulSoup(url, "html.parser")
    
    players = soup.select('a[href^="/basketball/player.htm"]')
    
    cur.execute("""DELETE FROM injuries""")
    conn.commit() 
    
    for player in players:
        if player.find_next("div").get_text() in 'OUT':
            player_name = str(player.get_text())
            print player_name + ' : OUT'
            cur.execute("""INSERT INTO injuries(name, status)
                            SELECT %s, 'Out' WHERE NOT EXISTS (SELECT * FROM injuries WHERE name = %s)""", 
                            (player_name, player_name, )
                            )
            conn.commit() 
        elif player.find_previous("div").find_previous("div").get_text() in ['PG', 'SG', 'SF', 'PF', 'C']:
            player_name = str(player.get_text())
            status = player.find_previous("div").find_previous("div").get_text()
            print player_name + ' : ' + status 
            cur.execute("""INSERT INTO injuries(name, status)
                            SELECT %s, %s WHERE NOT EXISTS (SELECT * FROM injuries WHERE name = %s)""", 
                            (player_name, status, player_name,)
                            )
            conn.commit() 
        elif player.find_next("div").get_text() in 'GTD':
            player_name = str(player.get_text())
            print player_name + ' : GTD'
            cur.execute("""INSERT INTO injuries(name, status)
                            SELECT %s, 'GTD'""",
                            (player_name,)
                            )
            conn.commit() 
    cur.close()
    conn.close()