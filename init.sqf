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
    /* Teleport player group */
    [group player, getPos friendlySpawner, friendlySpawner getVariable "minSpawnRadius", friendlySpawner getVariable "maxSpawnRadius", 0, 0.6, 0] call Rimsiakas_fnc_placeSquadInRandomPosition;
    [group player] call Rimsiakas_fnc_recursiveSADWaypoint;

    /* Enable team switch */
    {
        addSwitchableUnit _x;
    } foreach units group player;

    /* Spawn enemy squads */
    {
        [enemySpawner, _x] call Rimsiakas_fnc_squadSpawner;
    } foreach (enemySpawner getVariable "groups");

    _isHighCommand = (count (hcAllGroups player) > 0);

    /* Spawn friendly squads */
    {
        [friendlySpawner, _x, _isHighCommand] call Rimsiakas_fnc_squadSpawner;
    } foreach (friendlySpawner getVariable "groups");

    [] execVM "createGrid.sqf";
};