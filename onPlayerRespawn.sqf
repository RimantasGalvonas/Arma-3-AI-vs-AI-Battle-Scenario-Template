params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];



[_newUnit] call Rimsiakas_fnc_revealFriendlyGroupsOnMap;



{
    _x synchronizeObjectsAdd [_newUnit]; // For some reason the synchronization breaks after respawn, but only in one way.
} forEach (synchronizedObjects _newUnit select {_x getVariable ["logicType", ""] == "placer"});



if (!(_newUnit getVariable ["CHVD_initialized", false])) then {
    call CHVD_fnc_init;
    _newUnit setVariable ["CHVD_initialized", true];
};