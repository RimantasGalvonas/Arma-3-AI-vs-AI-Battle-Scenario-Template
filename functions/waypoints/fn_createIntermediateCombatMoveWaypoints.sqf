params ["_group", "_startingPos", "_destination", "_enemyPos", ["_checkStartingPos", true]];

_waypointStepDistance = 100;

_distance = _startingPos distance2D _destination;

if (_distance > 2000) then {
    _waypointStepDistance = _distance / 10;
};

_maxEngagementDistance = 500; // TODO: calculate according to squad weaponry

_waypointCondition = "true";

_lastPos = _startingPos;

_intermediatePositions = [];

while {_distance > (_waypointStepDistance * 1.5)} do {
    _dir = _lastPos getDir _destination;

    _intermediatePosition = _lastPos getPos [_waypointStepDistance, _dir];

    _preferablePosition = nil;



    // Create the first waypoint at the current position so after receiving intel it checks if the current position is good to attack the target from.
    if (_checkStartingPos && {_lastPos isEqualTo _startingPos}) then {
        _intermediatePosition = _startingPos getPos [3, _dir];
        _preferablePosition = _intermediatePosition;
    };



    // If within engagement distance, try to find a position from which the target is visible, preferably with cover
    if ((_intermediatePosition distance _enemyPos) < _maxEngagementDistance) then {
        _vantagePoint = [_intermediatePosition, _destination, _waypointStepDistance / 2] call Rimsiakas_fnc_findOverwatchWithCover;

        if (_intermediatePosition distance2D _vantagePoint > 0) then {
            _preferablePosition = _vantagePoint;

            // This is an advantageous position so stay there until the target is dealt with or can't be seen anymore
            // Do the check every 15 seconds to give time for the group to notice the enemy upon arriving to the waypoint
            _waypointCondition = "([group this, 15] call Rimsiakas_fnc_waypointPreConditionTimeout) && {!([group this] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently)}";
        };
    };



    // Couldn't find a higher position, so look for an area with cover
    if (isNil "_preferablePosition") then {
        _preferablePosition = selectBestPlaces[_intermediatePosition, (_waypointStepDistance / 2), "houses + trees + hills - (100 * waterDepth)", 5, 1];
        _preferablePosition = (_preferablePosition select 0) select 0;
    };



    // Skip creating the waypoint at this step if the most suitable position was on water
    if (surfaceIsWater _preferablePosition == false) then {
        _preferablePosition = [_preferablePosition, 0, 10, 1, 0, -1, 0, [], [_preferablePosition, _preferablePosition]] call BIS_fnc_findSafePos; // To avoid placing waypoints inside houses. Makes the units get stuck

        _intermediateWaypoint = _group addWayPoint [_preferablePosition, 5];
        _intermediateWaypoint setWaypointType "MOVE";
        _intermediateWaypoint setWaypointStatements [_waypointCondition, ""];
    };

    _distance = _preferablePosition distance2D _destination;

    _lastPos = _preferablePosition;
};