UPDATE 	playerprojections
SET	team_abbrev = team,
	player_name = firstname || ' ' || lastname,
	pts = fg3m * 3 + (fgm - fg3m) * 2 + ftm,
	reb = oreb + dreb
FROM	players
WHERE	playerprojections.player_name IS NULL
AND	playerprojections.playerid = players.playerid;

UPDATE	playerprojections
SET	game_date = g.game_date
FROM	games g
WHERE	playerprojections.gameid = g.gameid
AND	playerprojections.game_date IS NULL;

UPDATE 	playerprojections
SET proj_pts = playerprojections.pts + playerprojections.fg3m * 0.5::double precision + playerprojections.reb * 1.25::double precision + playerprojections.ast * 1.5::double precision + 
				playerprojections.stl * 2::double precision + playerprojections.blk * 2::double precision + playerprojections.turnover * '-0.5'::numeric::double precision
WHERE proj_pts IS NULL;
