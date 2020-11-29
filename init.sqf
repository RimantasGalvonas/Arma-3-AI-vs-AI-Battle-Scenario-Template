setGroupIconsVisible [true, false];
_validationResult = ([] call Rimsiakas_fnc_validator);

if ((count _validationResult) > 0) then {
    {
        waitUntil {isNull findDisplay 72 && isNull findDisplay 57};
        (_x select 0) hintC (_x select 1);  // TODO: doesn't always work. Find out why.
    } foreach _validationResult;
} else {
    _patrolRadius = patrolCenter getVariable "patrolRadius";
    _friendlySpawnMinRadius = patrolCenter getVariable "friendlySpawnMinRadius";
    _friendlySpawnMaxRadius = patrolCenter getVariable "friendlySpawnMaxRadius";
    _friendlyGroupIcon = "b_inf";
    _friendlyGroupIconParams = [(configfile >> "CfgMarkerColors" >> "colorWEST" >> "color") call BIS_fnc_colorConfigToRGBA, "", 1, true];
    _enemySpawnMinRadius = patrolCenter getVariable "enemySpawnMinRadius";
    _enemySpawnMaxRadius = patrolCenter getVariable "enemySpawnMaxRadius";

    /* Spawn enemy squads */
    {
        _side = (getNumber (_x >> "side")) call BIS_fnc_sideType;
        [1, _side, _x, _enemySpawnMinRadius, _enemySpawnMaxRadius] call Rimsiakas_fnc_squadSpawner;
    } foreach (enemySpawner getVariable "groups");

    /* Spawn friendly squads */
    {
        _side = (getNumber (_x >> "side")) call BIS_fnc_sideType;
        [1, _side, _x, _friendlySpawnMinRadius, _friendlySpawnMaxRadius, _friendlyGroupIcon, _friendlyGroupIconParams] call Rimsiakas_fnc_squadSpawner;
    } foreach (friendlySpawner getVariable "groups");

    /* Teleport player group */
    [group player, _friendlySpawnMinRadius, _friendlySpawnMaxRadius, 0, 0, 0.6, 0] call Rimsiakas_fnc_placeSquadInRandomPosition;
    [group player] call Rimsiakas_fnc_recursiveSADWaypoint;

    [] execVM "createGrid.sqf";
};