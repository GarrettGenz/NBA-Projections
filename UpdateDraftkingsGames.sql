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

-- Update players that don't match exactly between draftkings and nba.com
UPDATE draftkings
SET name = 'Luc Mbah a Moute'
WHERE name = 'Luc Richard Mbah a Moute';

UPDATE draftkings
SET name = 'Juan Hernangomez'
WHERE name = 'Guillermo Hernangomez';

UPDATE draftkings
SET name = 'Frank Mason'
WHERE name = 'Frank Mason III';

UPDATE draftkings
SET name = 'Otto Porter Jr.'
WHERE name = 'Otto Porter';