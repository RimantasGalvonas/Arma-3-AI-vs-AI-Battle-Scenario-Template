params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

_newUnit setVariable ["MARTA_reveal", (_oldUnit getVariable "MARTA_reveal")];

if (!(_newUnit getVariable ["CHVD_initialized", false])) then {
    call CHVD_fnc_init;
    _newUnit setVariable ["CHVD_initialized", true];
};