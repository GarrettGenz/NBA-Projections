/* PG */
CREATE TEMP TABLE dfs_pg(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_pg(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PG%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PG%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PG%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3);

/* SG */
CREATE TEMP TABLE dfs_sg(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_sg(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SG%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SG%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SG%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3);

/* SF */
CREATE TEMP TABLE dfs_sf(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_sf(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SF%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SF%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%SF%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3);

/* PF */
CREATE TEMP TABLE dfs_pf(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_pf(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PF%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PF%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%PF%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3);

/* C */
CREATE TEMP TABLE dfs_c(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_c(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%C%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%C%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%C%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 3);

/* G */
CREATE TEMP TABLE dfs_g(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_g(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%G%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%G%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%G%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5);

/* F */
CREATE TEMP TABLE dfs_f(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_f(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%F%'
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%F%'
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	draftkings.position LIKE '%F%'
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5);

/* Util */
CREATE TEMP TABLE dfs_util(playerid INT, salary INT, dfs_score NUMERIC);

INSERT INTO dfs_util(playerid, salary, dfs_score)
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	salary < 4500
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	salary >= 4500
AND	salary < 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5)
UNION ALL
(SELECT	playerprojections.playerid, draftkings.salary, proj_pts
FROM	draftkings JOIN playerprojections ON (REPLACE(draftkings.name, '.', '') = REPLACE(player_name, '.', '') AND upper(draftkings.team) = team_abbrev AND draftkings.game_date = playerprojections.game_date)
WHERE	proj_pts <> 0
AND	salary >= 7000
AND	playerprojections.game_date = CURRENT_DATE AND NOT EXISTS (SELECT * FROM injuries WHERE playerprojections.playerid = injuries.playerid AND status IN ('Out', 'GTD'))
ORDER BY salary / proj_pts ASC
LIMIT 5);

CREATE TEMP TABLE combos(pg INT, sg INT, sf INT, pf INT, c INT, g INT, f INT, util INT);

INSERT INTO combos(pg, sg, sf, pf, c, g, f, util)
SELECT dfs_pg.playerid AS "PG", dfs_sg.playerid AS "SG", dfs_sf.playerid AS "SF", dfs_pf.playerid AS "PF", dfs_c.playerid AS "C", dfs_g.playerid AS "G", dfs_f.playerid AS "F", dfs_util.playerid AS "Util"
FROM 		dfs_pg 	
		join dfs_sg ON 1 = 1
		join dfs_sf ON 1 = 1
		join dfs_pf ON 1 = 1
		join dfs_c ON 1 = 1
		join dfs_g ON 1 = 1
		join dfs_f ON 1 = 1
		join dfs_util ON 1 = 1
WHERE		dfs_pg.salary + dfs_sg.salary + dfs_sf.salary + dfs_pf.salary + dfs_c.salary + dfs_g.salary + dfs_f.salary + dfs_util.salary <= 50000
AND		dfs_pg.playerid NOT IN (dfs_sg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_sg.playerid NOT IN (dfs_pg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_sf.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_pf.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_sf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_c.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_g.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_g.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_f.playerid, dfs_util.playerid)
AND		dfs_f.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_util.playerid)
AND		dfs_util.playerid NOT IN (dfs_pg.playerid, dfs_sg.playerid, dfs_sf.playerid, dfs_pf.playerid, dfs_c.playerid, dfs_g.playerid, dfs_f.playerid)
ORDER BY 	dfs_pg.dfs_score + dfs_sg.dfs_score + dfs_sf.dfs_score + dfs_pf.dfs_score + dfs_c.dfs_score + dfs_g.dfs_score + dfs_f.dfs_score + dfs_util.dfs_score DESC
LIMIT 1;

DELETE FROM draftkings_combos
WHERE   game_date = CURRENT_DATE;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'PG', pg
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'SG', sg
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'SF', sf

FROM  combos;
INSERT INTO draftkings_combos(position, playerid)
SELECT 'PF', pf
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'C',C
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'G', g
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'F', f
FROM  combos;

INSERT INTO draftkings_combos(position, playerid)
SELECT 'UTIL', util
FROM  combos;

DROP TABLE dfs_pg;
DROP TABLE dfs_sg;
DROP TABLE dfs_sf;
DROP TABLE dfs_pf;
DROP TABLE dfs_c;
DROP TABLE dfs_g;
DROP TABLE dfs_f;
DROP TABLE dfs_util;
DROP TABLE combos;

-- Set date
UPDATE  draftkings_combos
SET     game_date = CURRENT_DATE
WHERE   game_date IS NULL;

SELECT * FROM draftkings_combos dc JOIN players p ON dc.playerid = p.playerid AND dc.game_date = CURRENT_DATE;