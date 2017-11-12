# -*- coding: utf-8 -*-
import psycopg2
import config
from bs4 import BeautifulSoup
import urllib2
import json
from datetime import date
import random
import time

def main():
    try:
        conn = conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    except:
        print "I am unable to connect to the database"
        
    cur = conn.cursor()
    
    # Define year range
    season_year = config.start_year
    current_year = date.today().year
    
    hdrs = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36'}

    while season_year <= current_year:
        print "Grabbing games for year " + str(season_year)
        req = urllib2.Request('http://data.nba.net/data/json/cms/' + str(season_year) + '/league/nba_games.json', headers=hdrs)
        url = urllib2.urlopen(req).read()
        soup = BeautifulSoup(url, "html.parser")
        
        games = json.loads(str(soup))['sports_content']['schedule']['game']
        
        for index in range(len(games)):
            if str(games[index]['id']).startswith('002'):
                gameid = games[index]['id']
                game_date = games[index]['dt']
                home_team = games[index]['h_abrv']
                away_team = games[index]['v_abrv']
        
                cur.execute("""INSERT INTO games(gameid, game_date, home_team, away_team)
                                SELECT %s, %s, %s, %s WHERE NOT EXISTS (SELECT * FROM games WHERE gameid = %s)""", 
                                (gameid, game_date, home_team, away_team, gameid))
                conn.commit()           
                
        # Delay next call so we don't get blocked
        time.sleep(random.uniform(1, 3))
        
        season_year += 1
        
    cur.close()
    conn.close()