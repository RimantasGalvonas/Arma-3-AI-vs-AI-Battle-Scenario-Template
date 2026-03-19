params ["_airfieldPlacer"];

while {true} do {
    private _spawner = (_airfieldPlacer getVariable "spawners") select 0;
    private _spawnerUnits = flatten (_spawner getVariable ["spawnedUnitsAndCrewArrays", []]);
    private _groups = _spawnerUnits apply {group _x};

    if (isNil "_groups") then {
        sleep 10;
        continue;
    };

    _groups = _groups arrayIntersect _groups; // unique values

    {
        private _group = _x;

        _groupVehicles = ([_group, true] call BIS_fnc_groupVehicles) select { canMove _x; };
        _hasGroupPlayer = count ((units _group) select { isPlayer _x }) > 0;

        if (count _groupVehicles == 0 && !_hasGroupPlayer) then {
            {
                if (_x in _spawnerUnits) then { // It's possible that a player crewman has joined a different group after ejecting. Don't delete the other units.
                    deleteVehicle _x;
                };
            } forEach (units _group);

            continue;
        };

        private _rtbRequiredVehicles = _groupVehicles select { damage _x > 0.5 || { !someAmmo _x || { fuel _x < 0.3 }}};

        if (count _rtbRequiredVehicles > 0 && {!(_group getVariable ["ForceThrough_returningToBase", false])}) then {
            _group setVariable ["ForceThrough_returningToBase", true];
            _group setVariable ["ignoreIntel", true];

            for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
                deleteWaypoint [_group, _i];
            };

            private _waypointStatements = "
                private _group = group this;

                _group setVariable [""ForceThrough_returningToBase"", false];
                _group setVariable [""ignoreIntel"", false];

                {
                    _x setFuel 1;
                    _x setVehicleAmmo 1;
                    _x setDamage 0;
                } forEach ([_group, true] call BIS_fnc_groupVehicles) select { canMove _x; };

                [_group] call Rimsiakas_fnc_searchForEnemies;
            ";

            private _rtbWaypoint = _group addWayPoint [_airfieldPlacer getVariable "ilsPos", -1, 0];
            _rtbWaypoint setWaypointType "MOVE";
            _rtbWaypoint setWaypointStatements ["true", _waypointStatements];
        };
    } forEach (_groups select {!isNull _x}); // Group may not have been deleted yet

    sleep 5;
};