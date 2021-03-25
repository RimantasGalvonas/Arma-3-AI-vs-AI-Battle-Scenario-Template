params ["_position", ["_maxDistanceFromCenterToCheck", 2000]];

if (!surfaceIsWater _position) exitWith {
    _position;
};

private _distanceFromCenterToCheck = 60;

while {_distanceFromCenterToCheck < _maxDistanceFromCenterToCheck} do {
    private _whitelist = [[_position, _distanceFromCenterToCheck]];
    private _blacklist = ["water", [_position, _distanceFromCenterToCheck - 50]];

    private _newPosition = [_whitelist, _blacklist] call BIS_fnc_randomPos;

    if ((_newPosition select 0) != 0) exitWith {
        _position = _newPosition;
    };

    _distanceFromCenterToCheck = _distanceFromCenterToCheck + 50;
};

_position;