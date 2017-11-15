import psycopg2
import codecs

import GetPlayers
import GetGames
import GetStatsPerGame
import GetInjuries
import GetPlayerProjections

import config

def beg_of_week_updates():
    conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    cur = conn.cursor()

    # print ('Get Players...')
    # GetPlayers.main()
    #
    # print ('Get Games...')
    # GetGames.main()

    print ('Get Player Stats...')
    GetStatsPerGame.main()

    conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    cur = conn.cursor()
	
    print ('Updating player stats...')
    cur.execute(codecs.open("UpdatePlayerStats.sql", "r", encoding='us-ascii').read())
    conn.commit()
    
    print ('Populate table team_training_data...')
    cur.execute(codecs.open("PopulateTeamTrainingData.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table Offensive_Team_Average_Stats...')
    cur.execute(codecs.open("PopulateOffensiveTeamAverageStats.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table defensive_position_average_stats...')
    cur.execute(codecs.open("PopulateDefensivePositionAverageStats.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table defensive_team_average_stats...')
    cur.execute(codecs.open("PopulateDefensiveTeamAverageStats.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table game_player_status with data from past games...')
    cur.execute(codecs.open("PopulateGamePlayerStatusPastGames.sql", "r", encoding='us-ascii').read())
    conn.commit()
	
    print ('Populate table avg_team_def_ratios_new with data from past games...')
    cur.execute(codecs.open("PopulateAvgTeamDefRatioData.sql", "r", encoding='us-ascii').read())
    conn.commit()
    
    cur.close()
    conn.close()


def daily_updates():
    conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    cur = conn.cursor()

    print ('Get Starters/Injuries...')
    GetInjuries.main()

    print ('Update injuries for the current day...')
    cur.execute(codecs.open("UpdateInjuryData.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table game_player_status with projected data for today...')
    cur.execute(codecs.open("PopulateGamePlayerStatusTodaysGames.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate table Offensive_Player_Average_Stats...')
    cur.execute(codecs.open("PopulateOffensivePlayerAverageStats.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Update table game_player_status with minutes missing to injuries...')
    cur.execute(codecs.open("UpdateMinutesMissing.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Populate the table that holds all training data...')
    cur.execute(codecs.open("PopulateTrainingData.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Get Player Projections...')
    GetPlayerProjections.main()

    conn = psycopg2.connect(host=config.endpoint, database=config.database, user=config.user, password=config.password)
    cur = conn.cursor()

    print ('Update player_projections table with projected points...')
    cur.execute(codecs.open("UpdatePlayerProjections.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Update Draftkings table with game date...')
    cur.execute(codecs.open("UpdateDraftkingsGames.sql", "r", encoding='us-ascii').read())
    conn.commit()

    print ('Get optimal combinations for Draftkings...')
    cur.execute(codecs.open("GetDraftkingsCombos.sql", "r", encoding='us-ascii').read())
    conn.commit()

    cur.close()
    conn.close()

beg_of_week_updates()

daily_updates()

