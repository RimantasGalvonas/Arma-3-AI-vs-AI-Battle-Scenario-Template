params ["_group"];

while {true} do {
    _targets = leader _group targets [true, 1000, [], 30];

    {
        _isFriendly = [side _group, side _x] call BIS_fnc_sideIsFriendly;
        if (_isFriendly && _group != _x) then {
            [_x, _targets] call Rimsiakas_fnc_receiveIntel;
        };
    } forEach allGroups;

    sleep 10;
};