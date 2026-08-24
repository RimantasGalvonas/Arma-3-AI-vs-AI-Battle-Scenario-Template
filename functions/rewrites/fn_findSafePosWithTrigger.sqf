params ["_placer", ["_objectProximity", 0], ["_waterMode", 0], ["_maxGradient", 0], ["_shoreMode", 0], ["_posBlacklist", []], ["_defaultPos", []]];

private _areaTriggers = _placer getVariable ["areaTriggers", []];

if (count _areaTriggers == 0) exitWith {
    [getPos _placer, _placer getVariable "minSpawnRadius", _placer getVariable "maxSpawnRadius", _objectProximity, _waterMode, _maxGradient, _shoreMode, _posBlacklist, _defaultPos] call BIS_fnc_findSafePos;
};


// Code below is stolen from BIS_fnc_findSafePos

private _checkProximity = _objectProximity > 0;
private _checkBlacklist = !(_posBlacklist isEqualTo []);
private _gradientRadius = 1 max _objectProximity * 0.1;
_shoreMode = _shoreMode != 0;
private _pos = getPos _placer;


for "_i" from 1 to 4000 do
{
    private _checkPos = [_areaTriggers, ["water"]] call BIS_fnc_randomPos;

    if (count _checkPos == 2) then {
        continue;
    };

    // position is roughly suitable
    if ((_checkPos isFlatEmpty [-1, -1, _maxGradient, _gradientRadius, _waterMode, _shoreMode]) isEqualTo []) then {
        continue;
    };

    // away from other objects
    if (_checkProximity && {!(nearestTerrainObjects [_checkPos, [], _objectProximity, false, true] isEqualTo [])}) then {
        continue;
    };

    // not inside something
    if !(lineIntersectsSurfaces [AGLtoASL _checkPos, AGLtoASL _checkPos vectorAdd [0, 0, 50], objNull, objNull, false, 1, "GEOM", "NONE"] isEqualTo []) then {
        continue;
    };

    // not in blacklist
    if (_checkBlacklist && {{if (_checkPos inArea _x) exitWith {true}; false} forEach _posBlacklist}) then {
        continue;
    };

    _pos = _checkPos;

    break;
};


_pos;