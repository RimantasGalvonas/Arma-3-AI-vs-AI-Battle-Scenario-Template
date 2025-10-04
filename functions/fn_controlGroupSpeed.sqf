// Note: the "HIDE" class was removed here, but left in the cover calculations for waypoints. Sometimes they can be rocks, which in case of, for example, Altis, can make a big difference. Should not slow down for such things though. AND they're also things such as roads and runways and such. Stupid.
private _suitableCoverClasses = ["TREE", "SMALL TREE", "BUILDING", "HOUSE", "FOREST BORDER", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "FUELSTATION", "HOSPITAL", "WALL", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWIND", "SHIPWRECK"];

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

        // Leaving this commented out so I don't forget and start getting ideas. Forest detection is slower.
        // if ([getPos leader _group] call Rimsiakas_fnc_isPositionInForest) then {
        //     _group setSpeedMode "LIMITED";

        //     continue;
        // };

        private _requiredProximityToCover = 15;
        private _requiredCoverCount = 3;

        private _waypointPosition = waypointPosition [_group, (currentWaypoint _group)];
        private _waypointDir = (leader _group) getDir _waypointPosition;
        private _positionInFrontOfLeader = (leader _group) getPos [_requiredProximityToCover, _waypointDir];
        // Run if no cover in front of leader (so he doesn't just keep on lazily strolling about after getting out of cover)
        if (count (nearestTerrainObjects [_positionInFrontOfLeader, _suitableCoverClasses, _requiredProximityToCover * 1.1, false]) < _requiredCoverCount) then {
            _group setSpeedMode "NORMAL";

            continue;
        };

        private _unitsWithCover = [];
        {
            private _unit = _x;

            if (count (nearestTerrainObjects [getPos _unit, _suitableCoverClasses, _requiredProximityToCover, false]) >= _requiredCoverCount) then {
                _unitsWithCover append [_unit];
            };
        } foreach units _group;

        // Slow down if at least some of the group is in cover
        if ((count _unitsWithCover) >= floor ((count units _group) * 0.3)) then {
            _group setSpeedMode "LIMITED";
        } else {
            _group setSpeedMode "NORMAL";
        };

    } forEach allGroups;

    sleep 1;
};