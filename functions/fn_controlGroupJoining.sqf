while {patrolCenter getVariable ["aiConfigAllowLastManToJoinNewGroup", false]} do {
    {
        private _group = _x;

        _initialGroupUnitCount = _group getVariable ["initialUnitCount", nil];

        if (isNil "_initialGroupUnitCount") then {
            _initialGroupUnitCount = count units _group;
            _group setVariable ["initialUnitCount", _initialGroupUnitCount, true];
        };

        if (_initialGroupUnitCount == 1) then {
            continue;
        };

        _group allowFleeing 0;

        if (_group getVariable ["ignoreIntel", false]) then {
            continue;
        };

        private _aliveUnits = (units _group) select {alive _x};

        if (count _aliveUnits != 1) then {
            continue;
        };

        _unit = _aliveUnits select 0;

        if (isPlayer _unit) then {
            continue;
        };

        private _nearUnits = (nearestObjects [getPos _unit, ["Man"], 200]) select {alive _x && {side _x != civilian && {_x != _unit && {!(group _x getVariable ["ignoreIntel", false])}}}};

        private _nearestFriendly = nil;   
       
        {   
            if ([side _unit, side _x] call BIS_fnc_sideIsFriendly) exitWith {_nearestFriendly = _x;}   
        } forEach _nearUnits;   

        if (isNil "_nearestFriendly") then {   
            continue; 
        };

        [_unit] join group _nearestFriendly;
    } forEach allGroups;

    sleep 5;
};