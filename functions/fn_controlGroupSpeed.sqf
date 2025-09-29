private _suitableCoverClasses = ["TREE", "SMALL TREE", "BUILDING", "HOUSE", "FOREST BORDER", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "FUELSTATION", "HOSPITAL", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWIND", "SHIPWRECK"];

private _speedMode = patrolCenter getVariable ["aiConfigSpeedMode", "NORMAL"];

while {_speedMode != "NORMAL"} do {
    {
        private _group = _x;


        // Early returns for all the conditions where this shit should be skipped
        if (isPlayer (hcLeader _group)) then {
            continue;
        };

        if (_group getVariable ["ignoreIntel", false]) then {
            continue;
        };

        if (isPlayer leader _group) then {
            _group setSpeedMode "NORMAL";

            continue;
        };

        if (combatBehaviour _group == "COMBAT") then {
            _group setSpeedMode "NORMAL";

            continue;
        };

        private _targetGroup = _group getVariable ["currentTargetGroup", nil];

        if (!isNil "_targetGroup" && {patrolCenter getVariable ["aiConfigAttackSpeedOverride", false]}) then {
            _group setSpeedMode "NORMAL";

            continue;
        };



        // Slow speed mode

        if (_speedMode == "SLOW") then {
            _group setSpeedMode "LIMITED";

            continue;
        };



        // Smart speed mode

        if ([getPos leader _group] call Rimsiakas_fnc_isPositionInForest) then {
            _group setSpeedMode "LIMITED";

            continue;
        };

        _waypointPosition = waypointPosition [_group, (currentWaypoint _group)];
        _waypointDir = (leader _group) getDir _waypointPosition;
        _positionInFrontOfLeader = (leader _group) getPos [5, _waypointDir];

        // Run if no cover in front of leader (needed to cross roads unstupidly and such)
        if (count (nearestTerrainObjects [_positionInFrontOfLeader, _suitableCoverClasses, 10, false]) == 0) then {
            _group setSpeedMode "NORMAL";

            continue;
        };

        private _unitsWithCover = [];
        {
            private _unit = _x;

            if (count (nearestTerrainObjects [getPos _unit, _suitableCoverClasses, 10, false]) > 0) then {
                _unitsWithCover append [_unit];
            };
        } foreach units _group;

        // Slow down if most of the group is in cover
        if ((count _unitsWithCover) > ((count units _group) * 0.66)) then {
            _group setSpeedMode "LIMITED";
        } else {
            _group setSpeedMode "NORMAL";
        };

    } forEach allGroups;

    sleep 5;
};