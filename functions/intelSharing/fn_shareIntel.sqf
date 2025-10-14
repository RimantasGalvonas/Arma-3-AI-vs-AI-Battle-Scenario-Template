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


    priorityCalculationDebugData = [];
    hint "";
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

    
    hint "ok";
    {
        if (_x get "targetPriority" == 1 && {count (_x get "targetAttackers") != 0 }) then {
            hint "Fuckin fuck, the motherfuckers saw other fucking attackers and still chose the priority as 1";
        }
    } forEach priorityCalculationDebugData;

    copyToClipboard toJSON priorityCalculationDebugData;


    {
        private _attackingGroup = _x;

        private _attackingGroupTargetPriority = _attackingGroup getVariable ["respondingToIntelPriority", nil];

        private _attackingGroupTargetGroup = _attackingGroup getVariable ["currentTargetGroup", nil];

        if (isNil "_attackingGroupTargetPriority" || {isNil "_attackingGroupTargetGroup"}) then {
            continue;
        };

        private _targetGroupAttackedBy = _attackingGroupTargetGroup getVariable ["targetedBy", []];

        _targetGroupAttackedBy = _targetGroupAttackedBy select {str _x != str _attackingGroup};

        if (count _targetGroupAttackedBy == 0 && {_attackingGroupTargetPriority != 1}) then {
            hint ("fuckup detected with " + str _attackingGroup + " should be 1, is " + (_attackingGroupTargetPriority toFixed 2));
        };

        if (count _targetGroupAttackedBy == 1 && {(_attackingGroupTargetPriority toFixed 2) != "0.67"}) then {
            hint ("fuckup detected with " + str _attackingGroup + " should be 0.67, is " + (_attackingGroupTargetPriority toFixed 2));
        };

        if (count _targetGroupAttackedBy == 2 && {(_attackingGroupTargetPriority toFixed 2) != "0.34"}) then {
            hint ("fuckup detected with " + str _attackingGroup + " should be 0.34, is " + (_attackingGroupTargetPriority toFixed 2));
        };
    } forEach allGroups;

    sleep 10;
};