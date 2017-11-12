# -*- coding: utf-8 -*-
from selenium import webdriver  
from selenium.common.exceptions import NoSuchElementException  
from selenium.webdriver.common.keys import Keys
import psycopg2
import config
from bs4 import BeautifulSoup
import urllib2
import json
from datetime import date
import random
import time
import requests

def main():
    try:
        conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    except:
        print "I am unable to connect to the database"
        
    cur = conn.cursor()
    
    # Delete current players so if someone gets cut from a team it is reflected
    cur.execute("""DELETE FROM players""")
    
    hdrs = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36'}
    
    player_hdrs = {'Host': 'stats.nba.com',
            'Connection': 'keep-alive',
            'Cache-Control': 'max-age=0',
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
            'Upgrade-Insecure-Requests': '1',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'en-US,en;q=0.8'
            }
    
    print "Grabbing list of players..."
    # Use Selenium because we need all JavaScript to be rendered first
    driver = webdriver.Firefox()
    driver.get('http://www.nba.com/players')
    html_source = driver.page_source
    driver.quit()
    
    soup = BeautifulSoup(html_source, "html.parser")
    
    # Get each player
    for row in soup.find_all("a", href=True):
        if row['href'].startswith("/players/") and row['href'] != "/players/":
            first_name = config.find_between(row['href'], "/players/", "/")
            last_name = config.find_between(row['href'], "/players/" + first_name + "/", "/")
            playerid = config.find_between(row['href'], "/players/" + first_name + "/" + last_name + "/")
            
            if last_name == "": # If no last name exists, the playerid will need to get retrieved without checking for the ending backslash
                playerid = config.find_between(row['href'], "/players/" + first_name + "/")
    
            # Make a request for each individual player    
            print "Getting more information about " + first_name + " " + last_name + ", " + playerid
              
            params = {
            'playerid': playerid,   
            }
            
            response = requests.get('http://stats.nba.com/stats/commonplayerinfo', params=params, headers=player_hdrs)
    
            player_row = response.json()['resultSets'][0]['rowSet'][0]
            
            first_name = player_row[1]
            last_name = player_row[2]
            position = player_row[14]
            status = player_row[15]
            team = player_row[18]
            
            print "Inserting " + team + ": " + first_name + " " + last_name + ", " + playerid
                      
            cur.execute("""INSERT INTO players(playerid, firstname, lastname, position, status, team)
                            SELECT %s, %s, %s, %s, %s, %s WHERE NOT EXISTS (SELECT * FROM players WHERE playerid = %s)""", 
                            (playerid, first_name, last_name, position, status, team, playerid))
            conn.commit()
            
            # Delay next call so we don't get blocked
            time.sleep(random.uniform(1, 3))
    
    cur.close()
    conn.close()