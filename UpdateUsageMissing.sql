UPDATE	game_player_status
SET	guard_usage_missing = usage_inj
FROM	pos_usage_missing pmm
WHERE	game_player_status.gameid = pmm.gameid
AND	game_player_status.team = pmm.team
AND	pmm.position = 'Guard';

UPDATE	game_player_status
SET	forward_usage_missing = usage_inj
FROM	pos_usage_missing pmm
WHERE	game_player_status.gameid = pmm.gameid
AND	game_player_status.team = pmm.team
AND	pmm.position = 'Forward';

UPDATE	game_player_status
SET	center_usage_missing = usage_inj
FROM	pos_usage_missing pmm
WHERE	game_player_status.gameid = pmm.gameid
AND	game_player_status.team = pmm.team
AND	pmm.position = 'Center';