params ["_count", "_side", "_group", "_minRadius", "_maxRadius", ["_isHighCommand", false]];

for "_i" from 1 to _count do {
    _randomPosition = [patrolCenter, _minRadius, _maxRadius, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
    _thisGroup = [_randomPosition, _side, _group] call BIS_fnc_spawnGroup;
    if (!_isHighCommand) then {
        _thisGroup call Rimsiakas_fnc_recursiveSADWaypoint;
    } else {
        player hcSetGroup [_thisGroup];
    };
};