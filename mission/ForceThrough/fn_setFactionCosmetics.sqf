private _factionFriendly1 = spawner_01_friendly call ForceThrough_fnc_getRandomSpawnerFactionConfig;
private _factionFriendly2 = spawner_02_friendly call ForceThrough_fnc_getRandomSpawnerFactionConfig;
private _factionEnemy1 = spawner_03_enemy call ForceThrough_fnc_getRandomSpawnerFactionConfig;
private _factionEnemy2 = spawner_04_enemy call ForceThrough_fnc_getRandomSpawnerFactionConfig;

{
    private _factionConfig = _x select 0;
    private _flag = _x select 1;

    if (_factionConfig != configNull) then {
        private _flagTexture = getText (_factionConfig >> "flag");

        _flag setFlagTexture _flagTexture;
    };
} forEach [[_factionFriendly1, supplies_flag_1], [_factionFriendly2, supplies_flag_2]];

private _playerSide = [getNumber ((selectRandom [_factionFriendly1, _factionFriendly2]) >> "side")] call BIS_fnc_sideType;
private _enemySide = [getNumber ((selectRandom [_factionEnemy1, _factionEnemy2]) >> "side")] call BIS_fnc_sideType;

private _playerColor = [_playerSide, true] call BIS_fnc_sideColor;
private _enemyColor = [_enemySide, true] call BIS_fnc_sideColor;

"supplies_marker_1" setMarkerColor _playerColor;
"supplies_marker_2" setMarkerColor _playerColor;
"team1_start_marker" setMarkerColor _playerColor;
"team2_start_marker" setMarkerColor _enemyColor;