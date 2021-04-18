params ["_group", "_startingPos", "_destination", "_enemyPos", ["_checkStartingPos", true]];

private ["_waypointStepDistance", "_distance", "_lastPos", "_intermediatePositions"];

_waypointStepDistance = 100;

_distance = _startingPos distance2D _destination;

if (_distance > 2000) then {
    _waypointStepDistance = _distance / 10;
};

_lastPos = _startingPos;

_intermediatePositions = [];

while {_distance > (_waypointStepDistance * 1.5)} do {
    private ["_preferablePosition", "_intermediatePosition", "_dir", "_waypointCondition", "_maxEngagementDistance", "_vantagePointData", "_vantagePoint", "_intermediateWaypoint", "_backupPreferablePosition"];

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

    _maxEngagementDistance = 500; // TODO: calculate according to squad weaponry
    if (
        [_enemyPos] call Rimsiakas_fnc_isPositionInForest || {
        [_intermediatePosition, _waypointStepDistance / 1.5] call Rimsiakas_fnc_isPositionInForest || {
        [_enemyPos] call Rimsiakas_fnc_isPositionAmongBuildings || {
        [_intermediatePosition] call Rimsiakas_fnc_isPositionAmongBuildings
    }}}) then {
        _maxEngagementDistance = 200;
    };

    private _withinEngangementDistance = (_intermediatePosition distance _enemyPos) < _maxEngagementDistance;

    // If within engagement distance, try to find a position from which the target is visible, preferably with cover
    if (_withinEngangementDistance) then {
        _vantagePointData = [_intermediatePosition, _destination, _waypointStepDistance / 1.5] call Rimsiakas_fnc_findOverwatchWithCover;
        _vantagePoint = _vantagePointData select 0;

        if (_intermediatePosition distance2D _vantagePoint > 0) then {
            _preferablePosition = _vantagePoint;

            if ((count (_vantagePointData select 1)) > ((count units _group) * 0.75)) then {
                // This is an advantageous position so stay there until the target is dealt with or can't be seen anymore
                // Do the check every 15 seconds to give time for the group to notice the enemy upon arriving to the waypoint
                _waypointCondition = "
                    [group this] call Rimsiakas_fnc_temporaryCombatMode;
                    ([group this, 15] call Rimsiakas_fnc_waypointPreConditionTimeout) && {!([group this] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently)};
                ";
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

        // Reset the chosen attack position to the next waypoint position if the original attack position has been passed already. This is used in making groups spread out.
        _waypointStatement = "
            private _group = group this;
            private _selectedAttackPosition = _group getVariable ['attackingFromPos', nil];
            if (isNil '_selectedAttackPosition') exitWith {};
            private _lastKnownTargetPos = _group getVariable 'lastReportedTargetPosition';
            if ((_lastKnownTargetPos distance2D this) < (_lastKnownTargetPos distance2D _selectedAttackPosition) || {(_selectedAttackPosition distance2D this) < 50}) then {
                private _waypointPos = waypointPosition [_group, (currentWaypoint _group) + 1];
                if ((_waypointPos select 0) == 0) then {
                    _waypointPos = waypointPosition [_group, currentWaypoint _group];
                };
                _group setVariable ['attackingFromPos', _waypointPos];
            };
        ";

        _intermediateWaypoint = _group addWayPoint [_preferablePosition, 1];
        _intermediateWaypoint setWaypointType "MOVE";
        _intermediateWaypoint setWaypointStatements [_waypointCondition, "_waypointStatement"];

        if (_withinEngangementDistance && {!isPlayer leader _group}) then {
            _intermediateWaypoint setWaypointFormation (patrolCenter getVariable ["aiConfigAttackFormation", "WEDGE"]);
        };
    };

    _distance = _preferablePosition distance2D _destination;

    _lastPos = _preferablePosition;
};