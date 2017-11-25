DELETE FROM offensive_player_average_stats WHERE gameid IN (SELECT gameid FROM todays_games);

-- Temp table to store modified stats based on strength of defense and if player was a starter
CREATE TEMP TABLE modified_playerstats(playerid integer, position varchar(7), is_starter BOOLEAN, gameid integer,
          team varchar(100), min real,
					usage_fga integer, usage_fta integer, usage_turnover integer, fgm real, fga real,
					fg3m real, fg3a real, ftm real, fta real, oreb real, dreb real, ast real, stl real, blk real, turnover real,
					pf real);

INSERT INTO modified_playerstats(playerid, position, is_starter, gameid, team, min, usage_fga, usage_fta,
																 usage_turnover, fgm, fga, fg3m, fg3a, ftm, fta, oreb, dreb, ast, stl, blk, turnover, pf)
SELECT	ps.playerid, ps.position, ps.is_starter, ps.gameid, ps.team_abbrev,
	ps.min,
	ps.fga,
	ps.fta,
	ps.turnover,
	COALESCE(ps.fgm, 0)::double precision * (tdr.avg_min / tdr.avg_fgm)::numeric,
	COALESCE(ps.fga, 0)::double precision * (tdr.avg_min / tdr.avg_fga)::numeric,
	COALESCE(ps.fg3m, 0)::double precision * (tdr.avg_min / tdr.avg_fg3m)::numeric,
	COALESCE(ps.fg3a, 0)::double precision * (tdr.avg_min / tdr.avg_fg3a)::numeric,
	COALESCE(ps.ftm, 0)::double precision * (tdr.avg_min / tdr.avg_ftm)::numeric,
	COALESCE(ps.fta, 0)::double precision * (tdr.avg_min / tdr.avg_fta)::numeric,
	COALESCE(ps.oreb, 0)::double precision * (tdr.avg_min / tdr.avg_oreb)::numeric,
	COALESCE(ps.dreb, 0)::double precision * (tdr.avg_min / tdr.avg_dreb)::numeric,
	COALESCE(ps.ast, 0)::double precision * (tdr.avg_min / tdr.avg_ast)::numeric,
	COALESCE(ps.stl, 0)::double precision * (tdr.avg_min / tdr.avg_stl)::numeric,
	COALESCE(ps.blk, 0)::double precision * (tdr.avg_min / tdr.avg_blk)::numeric,
	COALESCE(ps.turnover, 0)::double precision * (tdr.avg_min / tdr.avg_turnover)::numeric,
	COALESCE(ps.pf, 0)::double precision * (tdr.avg_min / tdr.avg_pf)::numeric
FROM	playerstats ps JOIN team_training_data ttd ON ps.gameid = ttd.gameid AND ps.team_abbrev = ttd.team
		       JOIN avg_team_def_ratios tdr ON (tdr.gameid = ttd.gameid AND tdr.team = ttd.opp_team AND ps.pos_id = tdr.pos_id)
WHERE	ps.gameid IN (SELECT gameid FROM games WHERE game_date > (('now'::text)::date - '1 month'::interval))
AND 	ps.comment::text !~~ 'DND%'::text AND ps.comment::text !~~ 'NWT%'::text;

INSERT INTO offensive_player_average_stats(playerid, position, gameid, team, home_or_away, back_to_back, prev_gameid, avg_min,
		med_fgm, med_fga, med_fg3m, med_fg3a, med_ftm, med_fta, med_oreb, med_dreb, med_ast, med_stl,
		med_blk, med_turnover, med_pf, avg_fgm, avg_fga, avg_fg3m, avg_fg3a, avg_ftm, avg_fta, avg_oreb,
		avg_dreb, avg_ast, avg_stl, avg_blk, avg_turnover, avg_pf, usage)
SELECT	ps.playerid, ps.position, ttd.gameid, ttd.team, ttd.home_or_away, 0, ttd.prev_gameid,
	SUM(ps.min) / (SELECT value from config WHERE name = 'num_prev_games'),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fgm * gps.start_multiplier
	            ELSE ps.fgm
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fga * gps.start_multiplier
	            ELSE ps.fga
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fg3m * gps.start_multiplier
	            ELSE ps.fg3m
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fg3a * gps.start_multiplier
	            ELSE ps.fg3a
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.ftm * gps.start_multiplier
	            ELSE ps.ftm
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fta * gps.start_multiplier
	            ELSE ps.fta
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.oreb * gps.start_multiplier
	            ELSE ps.oreb
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.dreb * gps.start_multiplier
	            ELSE ps.dreb
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.ast * gps.start_multiplier
	            ELSE ps.ast
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.stl * gps.start_multiplier
	            ELSE ps.stl
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.blk * gps.start_multiplier
	            ELSE ps.blk
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.turnover * gps.start_multiplier
	            ELSE ps.turnover
	        END),
	median(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.pf * gps.start_multiplier
	            ELSE ps.pf
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fgm * gps.start_multiplier
	            ELSE ps.fgm
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fga * gps.start_multiplier
	            ELSE ps.fga
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fg3m * gps.start_multiplier
	            ELSE ps.fg3m
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fg3a * gps.start_multiplier
	            ELSE ps.fg3a
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.ftm * gps.start_multiplier
	            ELSE ps.ftm
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.fta * gps.start_multiplier
	            ELSE ps.fta
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.oreb * gps.start_multiplier
	            ELSE ps.oreb
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.dreb * gps.start_multiplier
	            ELSE ps.dreb
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.ast * gps.start_multiplier
	            ELSE ps.ast
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.stl * gps.start_multiplier
	            ELSE ps.stl
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.blk * gps.start_multiplier
	            ELSE ps.blk
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.turnover * gps.start_multiplier
	            ELSE ps.turnover
	        END),
	avg(CASE WHEN ps.is_starter <> gps.is_starter THEN ps.pf * gps.start_multiplier
	            ELSE ps.pf
	        END),
	-- Calculate usage
	(100) * (240/ (5 * COALESCE(avg(min), 0) + .001)) *
		(avg(usage_fga) + (.44 * avg(usage_fta)) + avg(usage_turnover)) /
	(COALESCE((avg(ots.avg_fga) + (.44 * avg(ots.avg_fta)) + avg(ots.avg_turnover)), 0) +.001)
FROM	modified_playerstats ps JOIN team_training_data ttd
															JOIN offensive_team_average_stats ots ON ttd.gameid = ots.gameid AND ttd.team = ots.team
		ON ps.gameid >= ttd.prev_gameid AND ps.gameid < ttd.gameid AND ps.team = ttd.team
                              JOIN game_player_status gps ON ttd.gameid = gps.gameid  AND ps.playerid = gps.playerid
WHERE	ttd.gameid IN (SELECT gameid FROM games WHERE game_date > (('now'::text)::date - '1 year'::interval))
AND	NOT EXISTS (SELECT * FROM offensive_player_average_stats opas WHERE opas.playerid = ps.playerid AND opas.gameid = ttd.gameid)
GROUP BY ps.playerid, ps.position, ttd.gameid, ttd.team, ttd.home_or_away, ttd.prev_gameid;

UPDATE offensive_player_average_stats SET usage = 0 WHERE usage IS NULL;

DROP TABLE modified_playerstats;