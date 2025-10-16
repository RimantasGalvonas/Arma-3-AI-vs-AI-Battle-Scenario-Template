while {true} do {
    private _knownByBlufor = [];
    private _knownByOpfor = [];
    private _knownByIndependent = [];

    {
        private _group = _x;

        private _groupTargetedBy = _group getVariable ["targetedBy", []];
        _groupTargetedBy = _groupTargetedBy select {!isNull _x};
        _groupTargetedBy = _groupTargetedBy select {count (units _x select {alive _x}) > 0};
        _group setVariable ["targetedBy", _groupTargetedBy];

        private _targets = leader _group targets [true, 1000, [], 30];

        switch (side _group) do
        {
            case blufor: {
               _knownByBlufor append _targets;
            };
            case opfor: {
                _knownByOpfor append _targets;
            };
            case independent: {
               _knownByIndependent append _targets;
            };
            default {};
        };
    } forEach allGroups;



    if ([blufor, independent] call BIS_fnc_sideIsFriendly) then {
        _knownByBlufor append _knownByIndependent;
        _knownByIndependent = _knownByBlufor;
    };

    if ([opfor, independent] call BIS_fnc_sideIsFriendly) then {
        _knownByOpfor append _knownByIndependent;
        _knownByIndependent = _knownByOpfor;
    };

    //remove duplicates
    _knownByBlufor = _knownByBlufor arrayIntersect _knownByBlufor;
    _knownByOpfor = _knownByOpfor arrayIntersect _knownByOpfor;
    _knownByIndependent =_knownByIndependent arrayIntersect _knownByIndependent;



    // This sorting allows unengaged groups closest to enemies have a first pick at choosing the target. Helps the target assignment look less random.
    _groupsSortedByTargetAmountAndProximity = [_knownByBlufor, _knownByOpfor, _knownByIndependent] call Rimsiakas_fnc_sortGroupsByAmountAndProximityToKnownTargets;

    {
        private _targets = [];

        switch (side _x) do
        {
            case blufor: {
                _targets = _knownByBlufor;
            };
            case opfor: {
                _targets = _knownByOpfor;
            };
            case independent: {
               _targets = _knownByIndependent;
            };
            default {};
        };

        [_x, _targets] call Rimsiakas_fnc_receiveIntel;

    } forEach _groupsSortedByTargetAmountAndProximity;



    sleep 10;
};