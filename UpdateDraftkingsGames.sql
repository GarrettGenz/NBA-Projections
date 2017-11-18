UPDATE draftkings SET game_date = CURRENT_DATE
WHERE game_date IS NULL;

-- Update teams that dont' match exactly between draftkings and nba.com
UPDATE	draftkings
SET	team = 'NYK'
WHERE	team = 'NY';

UPDATE	draftkings
SET	team = 'SAS'
WHERE	team = 'SA';

UPDATE	draftkings
SET	team = 'PHX'
WHERE	team = 'PHO';

UPDATE	draftkings
SET	team = 'GSW'
WHERE	team = 'GS';

UPDATE	draftkings
SET	team = 'NOP'
WHERE	team = 'NO';