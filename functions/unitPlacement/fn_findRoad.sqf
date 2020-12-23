params ["_centerPos", "_minimumDistance", "_maximumDistance"];

_road = nil;

_maxRoadFindTryAttempts = 10;
_roadFindAttemptsCount = 0;

_vehicleSpawnRadius = (_maximumDistance - _minimumDistance) / 2;
_whitelistedSearchAreas = [[_centerPos, _minimumDistance + _vehicleSpawnRadius]];
_blackListedSearchAreas = [[_centerPos, _minimumDistance]];

while {isNil "_road" && _roadFindAttemptsCount < _maxRoadFindTryAttempts} do {
    _randomPositionForRoadSearch = [_whitelistedSearchAreas, _blackListedSearchAreas] call BIS_fnc_randomPos;
    _blackListedSearchAreas append [[_randomPositionForRoadSearch, _vehicleSpawnRadius]];

    _nearRoads = _randomPositionForRoadSearch nearRoads (_vehicleSpawnRadius);
    {
        if (((getRoadInfo _x) select 2) == false) exitWith {_road = _x};
    } foreach _nearRoads;

    _roadFindAttemptsCount = _roadFindAttemptsCount + 1;
};

if (isNil "_road") then {
    nil; // I don't know, it's stupid but I can't just return _road when it's nil. An error is thrown that the variable is undefined.
} else {
    _road;
};