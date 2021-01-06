params ["_group"];

_target = _group getVariable ['currentTarget', nil];

if (isNil '_target') exitWith {
    false;
};

if (!alive _target) exitWith {
    false;
};

_groupSeenTheTargetRecently = false;

{
    _targetKnowledge = _x targetKnowledge _target;
    _lastSeen = (_targetKnowledge select 2) max 0;
    _secondsSinceSeen = time - _lastSeen;
    if (_lastSeen > 0 && {_secondsSinceSeen < 60}) exitWith {
        _groupSeenTheTargetRecently = true;
    };
} forEach units _group;

if (_groupSeenTheTargetRecently) exitWith {
    true;
};

false;