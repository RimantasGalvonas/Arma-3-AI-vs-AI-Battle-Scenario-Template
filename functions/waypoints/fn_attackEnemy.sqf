params ["_group", "_target", ["_targetPriority", 1], ["_additionalWaypointStatements", ""], ["_additionalWaypointCondition", "true"]];



_group setVariable ["lastReportedTargetPosition", getPos _target];
_group setVariable ["respondingToIntelPriority", _targetPriority];
_group setVariable ["currentTargetGroup", group _target];
_group setVariable ["currentTarget", _target];



for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};



// netId is used to get group in conditions and statemens rather than by (group this) due to some bug where "this" variable points to a unit from a different group
_netId = _group call BIS_fnc_netId;



_groupHasVehicles = false;

{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;



if (_groupHasVehicles == true) then {
    _waypointCondition = _additionalWaypointCondition;

    _waypointStatements = "
        %1
        _group = '%2' call BIS_fnc_groupFromNetId;
        _target = _group getVariable ['currentTarget', nil];
        if (!isNil '_target' && {!alive _target}) then {
            [_group] call Rimsiakas_fnc_searchForEnemies;
        };
    ";
    _waypointStatements = format [_waypointStatements, _additionalWaypointStatements, _netId];



    _finalWaypoint = _group addWayPoint [getPos (vehicle _target), -1];
    _finalWaypoint waypointAttachVehicle (vehicle _target);
    _finalWaypoint setWaypointType "DESTROY";
    _finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];
} else {
    private ["_vantagePoint"];
    _targetPos = getPos _target;

    _distance = (leader _group) distance _targetPos;

    if (_distance > 250) then {
        // Find a good place to attack from and advance onto the enemy from that position
        _vantagePoint = [getPos (leader _group), _targetPos, (500 min _distance), 250, nil, true] call Rimsiakas_fnc_findOverwatchWithCover;
        _vantagePoint = _vantagePoint select 0;

        [_group, getPos (leader _group), _vantagePoint, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
        [_group, _vantagePoint, _targetPos, _targetPos, false] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    } else {
        // Enemy is nearby so advance onto their position directly
        [_group, getPos (leader _group), _targetPos, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    };



    _waypointStatements = "
        %1
        _group = '%2' call BIS_fnc_groupFromNetId;
        [_group] call Rimsiakas_fnc_searchForEnemies;
    ";
    _waypointStatements = format [_waypointStatements, _additionalWaypointStatements, _netId];

    _waypointCondition = "
        _group = '%1' call BIS_fnc_groupFromNetId;

        (!([_group] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently) && {%2});
    ";
    _waypointCondition = format [_waypointCondition, _netId, _additionalWaypointCondition];



    _finalWaypoint = _group addWayPoint [getPos _target, 5];
    _finalWaypoint setWaypointType "SAD";
    _finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];
};