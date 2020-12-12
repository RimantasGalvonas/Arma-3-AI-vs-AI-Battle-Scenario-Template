//Handle onKilled
//Local to _unit
params ["_unit"];
private _respawnType = getNumber(missionConfigFile >> "respawn");

//bug - No respawn timer for AI? Intended?
//Ensure at least a 3 second respawn time to allow for code execution
if (isPlayer _unit) then {
	if (playerRespawnTime < 3) then {
		setPlayerRespawnTime 3;
	};
};

//For respawnOnStart, allow time for definitions to catch up
waitUntil {(!isNil {_unit getVariable "G_Lives"})};

//Custom execution
if (!isNil "G_fnc_Custom_Exec_2") then {
	[_unit] spawn G_fnc_Custom_Exec_2;
};

//Handle life count if spawns are limited and this is not the initial spawn
private _noLives = false;
if (!(G_Num_Respawns == -1)) then {
	//Get life count
	private _lives = _unit getVariable "G_Lives";
	//Remove one life from count
	_lives = _lives - 1;
	//Determine if no lives remain
	if (_lives < 0) then {
		_noLives = true;
	};
	//Set new life count
	_unit setVariable ["G_Lives", _lives, true];
};

//Command server to check for all of a side being down/dead
[_unit] remoteExec ["G_fnc_serverCheckEndMission", 2, false];

//Handle unit if no lives remain
if (_noLives) exitWith {
	if (isPlayer _unit) then {
		//Handle as player
		//Prevent display of RespawnMenu
		_unit setVariable ["BIS_fnc_showRespawnMenu_disable", true];
		//Enter Spectator if enabled, otherwise end the mission
		if (G_Spectator) then {
			//Spectator enabled, so launch it
			[_unit, _respawnType] execVM "G_Revive\G_Spectator.sqf";
		}
		else
		{
			//Spectator disabled, so prevent unit from respawning before they are removed
			setPlayerRespawnTime 30;
			//End the mission locally as failure
			["END1", false] call BIS_fnc_endMission;
		};
	}
	else
	{
		//Handle as AI
		//bug - what to do here to prevent AI from respawning? Possibly delete somehow?
	};
};