params ["_group", "_target", ["_targetPriority", 1], ["_additionalWaypointStatements", ""], ["_additionalWaypointCondition", "true"]];



private _previousTargetGroup = _group getVariable ["currentTargetGroup", false];

_group setVariable ["lastReportedTargetPosition", getPos _target];
_group setVariable ["respondingToIntelPriority", _targetPriority];
_group setVariable ["currentTargetGroup", group _target];
_group setVariable ["currentTarget", _target];

[_group, _previousTargetGroup, group _target] call Rimsiakas_fnc_afterTargetChange;



for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};



private _groupHasVehicles = false;

{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;



if (_groupHasVehicles == true) then {
    private _waypointCondition = _additionalWaypointCondition;

    private _waypointStatements = "
        %1
        private _group = group this;
        private _target = _group getVariable ['currentTarget', nil];
        if (!isNil '_target' && {!alive _target}) then {
            [_group] call Rimsiakas_fnc_searchForEnemies;
        };
    ";
    _waypointStatements = format [_waypointStatements, _additionalWaypointStatements];



    private _finalWaypoint = _group addWayPoint [getPos (vehicle _target), -1];
    _finalWaypoint waypointAttachVehicle (vehicle _target);
    _finalWaypoint setWaypointType "DESTROY";
    _finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];
} else {
    private _targetPos = getPos _target;

    private _distance = (leader _group) distance _targetPos;



    ([_targetPos] call Rimsiakas_fnc_getMinMaxFlankingDistance) params ["_minFlankingDistance", "_maxFlankingDistance"];



    if (_distance > _minFlankingDistance) then {
        private _attackPosWeighingParams = selectRandom [[_group, 250, 0.6], [_group, 300, 0.35]];
        private _occupiedVantagePoints = _attackPosWeighingParams call Rimsiakas_fnc_collectWeightedAttackingFromPos;


        // Find a good place to attack from and advance onto the enemy from that position
        private "_attackPosition";

        private _attackPositionData = [getPos (leader _group), _targetPos, (_maxFlankingDistance min _distance), _minFlankingDistance, nil, true, true, _occupiedVantagePoints] call Rimsiakas_fnc_findOverwatchWithCover;

        if (isNil "_attackPositionData" && {(random 1) > 0.5}) then { // No good spot to shoot from found. 50% chance to try flanking / attacking straight.
            _attackPositionData = [getPos (leader _group), _targetPos, (_minFlankingDistance + 100) min _distance, _minFlankingDistance, _occupiedVantagePoints] call Rimsiakas_fnc_findCoveredAttackPosition;
        };

        if (isNil "_attackPositionData") then {
            _attackPosition = getPos (leader _group);
        } else {
            _attackPosition = _attackPositionData get "pos";
        };

        private _backupAttackPosition = _attackPosition;
        _attackPosition = _attackPosition findEmptyPosition [0, 50, typeOf leader _group];
        if ((count _attackPosition) == 0) then {
            _attackPosition = _backupAttackPosition;
        };



        _group setVariable ["attackingFromPos", _attackPosition];



        [_group, getPos (leader _group), _attackPosition, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;



        private _attackPositionWPCondition = "
            private _group = group this;
            [_group] call Rimsiakas_fnc_temporaryCombatMode;
            ([_group, 15] call Rimsiakas_fnc_waypointPreConditionTimeout) && {!([_group] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently) && {%1}};
        ";
        _attackPositionWPCondition = format [_attackPositionWPCondition, _additionalWaypointCondition];

        private _attackPositionWPStatement = "%1 [group this] call Rimsiakas_fnc_updateAttackingFromPos;";
        _attackPositionWPStatement = format [_attackPositionWPStatement, _additionalWaypointStatements];

        private _attackPositionWP = _group addWayPoint [_attackPosition, 1];
        _attackPositionWP setWaypointType "MOVE";
        _attackPositionWP setWaypointStatements [_attackPositionWPCondition, _attackPositionWPStatement];
        if (!isPlayer leader _group) then {
            _attackPositionWP setWaypointFormation (patrolCenter getVariable ["aiConfigAttackFormation", "WEDGE"]);
        };



        [_group, _attackPosition, _targetPos, _targetPos, false] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    } else {
        // Enemy is nearby so advance onto their position directly
        _group setVariable ["attackingFromPos", getPos (leader _group)];
        [_group, getPos (leader _group), _targetPos, _targetPos] call Rimsiakas_fnc_createIntermediateCombatMoveWaypoints;
    };



    private _waypointStatements = "%1 [group this] call Rimsiakas_fnc_searchForEnemies;";
    _waypointStatements = format [_waypointStatements, _additionalWaypointStatements];

    private _waypointCondition = "(!([group this] call Rimsiakas_fnc_hasGroupSeenItsTargetRecently) && {%1});";
    _waypointCondition = format [_waypointCondition, _additionalWaypointCondition];



    private _finalWaypoint = _group addWayPoint [getPos _target, 5];
    _finalWaypoint setWaypointType "SAD";
    _finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];
    if (!isPlayer leader _group) then {
        _finalWaypoint setWaypointFormation (patrolCenter getVariable ["aiConfigAttackFormation", "WEDGE"]);
    };
};