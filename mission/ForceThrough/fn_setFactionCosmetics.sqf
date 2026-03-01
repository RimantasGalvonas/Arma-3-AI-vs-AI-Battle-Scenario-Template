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

private _spawner1Side = [getNumber (_factionFriendly1 >> "side")] call BIS_fnc_sideType;
private _spawner2Side = [getNumber (_factionFriendly2 >> "side")] call BIS_fnc_sideType;
private _enemySide = [getNumber ((selectRandom [_factionEnemy1, _factionEnemy2]) >> "side")] call BIS_fnc_sideType;

private _spawner1Color = [_spawner1Side, true] call BIS_fnc_sideColor;
private _spawner2Color = [_spawner2Side, true] call BIS_fnc_sideColor;
private _enemyColor = [_enemySide, true] call BIS_fnc_sideColor;

"supplies_marker_1" setMarkerColor _spawner1Color;
"supplies_marker_2" setMarkerColor _spawner2Color;
"team1_start_marker" setMarkerColor (selectRandom [_spawner1Color, _spawner2Color]);
"team2_start_marker" setMarkerColor _enemyColor;