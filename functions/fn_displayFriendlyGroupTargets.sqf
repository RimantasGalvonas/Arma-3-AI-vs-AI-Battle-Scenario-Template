[] spawn {
    private _debugMarkerNames = [];

    while {patrolCenter getVariable ["showFriendlyGroupTargets", true]} do {
        {
            _x setMarkerAlphaLocal 0; // Much faster than deleting, I don't know
        } forEach _debugMarkerNames;

        _debugMarkerNames = [];

        {
            private _group = _x;
            private _currentTargetGroup = _group getVariable ["currentTargetGroup", nil];

            if (isNil "_currentTargetGroup") then {
                continue;
            };

            if (count ((units _group) select {alive _x}) == 0) then {
                continue;
            };

            if (count ((units _currentTargetGroup) select {alive _x}) == 0) then {
                continue;
            };

            private _groupLeaderPos = getPos leader _group;
            private _lastKnownPosition = _group getVariable "lastReportedTargetPosition";
            private _color = [side _group, true] call BIS_fnc_sideColor;


            private _markerName = "group" + (str _group) + "targetLastKnownPositionLine";
            createMarkerLocal [_markerName, _groupLeaderPos];
            private _targetLeaderPos = getPos leader _currentTargetGroup;
            _markerName setMarkerColorLocal _color;
            _markerName setMarkerAlphaLocal 0.3;
            _markerName setMarkerShapeLocal "POLYLINE";
            _markerName setMarkerPolylineLocal [_groupLeaderPos select 0, _groupLeaderPos select 1, _lastKnownPosition select 0, _lastKnownPosition select 1];
            _debugMarkerNames append [_markerName];

            _markerName = "group" + (str _group) + "targetLastKnownPositionIcon";
            createMarkerLocal [_markerName, _lastKnownPosition];
            _markerName setMarkerPosLocal _lastKnownPosition;
            _markerName setMarkerColorLocal _color;
            _markerName setMarkerAlphaLocal 0.3;
            _markerName setMarkerTypeLocal "hd_objective_noShadow";
            _markerName setMarkerSizeLocal [0.5, 0.5];
            _debugMarkerNames append [_markerName];
        } forEach (allGroups select {[side player, side _x] call BIS_fnc_sideIsFriendly});

        sleep 1;
    };
};