-- Update exact matches. Remove all periods.
UPDATE	injuries
SET	playerid = players.playerid,
	team = players.team
FROM	players
WHERE	REPLACE(players.firstname, '.', '')  || ' ' || REPLACE(players.lastname, '.', '') = REPLACE(injuries.name, '.', '')
AND	injuries.playerid IS NULL;

-- Update matches where last name and first initial match
UPDATE	injuries
SET	playerid = players.playerid,
	team = players.team
FROM	players
WHERE	REPLACE(LEFT(firstname, 1) || ' ' || lastname , '.', '') = REPLACE(injuries.name, '.', '')
AND	injuries.playerid IS NULL;

-- Individual updates for players whose names don't match
UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Tim Hardaway'
AND	players.playerid = 203501
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Dennis Smith'
AND	players.playerid = 1628372
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'James Ennis'
AND	players.playerid = 203516
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Wade Baldwin'
AND	players.playerid = 1627735
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Glenn Robinson'
AND	players.playerid = 203922
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Otto Porter'
AND	players.playerid = 203490
AND	injuries.playerid IS NULL;

UPDATE	injuries
SET	playerid = players.playerid ,
	team = players.team
FROM	players
WHERE	injuries.name = 'Larry Nance'
AND	players.playerid = 1626204
AND	injuries.playerid IS NULL;

-- If a starter is a GTD, remove the starter rows
DELETE FROM injuries
WHERE status IN ('PG', 'SG', 'SF', 'PF', 'C')
AND playerid IN (SELECT playerid FROM injuries WHERE status = 'GTD' );