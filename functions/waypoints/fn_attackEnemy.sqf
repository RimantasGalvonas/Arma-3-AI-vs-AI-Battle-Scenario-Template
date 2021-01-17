params ["_group", "_targetPos", ["_additionalWaypointStatements", ""], ["_additionalWaypointCondition", "true"]];



for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};



_waypointRadius = 5;
_groupHasVehicles = false;

{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;

if (_groupHasVehicles == true) then {
    _waypointRadius = 20;
} else {
    _distance = (leader _group) distance _targetPos;

    if (_distance > 250) then {
        // Find a good place to attack from and advance onto the enemy from that position
        _vantagePoint = [getPos (leader _group), _targetPos, (500 min _distance), 250, nil, true] call Rimsiakas_fnc_findOverwatchWithCover;

        [_group, getPos (leader _group), _vantagePoint, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
        [_group, _vantagePoint, _targetPos, _targetPos, false] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    } else {
        // Enemy is nearby so advance onto their position directly
        [_group, getPos (leader _group), _targetPos, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    };
};



// netId is used to get group in the statement rather than by (group this) due to some bug where "this" variable points to a unit from a different group
_netId = _group call BIS_fnc_netId;
_waypointStatements = "
    %1
    _group = '%2' call BIS_fnc_groupFromNetId;
    [_group] call Rimsiakas_fnc_unsetGroupTarget;
    [_group] call Rimsiakas_fnc_searchForEnemies;
";
_waypointStatements = format [_waypointStatements, _additionalWaypointStatements, _netId];



_waypointCondition = "
    _group = '%1' call BIS_fnc_groupFromNetId;

    (!([_group] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently) && {%2});
";
_waypointCondition = format [_waypointCondition, _netId, _additionalWaypointCondition];



_finalWaypoint = _group addWayPoint [_targetPos, _waypointRadius];
_finalWaypoint setWaypointType "SAD";
_finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];