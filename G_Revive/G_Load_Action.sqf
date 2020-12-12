//Load incapacitated
//Local to _rescuer
params ["_unit", "_rescuer"];

//Select nearest vehicle, with 1m increased range from Action condition in case of movement during processing
private _vehicle = _unit nearEntities [G_Revive_Load_Types, 8] select 0;

//If MRVs are locked, prevent loading into enemy MRV
private _breakOut = false;
if ((G_Mobile_Respawn_Locked) && (!isNil {_vehicle getVariable "G_MRV_Logic"})) then {
	//Is locked MRV, so check side
	if !([side _rescuer, ((_vehicle getVariable "G_MRV_Logic") getVariable "G_Side")] call BIS_fnc_areFriendly) then {
		//Not friendly, so break out and announce
		_breakOut = true;
		if (isPlayer _rescuer) then {
			titleText [format["You cannot load %1 into %2 because the vehicle belongs to the other team!", name _unit, getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName")], "PLAIN", 1]; 
			sleep 1; 
			titleFadeOut 4;
		};
	};
};
if (_breakOut) exitWith {};

//If vehicle has no open cargo positions, exit
if ((_vehicle emptyPositions "cargo") < 1) exitWith {
	if (isPlayer _rescuer) then {
		titleText [format["You cannot load %1 into %2 because there is no more space!", name _unit, getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName")], "PLAIN", 1]; 
		sleep 1; 
		titleFadeOut 4;
	};
};

//Define Loaded variable with vehicle object
_unit setVariable ["G_Loaded", _vehicle, true];
//Execute validated Load of unit
[_unit, _vehicle] remoteExec ["G_fnc_moveInCargoToUnloadAction", 0, true];