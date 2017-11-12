-- Set flag is_starter
UPDATE	playerstats
SET	is_starter = true
WHERE	start_pos <> '';

UPDATE	playerstats
SET	is_starter = false
WHERE	start_pos = '';

-- Set position
UPDATE	playerstats
SET	position = 
	CASE
		WHEN p."position"::text ~~ 'Guard%'::text THEN 'Guard'::text
		WHEN p."position"::text ~~ 'Center%'::text THEN 'Center'::text
		WHEN p."position"::text ~~ 'Forward%'::text THEN 'Forward'::text
        END
FROM	players p
WHERE	p.playerid = playerstats.playerid
AND	playerstats.position IS NULL;

UPDATE	playerstats
SET	position =
	CASE
		WHEN start_pos = 'C' THEN 'Center'
		WHEN start_pos = 'F' THEN 'Forward'
		WHEN start_pos = 'G' THEN 'Guard'
		WHEN (fg3a::double precision / (reb::double precision + 0.001::double precision)) < 0.1::double precision THEN 'Center'::text
                WHEN (fg3a::double precision / (reb::double precision + 0.001::double precision)) >= 0.1::double precision AND reb > 5 THEN 'Forward'::text
                ELSE 'Guard'::text
	END
WHERE	position IS NULL;

UPDATE	playerstats
SET	pos_id =
	CASE 
		WHEN position = 'Guard' THEN 1
		WHEN position = 'Forward' THEN 2
		WHEN position = 'Center' THEN 3
    END
WHERE	pos_id IS NULL;
