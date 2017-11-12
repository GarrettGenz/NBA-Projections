DELETE FROM avg_team_def_ratios_new;

INSERT INTO avg_team_def_ratios_new(gameid, team, position, def_avg_min, def_ratio_fgm, def_ratio_fga,
			def_ratio_fg3m, def_ratio_fg3a, def_ratio_ftm, def_ratio_fta, def_ratio_oreb,
			def_ratio_dreb, def_ratio_ast, def_ratio_stl, def_ratio_blk, def_ratio_turnover,
			def_ratio_pf)
SELECT	gameid, team, position,
	avg_min,
	avg_min / avg_fgm AS def_ratio_fgm,
	avg_min / avg_fga AS def_ratio_fga,
	avg_min / avg_fg3m AS def_ratio_fg3m,
	avg_min / avg_fg3a AS def_ratio_fg3a,
	avg_min / avg_ftm AS def_ratio_ftm,
	avg_min / avg_fta AS def_ratio_fta,
	avg_min / avg_oreb AS def_ratio_oreb,
	avg_min / avg_dreb AS def_ratio_dreb,
	avg_min / avg_ast AS def_ratio_ast,
	avg_min / avg_stl AS def_ratio_stl,
	avg_min / avg_blk AS def_ratio_blk,
	avg_min / avg_turnover AS def_ratio_turnover,
	avg_min / avg_pf AS def_ratio_pf
FROM	avg_team_def_ratios;
