DELETE FROM team_training_data;

-- Insert home teams
INSERT INTO team_training_data(gameid, team, home_or_away, opp_team)
SELECT 	gameid, home_team, 1, away_team 
FROM 	games
WHERE 	gameid IN (SELECT gameid FROM playerstats);

-- Insert away teams
INSERT INTO team_training_data(gameid, team, home_or_away, opp_team)
SELECT 	gameid, away_team, 0, home_team 
FROM 	games
WHERE 	gameid IN (SELECT gameid FROM playerstats);

/* Insert data for games that happen today */

-- Insert home teams
INSERT INTO team_training_data(gameid, team, home_or_away, opp_team)
SELECT 	gameid, home_team, 1, away_team 
FROM 	games
WHERE 	gameid IN (SELECT gameid FROM todays_games);

-- Insert away teams
INSERT INTO team_training_data(gameid, team, home_or_away, opp_team)
SELECT 	gameid, away_team, 0, home_team 
FROM 	games
WHERE 	gameid IN (SELECT gameid FROM todays_games);

UPDATE	team_training_data ttd
SET	prev_gameid =	
(	SELECT MIN (gameid)
	FROM
		(SELECT ttd2.gameid AS "gameid"
		FROM	team_training_data ttd2
		WHERE	ttd2.team = ttd.team
		AND 	ttd2.gameid < ttd.gameid	
		ORDER BY ttd2.gameid DESC LIMIT (SELECT config.value FROM config WHERE config.name = 'num_prev_games')) temp);