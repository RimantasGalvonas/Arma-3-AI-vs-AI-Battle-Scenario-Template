params ["_airfieldPlacer"];

while {true} do {
    private _spawner = (_airfieldPlacer getVariable "spawners") select 0;
    private _groups = (_spawner getVariable "spawnedUnits") apply {group _x};

    if (isNil "_groups") then {
        sleep 10;
        continue;
    };

    _groups = _groups arrayIntersect _groups; // unique values

    {
        private _group = _x;

        _groupVehicles = ([_group, true] call BIS_fnc_groupVehicles) select { canMove _x; };

        if (count _groupVehicles == 0) then {
            { if (!isPlayer _x) then { deleteVehicle _x; } } forEach (units _group); // Player will be deleted next check after teamswitch

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