params ["_group", "_target", ["_targetPriority", 1], ["_additionalWaypointStatements", ""], ["_additionalWaypointCondition", "true"]];

private ["_netId", "_groupHasVehicles", "_waypointCondition", "_waypointStatements", "_finalWaypoint"];


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
    private ["_vantagePoint", "_targetPos", "_distance", "_maxFlankingDistance", "_minFlankingDistance", "_vantagePointWPCondition", "_vantagePointWP"];
    _targetPos = getPos _target;

    _distance = (leader _group) distance _targetPos;

    _maxFlankingDistance = 500;
    _minFlankingDistance = 250;

    if ([_targetPos] call Rimsiakas_fnc_isPositionInForest || {[_targetPos] call Rimsiakas_fnc_isPositionAmongBuildings}) then {
        _maxFlankingDistance = 300;
        _minFlankingDistance = 100;
    };

    if (_distance > _minFlankingDistance) then {
        // Find a good place to attack from and advance onto the enemy from that position
        _vantagePoint = [getPos (leader _group), _targetPos, (_maxFlankingDistance min _distance), _minFlankingDistance, nil, true] call Rimsiakas_fnc_findOverwatchWithCover;
        _vantagePoint = _vantagePoint select 0;

        [_group, getPos (leader _group), _vantagePoint, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;


        _vantagePointWPCondition = "
            [group this] call Rimsiakas_fnc_temporaryCombatMode;
            ([group this, 15] call Rimsiakas_fnc_waypointPreConditionTimeout) && {!([group this] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently)};
        ";
        _vantagePointWP = _group addWayPoint [_vantagePoint, 1];
        _vantagePointWP setWaypointType "MOVE";
        _vantagePointWP setWaypointStatements [_vantagePointWPCondition, ""];


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
    _finalWaypoint setWaypointFormation (patrolCenter getVariable ["aiConfigAttackFormation", "WEDGE"]);
};