DELETE FROM game_player_status WHERE gameid IN (SELECT gameid FROM todays_games);

-- Past games
-- Add rows for each player in playerstats
INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive, position)
SELECT ps.gameid, ps.team_abbrev, ps.playerid,
		CASE WHEN start_pos <> '' THEN true ELSE false END AS "is_starter",
		CASE WHEN comment LIKE 'DND%' OR comment LIKE 'NWT%' THEN true ELSE false END AS "is_inactive",
		CASE
            WHEN p."position"::text ~~ 'Guard%'::text THEN 'Guard'::text
                    WHEN p."position"::text ~~ 'Center%'::text THEN 'Center'::text
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
-- Dont populate position because it doesn't matter since we will never train on this data
INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive)
SELECT ttd.gameid, ttd.team, ps.playerid, false, true
FROM    playerstats ps
JOIN team_training_data ttd
    ON (ps.team_abbrev = ttd.team AND ps.gameid < ttd.gameid AND ps.gameid >= ttd.prev_gameid)
WHERE	ps.playerid NOT IN ( SELECT playerid
				FROM    playerstats
				WHERE   gameid = ttd.gameid
				AND team_abbrev = ttd.team )
AND NOT EXISTS (SELECT * FROM game_player_status gps WHERE gps.gameid = ttd.gameid AND gps.playerid = ps.playerid)
AND ttd.gameid > (SELECT MAX(gameid) FROM game_player_status WHERE gameid < 40000000)
AND ttd.gameid < (SELECT MIN(gameid) FROM todays_games)
-- This line is because running this for all previous games takes way too long
GROUP BY ttd.gameid, ttd.team, ps.playerid;
