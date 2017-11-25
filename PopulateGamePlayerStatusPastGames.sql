DELETE FROM game_player_status WHERE gameid IN (SELECT gameid FROM games where game_date > now() - '3 days'::INTERVAL);

-- Past games
-- Add rows for each player in playerstats
INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive, position)
SELECT ps.gameid, ps.team_abbrev, ps.playerid,
		CASE WHEN start_pos <> '' THEN true ELSE false END AS "is_starter",
		CASE WHEN comment LIKE 'DND%' OR comment LIKE 'NWT%' OR comment LIKE 'DNP - Injury%' THEN true ELSE false END AS "is_inactive",
		CASE
				  WHEN ps.start_pos = 'C' THEN 'Center'
					WHEN ps.start_pos = 'F' THEN 'Forward'
					WHEN ps.start_pos = 'G' THEN 'Guard'
					WHEN p."position"::text ~~ 'Guard%'::text THEN 'Guard'::text
					WHEN p."position"::text ~~ '%Center%'::text THEN 'Center'::text
					WHEN p."position"::text ~~ 'Forward%'::text THEN 'Forward'::text
					WHEN (ps.fg3a::double precision / (ps.reb::double precision + 0.001::double precision)) < 0.1::double precision THEN 'Center'::text
					WHEN (ps.fg3a::double precision / (ps.reb::double precision + 0.001::double precision)) >= 0.1::double precision AND ps.reb > 5 THEN 'Forward'::text
					ELSE 'Guard'::text
        END::character varying(100) AS "position"
FROM    playerstats ps LEFT JOIN players p ON ps.playerid = p.playerid
WHERE   ps.playerid NOT IN ( SELECT playerid
				FROM    game_player_status
				WHERE   gameid = ps.gameid
				AND 	team = ps.team_abbrev )
-- This line is because running this for all previous games takes way too long
AND ps.gameid > (SELECT MAX(gameid) FROM game_player_status WHERE gameid < 40000000)
AND ps.gameid < (SELECT MIN(gameid) FROM todays_games);

-- Add players who recently played games prior to each game, but didnt play in the target game
-- This can be due to IR/trades/inactive player
CREATE TEMP TABLE players_in_recent_games(gameid INTEGER, playerid INTEGER, team varchar(10), position varchar(10));

INSERT INTO players_in_recent_games(gameid, playerid, team)
SELECT ttd.gameid, ps.playerid, ttd.team
FROM    playerstats ps
JOIN team_training_data ttd
    ON (ps.team_abbrev = ttd.team AND ps.gameid < ttd.gameid AND ps.gameid >= ttd.prev_gameid)
WHERE ttd.gameid > (SELECT MAX(gameid) FROM game_player_status WHERE gameid < 40000000)
AND		ttd.gameid < (SELECT MIN(gameid) FROM todays_games)
GROUP BY ttd.gameid, ttd.team, ps.playerid;

UPDATE	players_in_recent_games pirg
SET			position = (	SELECT position
											FROM playerstats ps
											WHERE pirg.playerid = ps.playerid AND pirg.gameid = ps.gameid AND pirg.team = ps.team_abbrev
											AND		ps.gameid < pirg.gameid
											LIMIT 1);

-- Don't include players that played in the game
DELETE FROM players_in_recent_games
WHERE EXISTS (SELECT *
							FROM playerstats ps
							WHERE players_in_recent_games.gameid = ps.gameid
							AND 	players_in_recent_games.playerid = ps.playerid
							AND 	players_in_recent_games.team = ps.team_abbrev);

-- Don't include players that already have a row in game_player_status
DELETE FROM players_in_recent_games
WHERE EXISTS (SELECT *
							FROM game_player_status gps
							WHERE players_in_recent_games.gameid = gps.gameid
							AND 	players_in_recent_games.playerid = gps.playerid
							AND 	players_in_recent_games.team = gps.team);

INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive, position)
SELECT 	gameid, team, playerid, false, true, position
FROM    players_in_recent_games;

DROP TABLE players_in_recent_games;
