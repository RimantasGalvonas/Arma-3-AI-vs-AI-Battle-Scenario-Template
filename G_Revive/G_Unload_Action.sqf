//Unload incapacitated
//Local to executor (not _unit)
private _vehicle = _this select 0;
private _unloadActionID = _this select 2;
private _unit = _this select 3 select 0;

//Order unit to be out of vehicle
[_unit] remoteExecCall ["unassignVehicle", _unit, true];
//Manually remove unit from vehicle
moveOut _unit;

//Wait for unit to be out of vehicle before executing animations to prevent wrong animation
waitUntil {sleep 0.1; (vehicle _unit == _unit)};

//Execute Incapacitated animation (still required despite playAction "Unconscious")
[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];

//Allow animation to set to prevent other animation executing too early
sleep 3;

//Set unit as not loaded and broadcast
if (!isNull (_unit getVariable "G_Loaded")) then {
	_unit setVariable ["G_Loaded", objNull, true];
};