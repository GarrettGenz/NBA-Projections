DELETE FROM offensive_team_average_stats;

INSERT INTO offensive_team_average_stats
SELECT ttd.gameid,
      ttd.home_or_away,
  ttd.team,
  median(ops.fgm) AS med_fgm,
  median(ops.fga) AS med_fga,
  median(ops.fg3m) AS med_fg3m,
  median(ops.fg3a) AS med_fg3a,
  median(ops.ftm) AS med_ftm,
  median(ops.fta) AS med_fta,
  median(ops.oreb) AS med_oreb,
  median(ops.dreb) AS med_dreb,
  median(ops.ast) AS med_ast,
  median(ops.stl) AS med_stl,
  median(ops.blk) AS med_blk,
  median(ops.turnover) AS med_turnover,
  median(ops.pf) AS med_pf,
  avg(ops.fgm) AS avg_fgm,
  avg(ops.fga) AS avg_fga,
  avg(ops.fg3m) AS avg_fg3m,
  avg(ops.fg3a) AS avg_fg3a,
  avg(ops.ftm) AS avg_ftm,
  avg(ops.fta) AS avg_fta,
  avg(ops.oreb) AS avg_oreb,
  avg(ops.dreb) AS avg_dreb,
  avg(ops.ast) AS avg_ast,
  avg(ops.stl) AS avg_stl,
  avg(ops.blk) AS avg_blk,
  avg(ops.turnover) AS avg_turnover,
  avg(ops.pf) AS avg_pf,
  ttd.prev_gameid
   FROM ((team_training_data ttd
     JOIN team_training_data past_games ON (((ttd.team = past_games.team) AND (past_games.gameid >= ttd.prev_gameid)
                                             AND (past_games.gameid < ttd.gameid))))
     JOIN offensive_team_stats ops ON (((ops.team_abbrev = past_games.team) AND (ops.gameid = past_games.gameid))))
  WHERE ((ttd.prev_gameid <= ops.gameid) AND (ttd.gameid > ops.gameid))
  GROUP BY ttd.gameid, ttd.home_or_away, ttd.team, ttd.prev_gameid;