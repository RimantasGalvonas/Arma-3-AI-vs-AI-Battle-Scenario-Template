//Handle Spectator view
//Local to _unit
params ["_unit", "_respawnType"];

//Create parallel, infinite loop that prevents respawn
[] spawn {
	while {true} do {
		setPlayerRespawnTime 60;
		sleep 40;
	};
};

//Remove player from group because player is permanently dead
[_unit] joinSilent grpNull;

//BIS_fnc_respawnSpectator - Removed checks for respawnScreen, really just using
//this for BIS_fnc_EGSpectator
//Normally Spectator will just execute; if using the Seagull respawn ("1"), it will wait for
//seagull respawn and then execute Spectator; if player is alive and here, something odd happened
//and Spectator will close or not be executed.
if (!alive _unit) then {
	["Initialize", [player, [], false]] call BIS_fnc_EGSpectator;
} else {
	if (_respawnType == 1) then {
		//--- Open
		waituntil {missionnamespace getvariable ["BIS_fnc_feedback_allowDeathScreen",true]};
		BIS_fnc_feedback_allowPP = false;
		
		["Initialize", [player, [], false, true, true]] call BIS_fnc_EGSpectator;
	} else {
		//--- Close
		["Terminate"] call BIS_fnc_EGSpectator;
	};
};