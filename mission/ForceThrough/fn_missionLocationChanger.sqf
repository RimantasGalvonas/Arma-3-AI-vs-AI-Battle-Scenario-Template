_var = [] spawn {
     _createFrontlineMarker = {
        _markerAngle = (((triggerArea win_trigger) select 2) + ((triggerArea lose_trigger) select 2)) / 2;
        triggerForFrontLineMarker setPos (getPos patrolCenter);
        triggerForFrontLineMarker setTriggerArea [patrolCenter getVariable "patrolRadius", 50, _markerAngle, true];
        ["FrontlineMarker", triggerForFrontLineMarker] call BIS_fnc_markerToTrigger;
        "FrontlineMarker" setMarkerShapeLocal "RECTANGLE";
        "FrontlineMarker" setMarkerAlphaLocal 0.3;
        "FrontlineMarker" setMarkerBrushLocal "Grid";
        "FrontlineMarker" setMarkerColor "ColorRed";
    };

    call _createFrontlineMarker;

    patrolCenter synchronizeObjectsRemove [win_trigger, lose_trigger];

    _lastRespawnMovePatrolCenterPos = getPos patrolCenter;

    while {true} do {
        sleep 60;

        _missionAreaRadius = patrolCenter getVariable "patrolRadius";
        _missionArea = [(getPos patrolCenter), _missionAreaRadius, _missionAreaRadius, 0, true];

        _allLeadersXPosSum = 0;
        _allLeadersYPosSum = 0;
        _groupsInsideMissionAreaCount = 0;

        {
            _leaderPos = getPos (leader _x);

            if (!(_leaderPos inArea _missionArea)) then {
                continue;
            };

            _allLeadersXPosSum = _allLeadersXPosSum + (_leaderPos select 0);
            _allLeadersYPosSum = _allLeadersYPosSum + (_leaderPos select 1);

            _groupsInsideMissionAreaCount = _groupsInsideMissionAreaCount + 1;
        } forEach allGroups;

        if (_groupsInsideMissionAreaCount > 0) then {
            _avgX = _allLeadersXPosSum / _groupsInsideMissionAreaCount;
            _avgY = _allLeadersYPosSum / _groupsInsideMissionAreaCount;

            [[_avgX, _avgY]] call Rimsiakas_fnc_moveMissionArea;
            remoteExec ["Rimsiakas_fnc_createIntelGrid"];
            call _createFrontlineMarker;

            if ((_lastRespawnMovePatrolCenterPos distance2D (getPos patrolCenter)) > 200) then {
                _lastRespawnMovePatrolCenterPos = getPos patrolCenter;

                [Placer_respawn_1] call Rimsiakas_fnc_placer;
                "supplies_marker_1" setMarkerPos (getPos supplies_1);
                [Placer_respawn_2] call Rimsiakas_fnc_placer;
                "supplies_marker_2" setMarkerPos (getPos supplies_2);
            };
        };
    };
};