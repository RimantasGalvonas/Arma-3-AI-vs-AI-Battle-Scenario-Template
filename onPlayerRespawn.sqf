params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];



_friendlyGroups = allGroups select {[side _newUnit, side _x] call BIS_fnc_sideIsFriendly};
_newUnit setVariable ["MARTA_reveal", _friendlyGroups];
setGroupIconsVisible [true, false];



{
    _x synchronizeObjectsAdd [_newUnit]; // For some reason the synchronization breaks after respawn, but only in one way.
} forEach (synchronizedObjects _newUnit select {_x getVariable ["logicType", ""] == "placer"});



if (!(_newUnit getVariable ["CHVD_initialized", false])) then {
    call CHVD_fnc_init;
    _newUnit setVariable ["CHVD_initialized", true];
};