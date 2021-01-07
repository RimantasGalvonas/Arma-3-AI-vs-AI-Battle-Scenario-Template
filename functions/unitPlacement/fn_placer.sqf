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
    };
} forEach (_placer getVariable "childPlacers"); // No idea why, but it only works properly if the positions are set in a separate loop from the placement.
{
    if (_x getVariable "logicType" == "placer") then {
        [_x] call Rimsiakas_fnc_placer;
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
            [_syncedGroup] call Rimsiakas_fnc_recursiveSADWaypoint;
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

{
    [_x, _placer] call Rimsiakas_fnc_spawnCamp;
    {_x disableAI "all"} forEach allUnits; // Temporarily disabled to avoid firefights breaking out while mission is initializing
} forEach (_placer getVariable "camps");
