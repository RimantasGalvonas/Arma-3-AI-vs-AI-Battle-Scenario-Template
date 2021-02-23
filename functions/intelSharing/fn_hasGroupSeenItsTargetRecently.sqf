params ["_group", ["_targetModeGroup", true]];

scopeName "main";



_targetGroup = _group getVariable ["currentTargetGroup", nil];

if (isNil "_targetGroup") exitWith {
    false;
};



_targets = [];

if (_targetModeGroup) then {
    _targets = units _targetGroup;
} else {
    _targets append [_group getVariable ["currentTarget", nil]];
};



{
    _target = _x;

    if (isNil "_target") then {
        continue;
    };

    if (!alive _target) then {
        continue;
    };

    {
        _targetKnowledge = _x targetKnowledge _target;
        _lastSeen = (_targetKnowledge select 2) max 0;
        _secondsSinceSeen = time - _lastSeen;

        if (_lastSeen > 0 && {_secondsSinceSeen < 60}) then {
            true breakOut "main";
        };
    } forEach units _group;
} forEach _targets;



false;