while {true} do {
    private _knownByBlufor = [];
    private _knownByOpfor = [];
    private _knownByIndependent = [];

    {
        private _targets = leader _x targets [true, 1000, [], 30];

        if (side _x == blufor) then {
            _knownByBlufor append _targets;
        };

        if (side _x == opfor) then {
            _knownByOpfor append _targets;
        };

        if (side _x == independent) then {
            _knownByIndependent append _targets;
        }
    } forEach allGroups;

    //remove duplicates
    _knownByBlufor = _knownByBlufor arrayIntersect _knownByBlufor;
    _knownByOpfor = _knownByOpfor arrayIntersect _knownByOpfor;
    _knownByIndependent =_knownByIndependent arrayIntersect _knownByIndependent;


    {
        private _commonTargets = [];
        if ([blufor, side _x] call BIS_fnc_sideIsFriendly) then {
            _commonTargets append _knownByBlufor;
        };

        if ([opfor, side _x] call BIS_fnc_sideIsFriendly) then {
            _commonTargets append _knownByOpfor;
        };

        if ([independent, side _x] call BIS_fnc_sideIsFriendly) then {
            _commonTargets append _knownByIndependent;
        };

        _commonTargets = _commonTargets arrayIntersect _commonTargets;

        [_x, _commonTargets] call Rimsiakas_fnc_receiveIntel;

    } forEach allGroups;

    sleep 10;
};