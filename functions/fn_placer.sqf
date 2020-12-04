params ["_placer"];

_placerPos = getPos _placer;
_minSpawnRadius = _placer getVariable "minSpawnRadius";
_maxSpawnRadius = _placer getVariable "maxSpawnRadius";

// Child spawners
{
    if (_x getVariable "logicType" == "placer") then {
        _randomPos = [[[_placerPos, _maxSpawnRadius]],[[_placerPos, _minSpawnRadius], "water"]] call BIS_fnc_randomPos;
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

    if (_syncedUnit isKindOf "landVehicle") then {
        _syncedUnit = (crew _x) select 0;
    };
    if (_syncedUnit isKindOf "man") then {
        _syncedGroup = group _syncedUnit;
    };

    if (!isNil {_syncedGroup}) then {
        [_syncedGroup, _placerPos, _minSpawnRadius, _maxSpawnRadius, 0, 0.6, 0] call Rimsiakas_fnc_teleportSquadToRandomPosition;
        if (_placer getVariable ["highCommandSubordinates", false] == false) then {
            player hcRemoveGroup _syncedGroup;
            _syncedGroup call Rimsiakas_fnc_recursiveSADWaypoint;
        };
    };
} foreach synchronizedObjects _placer;


// Units from groups variable
{
    [_placer, _x, isPlayerHighCommander] call Rimsiakas_fnc_squadSpawner;
} forEach (_placer getVariable "groups");