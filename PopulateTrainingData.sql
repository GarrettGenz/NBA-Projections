DELETE FROM training_data;

INSERT INTO training_data(gameid, team, playerid, fgm, fg3m, ftm, oreb, dreb, ast, stl, blk, turnover, is_starter)
SELECT  ps.gameid, ps.team_abbrev, ps.playerid, ps.fgm, ps.fg3m, ps.ftm, ps.oreb, ps.dreb, ps.ast, ps.stl, ps.blk, ps.turnover,
        CASE
            WHEN ((ps.start_pos)::text <> ''::text) THEN 1
            ELSE 0
        END
FROM    playerstats ps
WHERE   gameid IN (SELECT gameid FROM games WHERE game_date > (('now'::text)::date - '11 months'::interval))
AND     ps.comment::text !~~ 'DND%'::text AND ps.comment::text !~~ 'NWT%'::text
AND     gameid < 30000000 -- Don't include playoffs
ORDER BY gameid DESC
LIMIT 	15000;

UPDATE  training_data
SET     home_or_away = ttd.home_or_away,
        opp_team = ttd.opp_team
FROM    team_training_data ttd
WHERE   training_data.gameid = ttd.gameid
AND     training_data.team = ttd.team;

UPDATE  training_data
SET     position = oav.position,
        back_to_back = oav.back_to_back,
        avg_min = oav.avg_min,
        med_fgm = oav.med_fgm,
        med_fga = oav.med_fga,
        med_fg3m = oav.med_fg3m,
        med_fg3a = oav.med_fg3a,
        med_ftm = oav.med_ftm,
        med_fta = oav.med_fta,
        med_oreb = oav.med_oreb,
        med_dreb = oav.med_dreb,
        med_ast = oav.med_ast,
        med_stl = oav.med_stl,
        med_blk = oav.med_blk,
        med_turnover = oav.med_turnover,
        med_pf = oav.med_pf,
        avg_fgm = oav.avg_fgm,
        avg_fga = oav.avg_fga,
        avg_fg3m = oav.avg_fg3m,
        avg_fg3a = oav.avg_fg3a,
        avg_ftm = oav.avg_ftm,
        avg_fta = oav.avg_fta,
        avg_oreb = oav.avg_oreb,
        avg_dreb = oav.avg_dreb,
        avg_ast = oav.avg_ast,
        avg_stl = oav.avg_stl,
        avg_blk = oav.avg_blk,
        avg_turnover = oav.avg_turnover,
        avg_pf = oav.avg_pf,
        usage = oav.usage
FROM    offensive_player_average_stats oav
WHERE   training_data.gameid = oav.gameid
AND     training_data.team = oav.team
AND     training_data.playerid = oav.playerid;

UPDATE  training_data
SET     guard_min_missing = COALESCE(gps.guard_min_missing, 0),
        forward_min_missing = COALESCE(gps.forward_min_missing, 0),
        center_min_missing  = COALESCE(gps.center_min_missing, 0),
        guard_usage_missing = COALESCE(gps.guard_usage_missing, 0),
        forward_usage_missing = COALESCE(gps.forward_usage_missing, 0),
        center_usage_missing = COALESCE(gps.center_usage_missing, 0)
FROM    game_player_status gps
WHERE   training_data.gameid = gps.gameid
AND     training_data.team = gps.team
AND     training_data.position = gps.position;

DELETE FROM training_data
WHERE   EXISTS(SELECT *
               FROM   game_player_status gps
               WHERE  training_data.gameid = gps.gameid
               AND    training_data.playerid = gps.playerid
               AND    training_data.position = gps.position
               AND    gps.is_inactive = true);

DELETE FROM training_data
WHERE   position IS NULL;

DELETE FROM training_data
WHERE	guard_min_missing > 60 OR forward_min_missing > 60 OR center_min_missing > 40;

UPDATE  training_data
SET     off_med_fgm = tav.med_fgm,
        off_med_fga = tav.med_fga,
        off_med_fg3m = tav.med_fg3m,
        off_med_fg3a = tav.med_fg3a,
        off_med_ftm = tav.med_ftm,
        off_med_fta = tav.med_fta,
        off_med_oreb = tav.med_oreb,
        off_med_dreb = tav.med_dreb,
        off_med_ast = tav.med_ast,
        off_med_stl = tav.med_stl,
        off_med_blk = tav.med_blk,
        off_med_turnover = tav.med_turnover,
        off_med_pf = tav.med_pf,
        off_avg_fgm = tav.avg_fgm,
        off_avg_fga = tav.avg_fga,
        off_avg_fg3m = tav.avg_fg3m,
        off_avg_fg3a = tav.avg_fg3a,
        off_avg_ftm = tav.avg_ftm,
        off_avg_fta = tav.avg_fta,
        off_avg_oreb = tav.avg_oreb,
        off_avg_dreb = tav.avg_dreb,
        off_avg_ast = tav.avg_ast,
        off_avg_stl = tav.avg_stl,
        off_avg_blk = tav.avg_blk,
        off_avg_turnover = tav.avg_turnover,
        off_avg_pf = tav.avg_pf
FROM    offensive_team_average_stats tav
WHERE   training_data.gameid = tav.gameid
AND     training_data.team = tav.team;

UPDATE  training_data
SET     def_pos_med_fgm = dpas.med_fgm,
        def_pos_med_fga = dpas.med_fga,
        def_pos_med_fg3m = dpas.med_fg3m,
        def_pos_med_fg3a = dpas.med_fg3a,
        def_pos_med_ftm = dpas.med_ftm,
        def_pos_med_fta = dpas.med_fta,
        def_pos_med_oreb = dpas.med_oreb,
        def_pos_med_dreb = dpas.med_dreb,
        def_pos_med_ast = dpas.med_ast,
        def_pos_med_stl = dpas.med_stl,
        def_pos_med_blk = dpas.med_blk,
        def_pos_med_turnover = dpas.med_turnover,
        def_pos_med_pf = dpas.med_pf,
        def_pos_avg_fgm = dpas.avg_fgm,
        def_pos_avg_fga = dpas.avg_fga,
        def_pos_avg_fg3m = dpas.avg_fg3m,
        def_pos_avg_fg3a = dpas.avg_fg3a,
        def_pos_avg_ftm = dpas.avg_ftm,
        def_pos_avg_fta = dpas.avg_fta,
        def_pos_avg_oreb = dpas.avg_oreb,
        def_pos_avg_dreb = dpas.avg_dreb,
        def_pos_avg_ast = dpas.avg_ast,
        def_pos_avg_stl = dpas.avg_stl,
        def_pos_avg_blk = dpas.avg_blk,
        def_pos_avg_turnover = dpas.avg_turnover,
        def_pos_avg_pf = dpas.avg_pf
FROM    defensive_position_average_stats dpas
WHERE   training_data.gameid = dpas.gameid
AND     training_data.opp_team = dpas.team
AND     training_data.position = dpas.position;

UPDATE  training_data
SET     def_med_fgm = dtas.med_fgm,
        def_med_fga = dtas.med_fga,
        def_med_fg3m = dtas.med_fg3m,
        def_med_fg3a = dtas.med_fg3a,
        def_med_ftm = dtas.med_ftm,
        def_med_fta = dtas.med_fta,
        def_med_oreb = dtas.med_oreb,
        def_med_dreb = dtas.med_dreb,
        def_med_ast = dtas.med_ast,
        def_med_stl = dtas.med_stl,
        def_med_blk = dtas.med_blk,
        def_med_turnover = dtas.med_turnover,
        def_med_pf = dtas.med_pf,
        def_avg_fgm = dtas.avg_fgm,
        def_avg_fga = dtas.avg_fga,
        def_avg_fg3m = dtas.avg_fg3m,
        def_avg_fg3a = dtas.avg_fg3a,
        def_avg_ftm = dtas.avg_ftm,
        def_avg_fta = dtas.avg_fta,
        def_avg_oreb = dtas.avg_oreb,
        def_avg_dreb = dtas.avg_dreb,
        def_avg_ast = dtas.avg_ast,
        def_avg_stl = dtas.avg_stl,
        def_avg_blk = dtas.avg_blk,
        def_avg_turnover = dtas.avg_turnover,
        def_avg_pf = dtas.avg_pf
FROM    defensive_team_average_stats dtas
WHERE   training_data.gameid = dtas.gameid
AND     training_data.opp_team = dtas.team;

UPDATE  training_data
SET     def_ratio_fgm = def_ratio.avg_min / def_ratio.avg_fgm,
        def_ratio_fga = def_ratio.avg_min / def_ratio.avg_fga,
        def_ratio_fg3m = def_ratio.avg_min / def_ratio.avg_fg3m,
        def_ratio_fg3a = def_ratio.avg_min / def_ratio.avg_fg3a,
        def_ratio_ftm = def_ratio.avg_min / def_ratio.avg_ftm,
        def_ratio_fta = def_ratio.avg_min / def_ratio.avg_fta,
        def_ratio_oreb = def_ratio.avg_min / def_ratio.avg_oreb,
        def_ratio_dreb = def_ratio.avg_min / def_ratio.avg_dreb,
        def_ratio_ast = def_ratio.avg_min / def_ratio.avg_ast,
        def_ratio_stl = def_ratio.avg_min / def_ratio.avg_stl,
        def_ratio_blk = def_ratio.avg_min / def_ratio.avg_blk,
        def_ratio_turnover = def_ratio.avg_min / def_ratio.avg_turnover,
        def_ratio_pf = def_ratio.avg_min / def_ratio.avg_pf
FROM    avg_team_def_ratios def_ratio
WHERE   training_data.gameid = def_ratio.gameid
AND     training_data.position = def_ratio.position;