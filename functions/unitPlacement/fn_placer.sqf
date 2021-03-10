params ["_placer"];

_placerPos = getPos _placer;
_minSpawnRadius = _placer getVariable "minSpawnRadius";
_maxSpawnRadius = _placer getVariable "maxSpawnRadius";



// Child placers
{
    if (_x getVariable "logicType" == "placer") then {
        _randomPos = nil;

        if (_x getVariable ["preferRoad", false]) then {
            _road = [_placerPos, _minSpawnRadius, _maxSpawnRadius] call Rimsiakas_fnc_findRoad;
            if (!(isNil "_road")) then {
                _randomPos = getPos _road;
            }
        };

        if (isNil "_randomPos") then {
            _randomPos = [[[_placerPos, _maxSpawnRadius]],[[_placerPos, _minSpawnRadius], "water"]] call BIS_fnc_randomPos;
        };

        _x setPos _randomPos;

        _childSpawnerHandler = [_x] spawn Rimsiakas_fnc_placer; // Must be sent off to another process because otherwise the child placer variables get mixed up with the parent's somehow.
        waitUntil {scriptDone _childSpawnerHandler};
    };
} forEach (_placer getVariable "childPlacers");



// Synchronized units
{
    _syncedUnit = _x;
    _syncedGroup = nil;

    if (count (["Vehicle", "VehicleAutonomous"] arrayIntersect (_syncedUnit call BIS_fnc_objectType)) > 0) then {
        _syncedUnit = (crew _x) select 0;
    };

    if (_syncedUnit isKindOf "man") then {
        _syncedGroup = group _syncedUnit;
    };

    if (!isNil {_syncedGroup}) then {
        [_syncedGroup, _placerPos, _minSpawnRadius, _maxSpawnRadius, 0, 0.6, 0] call Rimsiakas_fnc_teleportSquadToRandomPosition;

        (hcLeader _syncedGroup) hcRemoveGroup _syncedGroup;

        if ("Support" in ([_syncedGroup] call Rimsiakas_fnc_getVehicleClassesInGroup)) then {
            _syncedGroup setVariable ["ignoreIntel", true];
            _waypoint = _syncedGroup addWaypoint [(getPos leader _syncedGroup), 0];
            _waypoint setWaypointType "SUPPORT";
        } else {
            [_syncedGroup] call Rimsiakas_fnc_searchForEnemies;
            [_syncedGroup] call Rimsiakas_fnc_orientGroupTowardsWaypoint;

            if (_placer getVariable ["highCommandSubordinates", false]) then {
                Rimsiakas_highCommandSubordinates append [_syncedGroup];
            };
        };

        _syncedGroup deleteGroupWhenEmpty true;
    };
} foreach synchronizedObjects _placer;



// Units from groups variable
{
    [_placer, _x] call Rimsiakas_fnc_squadSpawner;
    {_x disableAI "all"} forEach allUnits; // Temporarily disabled to avoid firefights breaking out while mission is initializing
} forEach (_placer getVariable "groups");



// Camps
{
    [_x, _placer] call Rimsiakas_fnc_spawnCamp;
    {_x disableAI "all"} forEach allUnits; // Temporarily disabled to avoid firefights breaking out while mission is initializing
} forEach (_placer getVariable "camps");



// Synchronized respawn positions, AI spawn modules and objects
{
    _randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, 10, 0, 0.3, 0, [], [[0,0],[0,0]]] call BIS_fnc_findSafePos;
    if ((_randomPosition select 0) == 0) then {
        // If no clear area can be found, try to find a flattish place
        _randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, 0.1, 0, 0.3, 0, [], [[0,0],[0,0]]] call BIS_fnc_findSafePos;

        if ((_randomPosition select 0) == 0) then {
            // If no flat area can be found, choose a random one
            _blacklistedAreas = ["water"];
            if (_minSpawnRadius > 0) then {
                _blacklistedAreas = [_placerPos, _minSpawnRadius];
            };

            _randomPosition = [[[_placerPos, _maxSpawnRadius]], [_blacklistedAreas]] call BIS_fnc_randomPos;
        };

        // Clear the chosen area
        _terrainObjects = nearestTerrainObjects [_randomPosition, [], 10, false];
        {
            _x hideObjectGlobal true;
        } forEach _terrainObjects;
    };

    _x setPos _randomPosition;

} foreach (synchronizedObjects _placer select {(typeOf _x) find "ModuleRespawnPosition" == 0 || {typeOf _x in ['ModuleSpawnAI_F', "ModuleSpawnAIPoint_F"] || {"Object" in (_x call BIS_fnc_objectType)}}});