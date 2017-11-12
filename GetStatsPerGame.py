# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
import psycopg2
import time
import requests
import random
import json
import config

def main():
    try:
        conn = conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user,
                                       password=config.password)
    except:
        print "I am unable to connect to the database"
        
    cur = conn.cursor()
    
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36',
                'Host': 'stats.nba.com',
                'Connection': 'keep-alive',
                'Cache-Control': 'max-age=0',
                'Upgrade-Insecure-Requests': '1',
                'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
                'Accept-Encoding': 'gzip, deflate',
                'Accept-Language': 'en-US,en;q=0.8'}
    
    # Get list of games that have finished, but have no stats
    cur.execute("""SELECT	gameid
                    FROM	games
                    WHERE	game_date < current_timestamp - interval '12 hours' /* Get to PST */ - interval '6 hours' /* Get games that started at least 6 hours ago */
                    AND	gameid NOT IN (SELECT gameid FROM playerstats)""")
                    
    games = cur.fetchall()
    
    print games
    
    for game in games:
        gameid = game[0]
        
        print gameid

        url = 'http://stats.nba.com/stats/boxscoretraditionalv2?EndPeriod=10&EndRange=28800&GameID=00' + str(gameid) + '&RangeType=0&Season=2017-18&SeasonType=Regular+Season&StartPeriod=1&StartRange=0'
        
        # Make a request for each game
        # Use Selenium because requests was timing out sometimes
        driver = webdriver.Firefox()
        driver.get(url)
        source = json.loads(str(driver.find_element_by_id('json').text))
        driver.quit()
    
        playerstats = source['resultSets'][0]['rowSet']
        
        for playerstat in playerstats:
            
            if playerstat[8] is None:
                minutes = 0
            else:
                minutes_raw = playerstat[8].split(":")
                
                minutes = float(minutes_raw[0]) + (float(minutes_raw[1]) / 60)

            cur.execute("""INSERT INTO playerstats(gameid, teamid, team_abbrev, team_city, playerid, player_name, start_pos,
                            comment, min, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, stl, blk,
                            turnover, pf, pts, plus_minus)
                            SELECT %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                            WHERE NOT EXISTS (SELECT * FROM playerstats WHERE '00' || gameid = %s  AND playerid = %s)""", 
                            (playerstat[0], playerstat[1], playerstat[2], playerstat[3], playerstat[4], playerstat[5], playerstat[6],
                             playerstat[7], minutes, playerstat[9], playerstat[10], playerstat[11], playerstat[12], playerstat[13],
                             playerstat[14], playerstat[15], playerstat[16], playerstat[17], playerstat[18], playerstat[19], playerstat[20],
                             playerstat[21], playerstat[22], playerstat[23], playerstat[24], playerstat[25], playerstat[26], playerstat[27],
                             playerstat[0], playerstat[4]))
            conn.commit()

            # Delay next call so we don't get blocked
            time.sleep(random.uniform(1, 3))
    
    cur.close()
    conn.close()