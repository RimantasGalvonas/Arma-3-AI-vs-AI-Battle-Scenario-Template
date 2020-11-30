setGroupIconsVisible [true, false];
Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);

if ((count Rimsiakas_missionValidationResult) > 0) then {
        [] spawn {
            sleep 0.1; // Small delay required to make sure hintC happens after the mission is initialized. Couldn't find any proper event handler for that.
            waitUntil {!isNull player};
            {
                waitUntil {isNull findDisplay 72 && isNull findDisplay 57};
                (_x select 0) hintC (_x select 1);
            } foreach Rimsiakas_missionValidationResult;
        };
} else {
    _patrolRadius = patrolCenter getVariable "patrolRadius";
    _friendlySpawnMinRadius = patrolCenter getVariable "friendlySpawnMinRadius";
    _friendlySpawnMaxRadius = patrolCenter getVariable "friendlySpawnMaxRadius";
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
        [1, _side, _x, _friendlySpawnMinRadius, _friendlySpawnMaxRadius] call Rimsiakas_fnc_squadSpawner;
    } foreach (friendlySpawner getVariable "groups");

    /* Teleport player group */
    [group player, _friendlySpawnMinRadius, _friendlySpawnMaxRadius, 0, 0, 0.6, 0] call Rimsiakas_fnc_placeSquadInRandomPosition;
    [group player] call Rimsiakas_fnc_recursiveSADWaypoint;

    [] execVM "createGrid.sqf";
};