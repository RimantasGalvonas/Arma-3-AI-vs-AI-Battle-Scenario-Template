params ["_count", "_side", "_group", "_minRadius", "_maxRadius", ["_groupIcon", ""], ["_groupIconParams", []]];

for "_i" from 1 to _count do {
    _randomPosition = [patrolCenter, _minRadius, _maxRadius, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
    _thisGroup = [_randomPosition, _side, _group] call BIS_fnc_spawnGroup;
    _thisGroup call Rimsiakas_fnc_recursiveSADWaypoint;
    if (_groupIcon != "") then {
        _thisGroup addGroupIcon [_groupIcon];
        _thisGroup setGroupIconParams _groupIconParams;
    }
};