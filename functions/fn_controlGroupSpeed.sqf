while {true} do {
    {
        // TODO: refactor. The whole thing looks terrible because it's been years since I've touched any SQF. I don't remember shit.
        private _group = _x;

        if (isPlayer (hcLeader _group)) then {
            continue;
        };

        if (_group getVariable ["ignoreIntel", false]) then {
            continue;
        };

        if (isPlayer leader _group) then {
            _group setSpeedMode "NORMAL";
        };

        private _position = getPos leader _group;

        if ([_position] call Rimsiakas_fnc_isPositionAmongBuildings) then {
            _group setSpeedMode (patrolCenter getVariable ["aiConfigBuildingsSpeed", "NORMAL"]);

            continue;
        };

        if ([_position] call Rimsiakas_fnc_isPositionInForest) then {
            _group setSpeedMode (patrolCenter getVariable ["aiConfigForestSpeed", "NORMAL"]);

            continue;
        };

        _group setSpeedMode (patrolCenter getVariable ["aiConfigDefaultSpeed", "NORMAL"]);
    } forEach allGroups;

    sleep 5;
};