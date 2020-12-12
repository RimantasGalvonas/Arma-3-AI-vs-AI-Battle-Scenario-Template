//Revive system's definitions for EHs and more
//Local to executor

//Define revive-related variables based on data type
G_Revive_boolVars = ["G_Incapacitated", "G_Dragged", "G_Carried", "G_Dragging", "G_Carrying"];
G_Revive_objVars = ["G_Reviver", "G_Reviving", "G_Loaded"];

//Define function to reset revive variables and broadcast them
G_fnc_Revive_resetVariables = {
	params ["_unit"];
	{
		_unit setVariable [_x, false, true];
	} forEach G_Revive_boolVars;
	{
		_unit setVariable [_x, objNull, true];
	} forEach G_Revive_objVars;
	//rescueRole - 0: none, 1: reviver, 2: guard
	_unit setVariable ["G_AI_rescueRole", [0, objNull], true];
	_unit setVariable ["G_Downs", 0, true];
};

//Define function for entering Incapacitated-state script
G_fnc_enterIncapacitatedState = compile preprocessFileLineNumbers "G_Revive\G_Unconscious.sqf";
//Define function for cleanly exiting Incapacitated-state script
G_fnc_exitIncapacitatedState = {
	_this setVariable ["G_Incapacitated", false, true];
};

//Define onKill script
G_fnc_onKill = compile preprocessFileLineNumbers "G_Revive\G_Killer.sqf";

//Define revive-related actions
G_fnc_actionRevive = compile preprocessFileLineNumbers "G_Revive\G_Revive_Action.sqf";
G_fnc_actionDrag = compile preprocessFileLineNumbers "G_Revive\G_Drag_Action.sqf";
G_fnc_actionCarry = compile preprocessFileLineNumbers "G_Revive\G_Carry_Action.sqf";
G_fnc_actionLoad = compile preprocessFileLineNumbers "G_Revive\G_Load_Action.sqf";
G_fnc_actionUnload = compile preprocessFileLineNumbers "G_Revive\G_Unload_Action.sqf";
G_fnc_actionDrop = compile preprocessFileLineNumbers "G_Revive\G_Drop_Action.sqf";
G_fnc_actionSecure = {
	//Local to executor
	params ["_target", "_executor"];
	//Kill the target
	_target setDamage 1;
	//Execute "secured" animation
	[_target, "revive_secured"] remoteExec ["switchMove", 0, false];
};

//Define function to check common conditions in revive-related actions
G_fnc_Revive_Actions_Cond = {
	params ["_target", "_this", "_distReq"];
	((_target != _this) && !(_this getVariable "G_Incapacitated") && (_target getVariable "G_Incapacitated") && ((_target distance _this) < _distReq) && !(_target getVariable "G_Dragged") && !(_target getVariable "G_Carried") && !(_this getVariable "G_Carrying") && !(_this getVariable "G_Dragging") && (isNull (_target getVariable "G_Reviver")) && (isNull (_this getVariable "G_Reviving")) && (isNull (_target getVariable "G_Loaded")))
};

//Define function to add all revive-related actions
G_fnc_Revive_Actions = {
	params ["_unit"];
	private _reviveActionID = _unit addAction [format["<t color='%1'>Revive</t>", G_Revive_Action_Color], G_fnc_actionRevive, [], 11, true, true, "", "(([_target, _this, 2.45] call G_fnc_Revive_Actions_Cond) && ([side _this, ((crew _target) select 0) getVariable ""G_Side""] call BIS_fnc_areFriendly) && !(_target getVariable ""G_isRenegade"") && (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)))"];
	_unit setUserActionText [_reviveActionID, format["<t color='%1'>Revive</t>", G_Revive_Action_Color], "", "<img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' size='3' shadow='2'/>"];
	private _secureActionID = [_unit, format["<t color='%1'>Secure</t>", G_Revive_Action_Color], "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa", "(([_target, _this, 2.45] call G_fnc_Revive_Actions_Cond) && !([side _this, ((crew _target) select 0) getVariable ""G_Side""] call BIS_fnc_areFriendly))", "true", {}, {}, G_fnc_actionSecure, {}, [], 1.5, 11, true, false] call BIS_fnc_holdActionAdd;
	private _loadActionID = _unit addAction [format["<t color='%1'>Load Into Vehicle</t>", G_Revive_Action_Color], G_fnc_actionLoad, [], 10.9, true, true, "", format["(([_target, _this, 5] call G_fnc_Revive_Actions_Cond) && ([side _this, ((crew _target) select 0) getVariable ""G_Side""] call BIS_fnc_areFriendly) && !(_target getVariable ""G_isRenegade"") && (count(_target nearEntities [%1, 7]) != 0))", G_Revive_Load_Types]]; 
	_unit setUserActionText [_loadActionID, format["<t color='%1'>Load Into Vehicle</t>", G_Revive_Action_Color], "", "<img image='\A3\ui_f\data\igui\cfg\actions\unloadIncapacitated_ca.paa' size='3' shadow='2'/>"];
	private _dragActionID = _unit addAction [format["<t color='%1'>Drag</t>", G_Revive_Action_Color], G_fnc_actionDrag, [], 10.8, true, true, "", "(([_target, _this, 2.45] call G_fnc_Revive_Actions_Cond) && ((eyePos _target select 2) > 0))"];
	private _carryActionID = _unit addAction [format["<t color='%1'>Carry</t>", G_Revive_Action_Color], G_fnc_actionCarry, [], 10.8, true, true, "", "(([_target, _this, 2.45] call G_fnc_Revive_Actions_Cond) && ((eyePos _target select 2) > 0))"];
};

//Create server-side function for easier init of enabled systems on AI created post-init
G_fnc_initNewAI = {
	//Local to server
	if (!G_isServer) exitWith {};
	private _arrayNewAI = _this;
	//If param is not an array, it is single object, so make it array
	if !(_arrayNewAI isEqualType []) then {
		_arrayNewAI = [_arrayNewAI];
	};
	//Init systems
	{
		[_x] remoteExec ["G_fnc_EH", 0, true];
	} forEach _arrayNewAI;
};

//Define function to create revive-oriented AI behavior
G_fnc_Revive_AI_Behavior = {
	//_unit is local
	params ["_unit"];
	//bug - is true the right condition here?
	while {true} do {
		//Wait for AI to be local
		waitUntil {sleep 5; (local _unit)};
		//Wait to be called upon as reviver or guard
		waitUntil {sleep 5; (((_unit getVariable "G_AI_rescueRole") select 0) != 0)};
		//Execute appropriate behavior up to and including completing revive or guard function
		private _rescueRoleArray = _unit getVariable "G_AI_rescueRole";
		private _victim = (_unit getVariable "G_AI_rescueRole") select 1;
		private _rescuerVehicle = vehicle _unit;
		//Allow AI to move more freely to victim, but still detect and engage enemies
		_unit setBehaviour "SAFE";
		_unit disableAI "TARGET";
		_unit disableAI "SUPPRESSION";
		_unit disableAI "AUTOCOMBAT";
		//Determine assigned role
		if ((_rescueRoleArray select 0) == 1) then {
			//AI is reviver
			//Cycle behavior as long as victim is incapacitated and rescuer is not, and rescuer has role
			private _distCount = 0;
			while {((!(_unit getVariable "G_Incapacitated")) && (alive _unit) && (_victim getVariable "G_Incapacitated") && (alive _victim) && ((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))} do {
				//Prevent AI from stopping
				//bug - is this stop necessary?
				_unit stop false;
				//Have regrouped AI move to victim
				_unit doMove (getPos _victim);
				//Have stopped AI move to victim
				_unit moveTo (getPos _victim);
				//Handle reviver in vehicle
				if ((vehicle _unit) != _unit) then {
					_rescuerVehicle = vehicle _unit;
					if (((_unit distance _victim) < 30) && ((speed _unit) < 1)) then {
						//Reviver vehicle is stopped near victim, so disembark
						//Order unit to be out of vehicle
						unassignVehicle _unit;
						//Manually remove unit from vehicle
						moveOut _unit;
					};
				};
				//Handle victim in vehicle
				if ((vehicle _victim != _victim) && ((_unit distance _victim) < 6)) then {
					//Victim's vehicle is nearby, so unload them
					[vehicle _victim, "", "", [_victim]] spawn G_fnc_actionUnload;
				};
				//Fix for AI getting "stuck" near objects or unable to reach victim:
				//If close and eligible, add a point until it has been long enough, then setPos to victim
				if ([_victim, _unit, 7] call G_fnc_Revive_Actions_Cond) then {
					_distCount = _distCount + 1;
				};
				if (_distCount > 6) then {
					_unit setPos (getPos _victim);
				};
				//If in range, perform revive action
				if ([_victim, _unit, 2.45] call G_fnc_Revive_Actions_Cond) then {
					[_victim, _unit] spawn G_fnc_actionRevive;
					//Wait for revive to end one way or another
					waitUntil {sleep 0.05; ((_unit getVariable "G_Incapacitated") || (!(_victim getVariable "G_Incapacitated")) || (!((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray)))};
				};
				sleep 2;
			};
		}
		else
		{
			//AI is guard
			//Cycle behavior as long as victim is incapacitated and rescuer is not, and rescuer has role
			while {((!(_unit getVariable "G_Incapacitated")) && (_victim getVariable "G_Incapacitated") && ((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))} do {
				//Prevent AI from stopping
				//bug - is this stop necessary?
				_unit stop false;
				//Have regrouped AI move to victim
				_unit doMove (getPos _victim);
				//Have stopped AI move to victim
				_unit moveTo (getPos _victim);
				//Handle guard in vehicle
				if ((vehicle _unit) != _unit) then {
					_rescuerVehicle = vehicle _unit;
					if (((_unit distance _victim) < 30) && ((speed _unit) < 1) && ((gunner vehicle _unit) != _unit)) then {
						//Guard vehicle is stopped near victim and guard is not gunner, so disembark
						//Order unit to be out of vehicle
						unassignVehicle _unit;
						//Manually remove unit from vehicle
						moveOut _unit;
					};
				};
				//If in range, start guarding
				if (_unit distance _victim < 10) then {
					//Have regrouped AI reset move
					_unit doMove (getPos _unit);
					//Have stopped AI reset move
					_unit moveTo (getPos _unit);
					//Increase awareness
					//bug - this changes behavior of entire group, which could have adverse effects
					_unit setBehaviour "AWARE";
					//Stop loop to allow "patrol"
					waitUntil {sleep 0.1; ((_unit getVariable "G_Incapacitated") || (!(_victim getVariable "G_Incapacitated")) || (!((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray)))};
				};
				sleep 2;
			};
		};
		
		//Wait for rescue role variable to adjust (could be up to 5 seconds based on rescuer selection script)
		waitUntil {sleep 0.1; (!((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))};

		//If no longer assigned a rescue role, resume previous behavior
		if (((_unit getVariable "G_AI_rescueRole") select 0) == 0) then {
			//Return to default behavior
			_unit enableAI "TARGET";
			_unit enableAI "SUPPRESSION";
			_unit enableAI "AUTOCOMBAT";
			_unit setBehaviour "AWARE";
			//Make sure unit is still unassigned before regrouping if not a leader
			if ((leader _unit) != _unit) then {
				//Leave then rejoin group to "reset", which doFollow does not accomplish if in player-commanded "Stop"
				private _oldGrp = group _unit;
				[_unit] joinSilent grpNull;
				[_unit] joinSilent _oldGrp;
				//Allow time to catch up
				sleep 0.1;
			};
			//Handle getting back into previous vehicle if applicable or if not already in it
			if (_rescuerVehicle != vehicle _unit) then {
				//If rescuer is up and their vehicle is alive and nearby, try to get back in
				if (!(_unit getVariable "G_Incapacitated") && (alive _unit) && (alive _rescuerVehicle) && ((_rescuerVehicle distance _unit) < 40)) then {
					//Have regrouped AI move to vehicle
					_unit doMove (getPos _rescuerVehicle);
					//Have stopped AI move to vehicle
					_unit moveTo (getPos _rescuerVehicle);
					//Wait for unit to be close, the vehicle to be dead, or time to run out
					private _toVehTimer = time;
					waitUntil {sleep 1; (((_rescuerVehicle distance _unit) < 8) || (!alive _rescuerVehicle) || ((time - _toVehTimer) > 30))};
					//Check if able to enter vehicle
					if (((_rescuerVehicle distance _unit) < 8) && (alive _rescuerVehicle)) then {
						//Attempt to enter as Driver
						if ((_rescuerVehicle emptyPositions "Driver") > 0) exitWith {
							_unit assignAsDriver _rescuerVehicle;
							_unit action ["getInDriver", _rescuerVehicle];
						};
						//Attempt to enter as Gunner
						if ((_rescuerVehicle emptyPositions "Gunner") > 0) exitWith {
							_unit assignAsGunner _rescuerVehicle;
							_unit action ["getInGunner", _rescuerVehicle];
						};
						//Attempt to enter as Commander
						if ((_rescuerVehicle emptyPositions "Commander") > 0) exitWith {
							_unit assignAsCommander _rescuerVehicle;
							_unit action ["getInCommander", _rescuerVehicle];
						};
						//Attempt to enter as Cargo
						if ((_rescuerVehicle emptyPositions "Cargo") > 0) exitWith {
							_unit assignAsCargo _rescuerVehicle;
							_unit action ["getInCargo", _rescuerVehicle];
						};
					};
				};
			};
			//Regroup to squad leader
			if ((leader _unit) != _unit) then {
				_unit doFollow (leader _unit);
			};
		};
	};
};

//Define function that handles Load/Unload of player
G_fnc_moveInCargoToUnloadAction = {
	params ["_unit", "_vehicle"];
	
	if (local _unit) then {
		[_unit, _vehicle] spawn {
			params ["_unit", "_vehicle"];
			//Command AI to stay in vehicle
			_unit assignAsCargo _vehicle;
			//Move unit into vehicle
			_unit moveInCargo _vehicle;
			//Wait for unit to be in vehicle before executing animation to prevent wrong animation
			waitUntil {sleep 0.1; (vehicle _unit != _unit)};
			//Perform Incapacitated animation manually due to lack of setUnconscious support in vehicle
				//This should have global effect, but does not, so it is here and broaadcasted
			[_unit, "Unconscious"] remoteExec ["playAction", 0, true];
		};
	};

	//Add Unload action for unit to vehicle
	private _unloadActionID = _vehicle addAction [format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], G_fnc_actionUnload, [_unit], 10.9, true, true, "", "([side _this, side _target] call BIS_fnc_areFriendly) && ((_target distance _this) < 5) && ((speed _target) < 1)"];
	_vehicle setUserActionText [_unloadActionID, format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], "", "<img image='\A3\ui_f\data\igui\cfg\actions\unloadIncapacitated_ca.paa' size='3' shadow='2'/>"];
	
	//Create parallel loop to handle Unload action if unit dies, and also if no longer loaded
	[_unit, _vehicle, _unloadActionID] spawn {
		params ["_unit", "_vehicle", "_unloadActionID"];
		//Wait for unit to be unloaded or no longer incapacitated
		waitUntil {sleep 0.3; ((vehicle _unit != _vehicle) || (isNull (_unit getVariable "G_Loaded")) || (!(_unit getVariable "G_Incapacitated")))};
		
		//Remove the Unload action from the vehicle
		_vehicle removeAction _unloadActionID;
		
		//Handle BIS Revive's Unload action
		//Allow animation to set to prevent other animation executing too early
		sleep 3;
		
		//Make sure unit is not loaded and broadcast
		if (local _unit) then {
			if (!isNull (_unit getVariable "G_Loaded")) then {
				//BIS Revive's Unload action was used
				_unit setVariable ["G_Loaded", objNull, true];
			};
		};
	};
};

G_fnc_menWithinRadius = {
	params ["_centerObj", "_radius"];
	//Get array of all alive men and appropriate vehicles within defined radius of center object
	private _arrayAll = _centerObj nearEntities [["Man", "Car", "Tank", "Helicopter", "Plane", "Ship"], _radius];
	//Cycle through all objects and find the men to add to array of men to be returned
	private _arrayReturn = [];
	{
		//_x is object
		//Determine how to handle alive object
		if (_x isKindOf "Man") then {
			//Object is man, add to array
			_arrayReturn pushBack _x;
		}
		else
		{
			//Object is vehicle
			//Cycle through crew to pick out man
			{
				//_x is crew member
				//Make sure crew member is alive
				if (alive _x) then {
					//Crew member is alive, add to array
					_arrayReturn pushBack _x;
				};
			} forEach crew _x;
		};
	} forEach _arrayAll;
	_arrayReturn;
};

//Define player-only incapacitation dialog
if (G_isClient) then {
	//Define function for "nearest rescuer" text
	G_fnc_Dialog_Rescuer_Text = {
		[_this select 0] spawn {
			//Continue cycling while player is incapacitated and dialog is open
			while {((player getVariable "G_Incapacitated") && (dialog))} do {
				//Get array of all "men" within 500m, including player and dead bodies
				private _arrayDistance = [];
				{
					//Select unit that is not player, is friendly, can revive (or setting undefined), is alive, and is not incapacitated
					if ((_x != player) && ([side _x, player getVariable "G_Side"] call BIS_fnc_areFriendly) && !(player getVariable "G_isRenegade") && (((typeOf _x) in G_Revive_Can_Revive) || ((count G_Revive_Can_Revive) == 0)) && (alive _x) && !(_x getVariable "G_Incapacitated")) then {
						//Add to array with distance from player
						_arrayDistance pushBack ([_x, ceil(_x distance player)]);
					};
				} forEach ([player, 500] call G_fnc_menWithinRadius);
				
				//Define empty variables for unit names
				private _unit0 = "";
				private _unit1 = "";
				private _unit2 = "";
				private _unit3 = "";
				private _unit4 = "";
				
				//Define unit variables with unit name and distanace if available
				for "_i" from 0 to (((count _arrayDistance) - 1) min 4) do {
					call compile format["_unit%1 = format[""%2  (%3m)"", name (_arrayDistance select %1 select 0), _arrayDistance select %1 select 1];", _i, "%1", "%2"];
				};
				
				//Format text to be displayed
				private _text = format["\n     Nearest Potential Rescuers:\n     %1\n     %2\n     %3\n     %4\n     %5", _unit0, _unit1, _unit2, _unit3, _unit4];
				//Output nearest rescuers
				((_this select 0) displayCtrl 1001) ctrlSetText _text;
				//Update list every 5 seconds
				sleep 10;
			};
		};
	};
	
	//Define function for "downs/lives remaining" text
	G_fnc_Dialog_Downs_Text = {
		private ["_downs", "_lives"];
		//If downs-per-life is limited, display remaining, otherwise text
		if (G_Revive_DownsPerLife > 0) then {
			//Subtract accrued number of downs from the limit to obtain remainder
			_downs = G_Revive_DownsPerLife - (player getVariable "G_Downs");
		}
		else
		{
			_downs = "Unlimited";
		};
		
		//If number of lives is limited, display remaining, otherwise text
		if (G_Num_Respawns == -1) then {
			_lives = "Unlimited";
		}
		else
		{
			_lives = player getVariable "G_Lives";
		};
		//Format text to be displayed
		private _text = format["\n\n            Downs Remaining: %1\n            Lives Remaining: %2", _downs, _lives];
		//Display the "lives remaining" dialog"
		((_this select 0) displayCtrl 1002) ctrlSetText _text;
	};
};

//Define player-only function for 3D Icon EH for incapacitated units if enabled
if (G_isClient && (difficultyOption "groupIndicators" != 0)) then {
	G_fnc_Incapacitated3DIcon = {
		//Create EH that Draws an icon on incapacitated units each frame
		addMissionEventHandler ["Draw3D", {
			//If player is Renegade, no teammates, so no need to draw
			if (player getVariable "G_isRenegade") exitWith {};
			//Get player's permanent side
			private _playerSide = player getVariable "G_Side";
			private _playerGroup = group player;
			//Cycle through all living units
			{
				//Check if unit is using revive system and not self
				if ((!isNil {_x getVariable "G_Side"}) && (_x != player)) then {
					//Revive-enabled unit, so check if within group marker range
					if ((_x distance player) < 175) then {
						//Close enough, so check if unit is friendly and incapacitated
						if (([_playerSide, _x getVariable "G_Side"] call BIS_fnc_areFriendly) && !(_x getVariable "G_isRenegade") && (_x getVariable "G_Incapacitated")) then {
							//Default to circular icon
							private _icon = "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\u100_ca.paa";
							//If in player's group, use hexagonal icon
							if (group _x == _playerGroup) then {
								_icon = "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\u100_ca.paa";
							};
							//Set alpha based on stock (175,0), (150,1) and y=mx+b
							private _alpha = -0.04*(_x distance player) + 7;
							//Eligible, so draw icon matching the stock version
							drawIcon3D [_icon, [1,1,1,_alpha], visiblePosition _x, 1.4, 1.4, 0, "", 2];
						};
					};
				};
			} forEach allUnits;
		}];
	};
};

//Define player-only function for addon radio handling
if (G_isClient) then {
	//Determine if using TFAR or ACRE2
	if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
		//Define function to handle TFAR
		G_fnc_muteAddonRadio = {
			//_this select 0 is local player
			//Check if muting or unmuting
			if (_this select 0) then {
				if (G_Revive_addonRadio_muteReceive) then {
					//Save current volume
					player setVariable ["G_save_tf_globalVolume", player getVariable ["tf_globalVolume", 1]];
					//Mute local radio volume
					player setVariable ["tf_globalVolume", 0], true;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Prevent transmission
					player setVariable ["tf_unable_to_use_radio", true, true];
				};
			}
			else
			{
				if (G_Revive_addonRadio_muteReceive) then {
					//Resume previous volume
					player setVariable ["tf_globalVolume", player getVariable ["G_save_tf_globalVolume", 1], true];
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Allow transmission
					player setVariable ["tf_unable_to_use_radio", false, true];
				};
			};
		};
	}
	else
	{
		//Define function to handle ACRE2
		G_fnc_muteAddonRadio = {
			//_this select 0 is local player
			//Check if muting or unmuting
			if (_this select 0) then {
				if (G_Revive_addonRadio_muteReceive) then {
					//Save current volume
					player setVariable ["G_save_acreVolume", [] call acre_api_fnc_getGlobalVolume];
					//Mute radio volume
					[0] call acre_api_fnc_setGlobalVolume;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Prevent transmission
					player setVariable ["acre_sys_core_isDisabled", true, true];
				};
			}
			else
			{
				if (G_Revive_addonRadio_muteReceive) then {
					//Resume previous volume
					[player getVariable ["G_save_acreVolume", 1]] call acre_api_fnc_setGlobalVolume;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Allow transmission
					player setVariable ["acre_sys_core_isDisabled", false, true];
				};
			};
		};
	};
};

//Define server-only function for checking if all units on a side are down
if (G_isServer) then {
	//Prevent duplication of checks/actions
	G_serverCheckingEnd = false;
	G_fnc_serverCheckEndMission = {
		params ["_unit"];
		
		//Quick check to see if unit has respawns remaining, and if so, no need to do full check
		if ((_unit getVariable "G_Lives") > 0) exitWith {};
		//This unit is out of the fight or close to it, so see about the side in a full check
		
		//Prevent duplication of checks/actions
		if (G_serverCheckingEnd) exitWith {};
		G_serverCheckingEnd = true;
		
		//Get side to check status on
		_side = _unit getVariable "G_Side";
		
		//Create array of units remaining on subject side
		private _sideUnitsRemaining = [];
		{
			//Only check based on units running scripts
			if (!isNil {_x getVariable "G_Side"}) then {
				//Check if unit is friendly
				if ([_x getVariable "G_Side", _side] call BIS_fnc_areFriendly) then {
					//Check if unit is dead and nonrespawnable
					if ((lifeState _x) == "DEAD") exitWith {};
					//Check if incapacitated unit is able to respawn
					if (((lifeState _x) == "INCAPACITATED") && ((_x getVariable "G_Lives") == 0)) exitWith {};
					//Add eligible unit 
					_sideUnitsRemaining pushback _x;
				};
			};
		} forEach (allUnits + allDeadMen);
		
		//If no friendly units remain, end the game for that side and see if game is over
		if ((count _sideUnitsRemaining) == 0) then {
			//Allow some time for failure to sink in
			sleep 10;
			//End mission locally for appropriate side
			["END1", false] remoteExec ["BIS_fnc_endMission", _side, false];
			
			//Check if anyone else is fighting
			private _stillFighting = true;
			//Create baseline array of all sides
			private _listSides = [WEST, EAST, RESISTANCE, CIVILIAN];
			//Remove the side that just lost
			_listSides = _listSides - [_side];
			//Remove any sides without players on them
			{
				if ((_x countSide (allPlayers - entities "HeadlessClient_F")) == 0) then {
					_listSides = _listSides - [_x];
				};
			} forEach _listSides;
			switch (count _listSides) do {
				case 0: { 
					//If no other sides have players, no one is fighting
					_stillFighting = false;
				};
				case 1: { 
					//If one other side has players, they have won
					//bug - what if they are fighting an AI side?
					_stillFighting = false;
				};
				case 2: { 
					//If two other sides have players, there may be fighting
					//If the two sides are friendly, they have won
					//bug - what if they are fighting an AI side?
					if ([_listSides select 0, _listSides select 1] call BIS_fnc_areFriendly) then {
						_stillFighting = false;
					};				
				};
				case 3: { 
					//If three other sides have players, there may be fighting (but only among players)
					//If the three sides are friendly, they have won
					if (([_listSides select 0, _listSides select 1] call BIS_fnc_areFriendly) && ([_listSides select 0, _listSides select 2] call BIS_fnc_areFriendly) && ([_listSides select 1, _listSides select 2] call BIS_fnc_areFriendly)) then {
						_stillFighting = false;
					};	
				};
			};
			
			//Handle ending if no one is fighting
			if !(_stillFighting) then {
				//Remaining sides, if any, win
				{
					["END1", true] remoteExec ["BIS_fnc_endMission", _x, false];
				} forEach _listSides;
				
				//Handle ending on dedicated server to ensure mission end
				if (G_isDedicated) then {
					[] spawn {
						sleep 30;
						forceEnd;
						endMission "END1";
					};
				};
				
				//Wait through end of game
				sleep 40;
			};
		};
		
		//Force delay between checking to avoid duplication
		sleep 10;
		G_serverCheckingEnd = false;
	};
};