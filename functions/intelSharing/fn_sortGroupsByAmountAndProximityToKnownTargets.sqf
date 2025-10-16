params ["_knownByBlufor", "_knownByOpfor", "_knownByIndependent"];

private _knownByBluforLeaders = _knownByBlufor apply { leader group _x };
private _knownByOpforLeaders = _knownByOpfor apply { leader group _x };
private _knownByIndependentLeaders =_knownByIndependent apply { leader group _x };

_knownByBluforLeaders = _knownByBluforLeaders arrayIntersect _knownByBluforLeaders;
_knownByOpforLeaders = _knownByOpforLeaders arrayIntersect _knownByOpforLeaders;
_knownByIndependentLeaders = _knownByIndependentLeaders arrayIntersect _knownByIndependentLeaders;

private _groupsWithoutTarget = allGroups select {(_x getVariable ["currentTarget", false] isEqualTo false)};
private _groupsWithTarget = allGroups select {!(_x getVariable ["currentTarget", false] isEqualTo false)};

// This sorting is slow and doesn't scale. Doing this only for groups without a target to optimize
private _sortedGroups = [
    _groupsWithoutTarget,
    [_knownByBluforLeaders, _knownByOpforLeaders, _knownByIndependentLeaders],
    {
        private _groupLeader = leader _x;
        private _targets = [];
        private _score = 0;

        switch (side _x) do
        {
            case blufor: {
                _targets = _input0;
            };
            case opfor: {
                _targets = _input1;
            };
            case independent: {
               _targets = _input2;
            };
            default {};
        };

        {
            private _target = _x;

            private _distance = _groupLeader distance _target;

            if (_distance > 2000) then {
                continue;
            };

            _score = _score + ((2000 - _distance) / 2000);
        } forEach _targets;

        _score;
    },
    "DESCEND"
] call BIS_fnc_sortBy;

_sortedGroups append _groupsWithTarget;

_sortedGroups;