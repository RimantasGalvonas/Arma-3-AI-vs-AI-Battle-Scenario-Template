//Handle onRespawn
//Local to _unit
params ["_unit"];

//Set next respawn time
if (isPlayer _unit) then {
	setPlayerRespawnTime G_Respawn_Time;
};

//Reset Revive system actions and variables
if (G_Revive_System) then {
	[_unit] remoteExec ["G_fnc_Revive_Actions", 0, true];
	_unit call G_fnc_Revive_resetVariables;
	_unit setCaptive false;
	_unit enableAI "MOVE";
	_unit enableAI "FSM";
	_unit allowDamage true;
};

//Reset multi-system variables
_unit setVariable ["G_Side", side _unit, true];
_unit setVariable ["G_isRenegade", false, true];

//Handle squad leader spawn if enabled
if (G_Squad_Leader_Spawn) then {
	//Execute in parallel because of having to wait on parallel script
	[_unit] spawn {
		params ["_unit"];
		//Make sure unit spawned on squad leader (probably landed within 10m) or time has elapsed without true
			//Code executes in 0.25, so this delay should be plenty and non-intrusive
		_timer = time;
		private _squadLeader = leader group _unit;
		waitUntil {sleep 0.1; (((_squadLeader != _unit) && ((_squadLeader distance _unit) < 10)) || ((time - _timer) >= 2))};
		if ((_squadLeader != _unit) && ((_squadLeader distance _unit) < 10)) then {
			//Assume squad leader's stance
			[_unit, animationState _squadLeader] remoteExecCall ["switchMove", 0, true];
		};
	};
};

//Custom execution
if (!isNil "G_fnc_Custom_Exec_3") then {
	[_unit] spawn G_fnc_Custom_Exec_3;
};

if (isPlayer _unit) then {
	//Slight delay before life count announcement
	sleep 2;

	//Handle life count announcement, if limited and not the inital spawn
	private _lives = _unit getVariable "G_Lives";
	if (_lives >= 0) then {
		//Use appropriate plurality
		private _livesPlural = "lives";
		if (_lives == 1) then {
			_livesPlural = "life";
		};
		//Announce life count
		titleText [format["You have %1 %2 remaining!", _lives, _livesPlural], "PLAIN", 2];
		sleep 3;
		titleFadeOut 3;
	};
};