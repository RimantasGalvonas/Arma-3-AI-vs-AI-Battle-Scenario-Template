params ["_group", "_startingPos", "_destination", "_enemyPos", ["_checkStartingPos", true]];

private ["_waypointStepDistance", "_distance", "_maxEngagementDistance", "_lastPos", "_intermediatePositions"];

_waypointStepDistance = 100;

_distance = _startingPos distance2D _destination;

if (_distance > 2000) then {
    _waypointStepDistance = _distance / 10;
};

_maxEngagementDistance = 500; // TODO: calculate according to squad weaponry

_lastPos = _startingPos;

_intermediatePositions = [];

while {_distance > (_waypointStepDistance * 1.5)} do {
    private ["_preferablePosition", "_intermediatePosition", "_dir", "_waypointCondition", "_vantagePointData", "_vantagePoint", "_intermediateWaypoint", "_backupPreferablePosition"];

    _preferablePosition = nil;
    _intermediatePosition = nil;
    _dir = _lastPos getDir _destination;
    _waypointCondition = "true";


    if (_checkStartingPos && {_lastPos isEqualTo _startingPos}) then {
        // Create the first waypoint at the current position so after receiving intel it checks if the current position is good to attack the target from.
        _intermediatePosition = _startingPos getPos [3, _dir];
        _preferablePosition = _intermediatePosition;
    } else {
        _intermediatePosition = _lastPos getPos [_waypointStepDistance, _dir];
    };



    // If within engagement distance, try to find a position from which the target is visible, preferably with cover
    if ((_intermediatePosition distance _enemyPos) < _maxEngagementDistance) then {
        _vantagePointData = [_intermediatePosition, _destination, _waypointStepDistance / 1.5] call Rimsiakas_fnc_findOverwatchWithCover;
        _vantagePoint = _vantagePointData select 0;

        if (_intermediatePosition distance2D _vantagePoint > 0) then {
            _preferablePosition = _vantagePoint;

            if ((count (_vantagePointData select 1)) > ((count units _group) * 0.75)) then {
                // This is an advantageous position so stay there until the target is dealt with or can't be seen anymore
                // Do the check every 15 seconds to give time for the group to notice the enemy upon arriving to the waypoint
                _waypointCondition = "([group this, 15] call Rimsiakas_fnc_waypointPreConditionTimeout) && {!([group this] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently)}";
            };
        };
    };



    // Couldn't find a higher position, so look for an area with cover
    if (isNil "_preferablePosition") then {
        _preferablePosition = selectBestPlaces[_intermediatePosition, (_waypointStepDistance / 2), "houses + trees + hills - (100 * waterDepth)", 5, 1];
        _preferablePosition = (_preferablePosition select 0) select 0;
    };



    // Skip creating the waypoint at this step if the most suitable position was on water
    if (surfaceIsWater _preferablePosition == false) then {
        _backupPreferablePosition = _preferablePosition;
        _preferablePosition = _preferablePosition findEmptyPosition [2, (_waypointStepDistance / 3), typeOf (leader _group)]; // To avoid placing waypoints inside houses. Makes the units get stuck
        if ((count _preferablePosition) == 0) then {
            _preferablePosition = _backupPreferablePosition;
        };

        _intermediateWaypoint = _group addWayPoint [_preferablePosition, 1];
        _intermediateWaypoint setWaypointType "MOVE";
        _intermediateWaypoint setWaypointStatements [_waypointCondition, ""];
    };

    _distance = _preferablePosition distance2D _destination;

    _lastPos = _preferablePosition;
};