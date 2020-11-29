params ["_group", "_minimumDistance", "_maximumDistance", "_distanceFromOtherObjects", "_maxGradient", "_waterMode", "_shoreMode"];

_groupLeader = leader _group;
_randomPosition = [_groupLeader, _minimumDistance, _maximumDistance, _distanceFromOtherObjects, _waterMode, _maxGradient, _shoreMode] call BIS_fnc_findSafePos;

{
    if (_x != _groupLeader) then {
        _relDis = _x distance _groupLeader;
        _relDir = [_groupLeader, _x] call BIS_fnc_relativeDirTo;
        _x setPos ([_randomPosition, _relDis, _relDir] call BIS_fnc_relPos);
    };
} forEach units _group;
_groupLeader setPos _randomPosition;