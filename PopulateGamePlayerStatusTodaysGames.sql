DELETE FROM game_player_status WHERE gameid IN (SELECT gameid FROM todays_games);

-- Todays games
-- Add players who are starting or injured
INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive, position) 
SELECT	tg.gameid, tg.team, i.playerid,
	CASE WHEN i.status IN ('PG', 'SG', 'SF', 'PF', 'C') THEN true ELSE false END AS "is_starter",
	CASE WHEN i.status IN ('Out') THEN true ELSE false END AS "is_inactive",
	CASE
      WHEN i.status IN ('PG', 'SG') THEN 'Guard'
			WHEN i.status IN ('SF', 'PF') THEN 'Forward'
			WHEN i.status IN ('C') THEN 'Center'
			WHEN p."position"::text ~~ 'Guard%'::text THEN 'Guard'::text
			WHEN p."position"::text ~~ '%Center%'::text THEN 'Center'::text
			WHEN p."position"::text ~~ 'Forward%'::text THEN 'Forward'::text
    END::character varying(100) AS "position"
FROM	injuries i JOIN todays_games tg ON i.team = tg.team
				   LEFT JOIN players p ON i.playerid = p.playerid;

-- Add all other players currently on the roster
INSERT INTO game_player_status(gameid, team, playerid, is_starter, is_inactive, position)
SELECT	tg.gameid, tg.team, p.playerid, false, false,
			CASE
				WHEN p."position"::text ~~ 'Guard%'::text THEN 'Guard'::text
				WHEN p."position"::text ~~ '%Center%'::text THEN 'Center'::text
WHEN p."position"::text ~~ 'Forward%'::text THEN 'Forward'::text
    END::character varying(100) AS "position"
FROM	players p JOIN todays_games tg ON p.team = tg.team
WHERE	playerid NOT IN (SELECT playerid 
			FROM 	game_player_status gps
			WHERE	gps.gameid = tg.gameid);

-- Set the start multipler for players who have a combination of starting/coming off the bench
CREATE TEMP TABLE start_mult(playerid int, team varchar(100), gameid int, start_multiplier real,
														position VARCHAR(100), new_starter INTEGER, avg_min REAL);

INSERT INTO start_mult
SELECT ps.playerid, ttd.team, ttd.gameid, COALESCE(AVG(CASE WHEN ps.is_starter = true THEN ps.min END) /
                          CASE WHEN (SELECT AVG(CASE WHEN ps.is_starter = false THEN ps.min END)) = 0 THEN NULL
                            ELSE (SELECT AVG(CASE WHEN ps.is_starter = false THEN ps.min END)) END, 1),
			gps.position,
			SUM(CASE WHEN ps.is_starter = gps.is_starter THEN 1 ELSE 0 END),
			AVG(ps.min) -- This value is only used if player is playing first game as starter or on the bench
FROM playerstats ps
     JOIN team_training_data ttd ON (ps.team_abbrev = ttd.team)
     JOIN games prev_games ON (ps.gameid = prev_games.gameid)
     JOIN games cur_game ON (ttd.gameid = cur_game.gameid)
		 JOIN game_player_status gps ON (ttd.gameid = gps.gameid AND ps.playerid = gps.playerid)
  WHERE ps.gameid >= ttd.prev_gameid AND ps.gameid < ttd.gameid AND ps.comment::text !~~ 'DND%'::text AND ps.comment::text !~~ 'NWT%'::text
  AND ttd.gameid IN (SELECT gameid FROM games WHERE game_date > (('now'::text)::date - '1 year'::interval))
   GROUP BY ps.playerid, ttd.team, ttd.gameid, ttd.home_or_away, ttd.prev_gameid, gps.position;

-- Only run this on rows where new_starter = 0, which means this is the first time in the last
-- 6 games that they have become a starter (also works for starter becoming a bench player)
UPDATE  start_mult
SET     start_multiplier = mins.avg / start_mult.avg_min
FROM    avg_start_mins_per_position mins
WHERE   start_mult.gameid = mins.gameid
AND     start_mult.team = mins.team
AND     start_mult.position = mins.position
AND     start_mult.new_starter = 0;

UPDATE game_player_status SET start_multiplier = start_mult.start_multiplier
FROM start_mult
WHERE game_player_status.playerid = start_mult.playerid
AND game_player_status.team = start_mult.team
AND game_player_status.gameid = start_mult.gameid
AND game_player_status.is_starter = true;

UPDATE game_player_status SET start_multiplier = 1 / start_mult.start_multiplier
FROM start_mult
WHERE game_player_status.playerid = start_mult.playerid
AND game_player_status.team = start_mult.team
AND game_player_status.gameid = start_mult.gameid
AND game_player_status.is_starter = false;

UPDATE game_player_status
SET start_multiplier = 1 WHERE start_multiplier IS NULL;

DROP TABLE start_mult;


