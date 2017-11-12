DELETE FROM playertrainingdata;

INSERT INTO playertrainingdata(gameid, playerid, position, home_or_away, opp_team, starting)
SELECT	playerstats.gameid, 
	playerstats.playerid, 
	players.position,
	CASE WHEN playerstats.team_abbrev = games.home_team THEN 1 ELSE -1 END,
	CASE WHEN playerstats.team_abbrev = games.home_team THEN games.away_team ELSE games.home_team END,
	CASE WHEN playerstats.start_pos <> '' THEN 1 ELSE 0 END
FROM	playerstats JOIN games ON playerstats.gameid = games.gameid
		    JOIN players ON playerstats.playerid = players.playerid;

-- Insert data for games that happen today
INSERT INTO playertrainingdata(gameid, playerid, position, home_or_away, opp_team, starting)
SELECT	g.gameid, 
	p.playerid, 
	p.position,
	CASE WHEN p.team = g.home_team THEN 1 ELSE -1 END,
	CASE WHEN p.team = g.home_team THEN g.away_team ELSE g.home_team END,
	CASE WHEN COALESCE((SELECT status FROM injuries WHERE date(injuries.game_date) = date(g.game_date) AND p.playerid = injuries.playerid), '') NOT IN ('Out', 'GTD') THEN 1 ELSE 0 END
FROM	games g JOIN players p ON (g.home_team = p.team OR g.away_team = p.team)
WHERE	NOT EXISTS (SELECT * FROM playertrainingdata ptd WHERE ptd.gameid = g.gameid AND ptd.playerid = p.playerid)
AND	DATE(g.game_date) = CURRENT_DATE;

UPDATE	playertrainingdata ptd
SET	prevgameid =	
(	SELECT MIN (gameid)
	FROM
		(SELECT ps2.gameid AS "gameid"
		FROM	playerstats ps2
		WHERE	ps2.playerid = ptd.playerid
		AND 	ps2.gameid < ptd.gameid	
		ORDER BY ps2.gameid DESC LIMIT (SELECT config.value FROM config WHERE config.name = 'num_prev_games')) temp);
		