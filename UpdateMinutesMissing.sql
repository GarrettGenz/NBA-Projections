UPDATE	game_player_status
SET	pos_min_missing = min_inj
FROM	pos_minutes_missing pmm
WHERE	game_player_status.gameid = pmm.gameid
AND	game_player_status.team = pmm.team
AND	game_player_status.position = pmm.position;

UPDATE	game_player_status
SET	tot_min_missing = min_inj
FROM	tot_minutes_missing tmm
WHERE	game_player_status.gameid = tmm.gameid
AND	game_player_status.team = tmm.team;