params ["_group", ["_previousTargetGroup", false], ["_newTargetGroup", false]];


if (_previousTargetGroup isEqualTo _newTargetGroup) exitWith {};

if (!(_previousTargetGroup isEqualTo false)) then {
    // TODO: should actually only pay attention to other FRIENDLY units. Might be that there's a scenario where three hostile factions are fighting.
    private _groupsAttackingThisTargetGroup = _previousTargetGroup getVariable ["targetedBy", []];
    _groupsAttackingThisTargetGroup = _groupsAttackingThisTargetGroup select {_x != _group};
    _previousTargetGroup setVariable ["targetedBy", _groupsAttackingThisTargetGroup];

    {
        private _attackingGroup = _x;

        private _otherGroupAttackPriority = _attackingGroup getVariable ["respondingToIntelPriority", nil];

        if (!isNil "_otherGroupAttackPriority") then {
            _attackingGroup setVariable ["respondingToIntelPriority", _otherGroupAttackPriority + 0.33]; // TODO: make sure this matches the constant in fn_receiveIntel.sqf if I make any changes
        };
    } forEach _groupsAttackingThisTargetGroup;
};


if (!(_newTargetGroup isEqualTo false)) then {
    // TODO: should actually only pay attention to other FRIENDLY units. Might be that there's a scenario where three hostile factions are fighting.
    private _groupsAttackingThisTargetGroup = _newTargetGroup getVariable ["targetedBy", []];
    _groupsAttackingThisTargetGroup = _groupsAttackingThisTargetGroup select {_x != _group};

    {
        private _attackingGroup = _x;

        private _otherGroupAttackPriority = _attackingGroup getVariable ["respondingToIntelPriority", nil];
        
        if (!isNil "_otherGroupAttackPriority") then {
            _attackingGroup setVariable ["respondingToIntelPriority", _otherGroupAttackPriority - 0.33]; // TODO: make sure this matches the constant in fn_receiveIntel.sqf if I make any changes
        };
    } forEach _groupsAttackingThisTargetGroup;

    _groupsAttackingThisTargetGroup append [_group];
    _newTargetGroup setVariable ["targetedBy", _groupsAttackingThisTargetGroup];
};