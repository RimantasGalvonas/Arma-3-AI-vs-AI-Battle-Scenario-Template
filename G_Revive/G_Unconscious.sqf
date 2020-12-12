//Handle incapacitated state
//Local to _unit
params ["_unit"];

//If the unit is already incapacitated or is not local to the executer, and is not JIP, exit
if (((_unit getVariable "G_Incapacitated") || !(local _unit)) && (!G_isJIP)) exitWith {};

//Prevent further damage/being killed
if (isDamageAllowed _unit) then {
	_unit allowDamage false;
};

//Broadcast incapacitated-state status and animation
_unit setUnconscious true;

//Prevent being further engaged by enemies
_unit setCaptive true;

//Prepare to add mock delay to revive actions to prevent animation failures
_unit setVariable ["G_Dragged", true, true];

//Set unit as incapacitated and broadcast
_unit setVariable ["G_Incapacitated", true, true];

//Add parallel delay to revive-related actions
[_unit] spawn {
	params ["_unit"];
	sleep 2.5;
	//Set unit as incapacitated and broadcast
	_unit setVariable ["G_Dragged", false, true];
};

private _bypass = false;
//Handle unit if inside vehicle
//If already Loaded, define vehicle that unit is in
private _vehicle = _unit getVariable "G_Loaded";
if ((vehicle _unit != _unit) || (!isNull _vehicle)) then {
	//Unit is incapacitated inside a vehicle
	//If not yet Loaded, define vehicle that unit is going incapacitated in
	if (isNull _vehicle) then {
		_vehicle = vehicle _unit;
	};
	
	//Check if vehicle is alive
	if (alive _vehicle) then {
		//Vehicle is alive
		//If incapacitated units should be ejected, handle accordingly
		if (G_Eject_Occupants) then {
			//Eject incapacitated unit
			//Order unit to be out of vehicle
			unassignVehicle _unit;
			//Manually remove unit from vehicle
			moveOut _unit;
			//Allow time for animation to get set
			sleep 1.5;
			//Allow more time for animation if coming from Air vehicle
			//bug - why?
			if (_vehicle isKindOf "Air") then {
				sleep 1.5;
			};
		}
		else
		{
			//Don't eject, so unit is already "Loaded", so set accordingly
			_unit setVariable ["G_Loaded", _vehicle, true];
			[_unit, _vehicle, side _unit] remoteExecCall ["G_fnc_moveInCargoToUnloadAction", 0, true];
		};
	}
	else
	{
		//Vehicle is destroyed
		//If eject on explosion is disabled, exit this scope and kill
		if (!G_Explosion_Eject_Occupants) exitWith {_bypass = true};
		//Eject on explosion is enabled, so eject
		//If in Air vehicle, wait for it to be nearly stopped and nearly crashed
		if (_vehicle isKindOf "Air") then {
			waitUntil {sleep 0.2; (((speed _vehicle) < 3) and (((getPos _vehicle) select 2) < 10))};
		};
		//Order unit to be out of vehicle
		unassignVehicle _unit;
		//Manually remove unit from vehicle
		moveOut _unit;
		//Wait for game to catch up
		sleep 1.5;
		//Allow more time for animation if coming from Air vehicle
		//bug - why?
		if (_vehicle isKindOf "Air") then {
			sleep 1.5;
		};
	};
}
else
{
	//Unit incapacitated outside vehicle, give time for ragdoll animation
	sleep 3;
};

//Handle bypassing Incapacitated based on downs per life, if applicable
//bug - consider putting somewhere higher between here and the HandleDamage EH
if (G_Revive_DownsPerLife > 0) then {
	//Limited number of downs
	//Add 1 to current down count
	private _downCount = (_unit getVariable "G_Downs") + 1;
	//Activate bypass if DownsPerLife is exceeded
	if (_downCount > G_Revive_DownsPerLife) exitWith {
		_bypass = true;
	};
	//Set new down count and broadcast
	_unit setVariable ["G_Downs", _downCount, true];
};

//If bypass is activated, set not Incapacitated, kill, and proceed to onKilled
if (_bypass) exitWith {
	_unit setVariable ["G_Loaded", objNull, true];
	_unit setVariable ["G_Incapacitated", false, true];
	_unit setDamage 1;
	//Add killed message for AI for consistency
	if ((!isPlayer _unit) && (G_Revive_Messages > 0)) then {
		_target = 0;
		if (G_Revive_Messages == 1) then {
			_target = _unit getVariable "G_Side";
		};
		[format["%1 was killed", name _unit]] remoteExec ["systemChat", _target, false];
	};
};

//Command server to check for all of a side being down/dead
[_unit] remoteExec ["G_fnc_serverCheckEndMission", 2, false];

//Handle addon radios if enabled
if ((isPlayer _unit) && (G_Revive_addonRadio_muteTransmit || G_Revive_addonRadio_muteReceive)) then {
	[true] spawn G_fnc_muteAddonRadio;
};

//Black out the screen with text for incapacitated player
if (isPlayer _unit) then {
	//Disable keyboard/mouse input
	disableUserInput true;
	//Black out the screen
	titleText ["","BLACK", 1]; 
	if (!G_Revive_Black_Screen) then {
		//Run in parallel because of suspension
		[] spawn {
			sleep 3;
			//Display incapacitated announcement text for a few seconds
			titleText ["You are Incapacitated. Wait for teammate to revive you.", "BLACK IN", 4]; 
		};
	};
};

//Create incapacitated dialog for player
if (isPlayer _unit) then {
	[_unit] spawn {
		params ["_unit"], 
		//Wait a few seconds before opening dialog
		sleep 3.25;
		while {(_unit getVariable "G_Incapacitated")} do {
			//Open dialog
			private _reviveDialog = createDialog "G_Revive_Dialog";
			if (!G_Allow_GiveUp) then {
				((findDisplay 474637) displayCtrl 1600) ctrlShow false;
			};
			//Wait for dialog to be open
			private _timeDialog = time + 5;
			waitUntil {sleep 1; ((!isNull (findDisplay 474637)) || (time > _timeDialog))};
			//Wait for dialog to be closed (by Escape)
			waitUntil {sleep 1; !dialog};
			//Give player time to access game menu before re-cycling
			sleep 5;
		};
	};
};

//Reenable keyboard/mouse input for player
if (isPlayer _unit) then {
	disableUserInput false;
};

//Prevent AI movement
_unit disableAI "MOVE";
//Prevent scripted AI responses (such as exiting immobile vehicle)
_unit disableAI "FSM";

//Custom execution
if (!isNil "G_fnc_Custom_Exec_1") then {
	[_unit] spawn G_fnc_Custom_Exec_1;
};

//Wait for game to catch up
//bug - why sleep here?
sleep 2.5;

//Execute AI tracking for AI's revive behavior
[_unit] spawn {
	params ["_unit"];
	//Cycle through AI role assignments as long as unit is incapacitated
	//bug - use of Call for Help concept, or keep it automatic?
	//By default, reviver and guard are unassigned
	private _aiReviver = objNull;
	private _aiGuard = objNull;
	while {(_unit getVariable "G_Incapacitated")} do {
		//Only cycle for AI help if on ground or in stopped vehicle
		while {((_unit getVariable "G_Incapacitated") && ((vehicle _unit == _unit) || (speed _unit < 1)))} do {
			//If aiReviver is assigned and incapacitated, unassign them
			if (!isNull _aiReviver) then {
				if ((_aiReviver getVariable "G_Incapacitated") || (!alive _aiReviver)) then {
					_aiReviver setVariable ["G_AI_rescueRole", [0, objNull], true];
					_aiReviver = objNull;
				};
			};
			//If aiGuard is assigned and incapacitated, unassign them
			if (!isNull _aiGuard) then {
				if ((_aiGuard getVariable "G_Incapacitated") || (!alive _aiGuard)) then {
					_aiGuard setVariable ["G_AI_rescueRole", [0, objNull], true];
					_aiGuard = objNull;
				};
			};
			
			//Obtain array of potential rescuers from men within a certain distance
			//Get array of all "men" within 500m, including player and dead bodies
			private _arrayPotentialRescuers = [];
			{
				//Select unit that is not the downed unit, is not a player, is friendly, is not already rescuing someone, is alive, and is not incapacitated
					//This system always runs with AI; players are not considered for roles
				if ((_x != _unit) && (!isPlayer _x) && ([side _x, _unit getVariable "G_Side"] call BIS_fnc_areFriendly) && !(_unit getVariable "G_isRenegade") && ((((_x getVariable "G_AI_rescueRole") select 0) == 0) || (((_x getVariable "G_AI_rescueRole") select 1) == _unit)) && (alive _x) && !(_x getVariable "G_Incapacitated")) then {
					//Add to array, ordered by distance ascending
					_arrayPotentialRescuers pushBack _x;
				};
			} forEach ([_unit, 500] call G_fnc_menWithinRadius);

			//Get slot for last potential rescuer
			private _arrayPotentialRescuersCount = (count _arrayPotentialRescuers) - 1;
			
			//Attempt to select closest (eligible) AI for reviver and broadcast variable so he comes
			{
				private _hasItem = 0;
				//Check if potential is eligible to revive based on setting; exit after code if they are the one
				if (((typeOf _x) in G_Revive_Can_Revive) || ((count G_Revive_Can_Revive) == 0)) then {
					//Unit able to revive
					//Handle First Aid Kit (FAK) requirement if enabled
					if (G_Revive_Requirement > 0) then {
						//1 or more FAK, or Medikit, is required
						//Get array of rescuer's items
						private _rescitemsArray = items _x;
						//Handle Medikit
						if ("Medikit" in (_rescitemsArray)) then {
							//Has Medikit, so meet requirement
							_hasItem = _hasItem + G_Revive_Requirement;
						};
						//Handle FAKs if no Medikit
						if (_hasItem < G_Revive_Requirement) then {
							//No Medikit, so cycle through array of items
							{
								//If item is FAK, +1 to count
								if (_x isEqualTo "FirstAidKit") then {
									if (_hasItem < G_Revive_Requirement) then {
										_hasItem = _hasItem + 1;
									};
								};
							} forEach _rescitemsArray;
						};
					};

					//If FAK requirement is enabled and not achieved, skip this unit
					if ((G_Revive_Requirement > 0) && (_hasItem < G_Revive_Requirement)) exitWith {};
					
					//Check if potential is different than current
					if (_aiReviver != _x) then {
						//Potential is different; check if is replacement or not
						if (isNull _aiReviver) then {
							//Initial reviver, so assign the role
							_aiReviver = _x;
							_x setVariable ["G_AI_rescueRole", [1, _unit], true];
						}
						else
						{
							//Possible replacement, make sure is reasonable before replacing
								//Must be 50m closer to victim than current assigned reviver
							if ((_aiReviver distance _unit) > ((_x distance _unit) + 30)) then {
								//Replace current reviver with new
								_aiReviver setVariable ["G_AI_rescueRole", [0, objNull], true];
								_aiReviver = _x;
								_x setVariable ["G_AI_rescueRole", [1, _unit], true];
							};
						};
						//If new reviver is coming from guard, unassign the guard role
						if (_aiReviver == _aiGuard) then {
							_aiGuard = objNull;
						};
					};
				};
				//If current reviver is not eligible, make sure aiReviver goes unassigned
				if ((_aiReviver == _x) && (G_Revive_Requirement > 0) && (_hasItem < G_Revive_Requirement)) exitWith {
					_aiReviver = objNull;
				};
				//If eligible and not replaced, keep current reviver
				if (_aiReviver == _x) exitWith {};
				//If by last option of potentials no one is selected, then make sure aiReviver goes unassigned
				if (_x == (_arrayPotentialRescuers select _arrayPotentialRescuersCount)) then {
					_aiReviver = objNull;
				};
			} forEach _arrayPotentialRescuers;
			
			//Attempt to select 2nd closest AI for guard and broadcast variable so he comes
			{
				//Check if potential is different than current
				if ((_aiGuard != _x) && (_aiReviver != _x)) then {
					//Potential is different; check if is replacement or not
					if (isNull _aiGuard) then {
						//Initial guard, so assign the role
						_aiGuard = _x;
						_x setVariable ["G_AI_rescueRole", [2, _unit], true];
					}
					else
					{
						//Possible replacement, make sure is reasonable before replacing
							//Must be 50m closer to victim than current assigned guard
						if ((_aiGuard distance _unit) > ((_x distance _unit) + 30)) then {
							//Replace current guard with new
							_aiGuard setVariable ["G_AI_rescueRole", [0, objNull], true];
							_aiGuard = _x;
							_x setVariable ["G_AI_rescueRole", [2, _unit], true];
						};
					};
				};
				//If eligible/nonexistent and not replaced, keep current guard
				if (_aiGuard == _x) exitWith {};
				//If by last option of potentials no one is selected, then make sure aiGuard goes unassigned
				if (_x == (_arrayPotentialRescuers select _arrayPotentialRescuersCount)) then {
					_aiGuard = objNull;
				};
			} forEach _arrayPotentialRescuers;

			//Wait magic amount of seconds before re-checking
			sleep 5;
		};
		
		//Unit no longer incapacitated, or vehicle is moving, so disregard any rescuing AI by resetting variables
		if (!isNull _aiReviver) then {
			_aiReviver setVariable ["G_AI_rescueRole", [0, objNull], true];
			_aiReviver = objNull;
		};
		if (!isNull _aiGuard) then {
			_aiGuard setVariable ["G_AI_rescueRole", [0, objNull], true];
			_aiGuard = objNull;
		};
		
		//Wait magic amount of seconds before re-checking if in vehicle
		sleep 10;
	};
};

private _bleedoutTimer = G_Revive_bleedoutTime;
//Check if bleedout timer is unlimited
if (_bleedoutTimer > -1) then {
	//Bleedout timer is limited
	//Cycle count in incapacitated state so long as unit is incapacitated, not timed out, is alive, and is still local to the executor
	//bug - why the local check? 
	while {(_unit getVariable "G_Incapacitated") && (_bleedoutTimer > 0) && (alive _unit) && (local _unit)} do 
	{
		//If unit is not currently being revived, count down
		if (isNull (_unit getVariable "G_Reviver")) then {
			_bleedoutTimer = _bleedoutTimer - 1;
		};
		//Handle vehicle if unit is in one
		private _breakOut = false;
		if (!isNull (_unit getVariable "G_Loaded")) then {
			//Unit in a vehicle
			private _vehicle = _unit getVariable "G_Loaded";
			if (!alive _vehicle) then {
				//Vehicle is destroyed
				if (G_Explosion_Eject_Occupants) then {
					//Eject on explosion is enabled, so eject
					//If in Air vehicle, wait for it to be nearly stopped and nearly crashed
					if (_vehicle isKindOf "Air") then {
						waitUntil {sleep 0.2; (((speed _vehicle) < 3) and (((getPos _vehicle) select 2) < 10))};
					};
					//Remove unit from vehicle
					_unit setVariable ["G_Loaded", objNull, true];
					//Wait for game to catch up
					sleep 1.5;
					//Allow more time for animation if coming from Air vehicle
					//bug - why?
					if (_vehicle isKindOf "Air") then {
						sleep 1.5;
					};
				}
				else
				{
					_breakOut = true;
				};
			};
		};
		if (_breakOut) exitWith {};
		//Show counter text for player
		if (isPlayer _unit) then {
			//Check environment only if black screen is disabled
			if (!G_Revive_Black_Screen) then {
				titleText [format["%1 seconds until bleedout, unless you are revived!", _bleedoutTimer],"PLAIN",1];
			}
			else
			{
				titleText [format["%1 seconds until bleedout, unless you are revived!", _bleedoutTimer],"BLACK FADED",1];
			};
		};
		sleep 1;
	};
}
else
{
	//Bleedout timer is unlimited
	//Cycle in incapacitated state so long as unit is incapacitated, is alive, and is still local to the executor
	//bug - why the local check?
	while {(_unit getVariable "G_Incapacitated") && (alive _unit) && (local _unit)} do 
	{
		//Handle vehicle if unit is in one
		private _breakOut = false;
		if (!isNull (_unit getVariable "G_Loaded")) then {
			//Unit in a vehicle
			private _vehicle = _unit getVariable "G_Loaded";
			if (!alive _vehicle) then {
				//Vehicle is destroyed
				if (G_Explosion_Eject_Occupants) then {
					//Eject on explosion is enabled, so eject
					//If in Air vehicle, wait for it to be nearly stopped and nearly crashed
					if (_vehicle isKindOf "Air") then {
						waitUntil {sleep 0.2; (((speed _vehicle) < 3) and (((getPos _vehicle) select 2) < 10))};
					};
					//Remove unit from vehicle
					_unit setVariable ["G_Loaded", objNull, true];
					//Wait for game to catch up
					sleep 1.5;
					//Allow more time for animation if coming from Air vehicle
					//bug - why?
					if (_vehicle isKindOf "Air") then {
						sleep 1.5;
					};
				}
				else
				{
					_breakOut = true;
				};
			};
		};
		if (_breakOut) exitWith {};
		sleep 0.2;
	};
};

//If unit no longer local, exit scope
//bug - why the local check?
if (!local _unit) exitWith {};
//No longer incapacitated, and still local

if (isPlayer _unit) then {
	//Close the incapacitated dialog
	closeDialog 0;
};

//Determine how to proceed based on status change
if ((_unit getVariable "G_Incapacitated") && ((isNull (_unit getVariable "G_Reviver")) || (!alive _unit) || (!isNull (_unit getVariable "G_Loaded")))) then {
	//Unit did not get revived (bleedout timer ran out, or Gave Up), is in exploded vehicle without ejection, or is dead
	//Remove from Incapacitated, and kill unit
	_unit setVariable ["G_Loaded", objNull, true];
	_unit setVariable ["G_Incapacitated", false, true];
	_unit setDamage 1;
	//Add killed message for AI for consistency
	if ((!isPlayer _unit) && (G_Revive_Messages > 0)) then {		
		_target = 0;
		if (G_Revive_Messages == 1) then {
			_target = _unit getVariable "G_Side";
		};
		[format["%1 was killed", name _unit]] remoteExec ["systemChat", _target, false];
	};
	if (isPlayer _unit) then {
		//If on black screen, bring back normal view
		if (G_Revive_Black_Screen) then {
			titleText ["", "BLACK IN", 1]; 
		};
	};
}
else
{
	//Unit was revived by rescuer or script
	//Set unit to full health
	//bug - Make option to have certain damage, requiring further treatment?
	_unit setDamage 0;
	//Remove from incapacitated-state
	_unit setUnconscious false;
	
	//If under water, must manually execute swimming animation
	if ((eyePos _unit select 2) < 0) then {
		//Below sea level
		//Cleanly move unit to swimming animation
		[_unit, "abswpercmstpsnonwnondnon"] remoteExecCall ["playMoveNow", 0, true];
	}
	else
	{
		//Above sea level
		//Fix from BIS_fnc_reviveOnState for being revived while having no weapon or binocular
		if ({currentWeapon _unit == _x} count ["", binocular _unit] > 0) then {
			[_unit] spawn {
				params ["_unit"];
				sleep 0.1;
				if ({currentWeapon _unit == _x} count ["", binocular _unit] > 0) then {
					[_unit, "Civil"] remoteExec ["playAction", 0, true];
				};
			};
		};
	};
	//Allow unit to be engaged by AI
	_unit setCaptive false;
	//Allow AI unit to move
	_unit enableAI "MOVE";
	//Allow scripted AI responses
	_unit enableAI "FSM";
	//Allow unit to take damage
	_unit allowDamage true;
	private _rescuer = _unit getVariable "G_Reviver";
	//If revived by script command, make rescuer self
	//bug - better way to do this?
	if (isNull _rescuer) then {
		_rescuer = _unit;
	};
	
	//Announce revive
	if (G_Revive_Messages > 0) then {
		_target = 0;
		if (G_Revive_Messages == 1) then {
			_target = _unit getVariable "G_Side";
		};
		[format["%1 was revived by %2", name _unit, name _rescuer]] remoteExec ["systemChat", _target, false];
	};
	
	//Display downs remaining for players
	if (isPlayer _unit) then {
		private _downsRemaining = G_Revive_DownsPerLife - (_unit getVariable "G_Downs");
		//Display text depending on use of down counter
		if (G_Revive_DownsPerLife > 0) then {
			//Limited number of downs
			private _downsPlural = "downs";
			if (_downsRemaining == 1) then {
				_downsPlural = "down";
			};
			//Display text depending on if black screen is enabled
			if (G_Revive_Black_Screen) then {
				titleText [format["You have been revived by %1! You have %2 %3 remaining!", name _rescuer, _downsRemaining, _downsPlural], "BLACK IN", 5]; 
			}
			else
			{
				titleText [format["You have been revived by %1! You have %2 %3 remaining!", name _rescuer, _downsRemaining, _downsPlural], "PLAIN", 1];
			};
		}
		else
		{
			//Unlimited downs
			//Display text depending on if black screen is enabled
			if (G_Revive_Black_Screen) then {
				titleText [format["You have been revived by %1!",name _rescuer],"BLACK IN", 5]; 
			}
			else
			{
				titleText [format["You have been revived by %1!",name _rescuer],"PLAIN",1];
			};
		};
	};
	
	//Custom execution
	if (!isNil "G_fnc_Custom_Exec_5") then {
		[_unit, _rescuer] spawn G_fnc_Custom_Exec_5;
	};
};

//Handle addon radios if enabled
if ((isPlayer _unit) && (G_Revive_addonRadio_muteTransmit || G_Revive_addonRadio_muteReceive)) then {
	[false] spawn G_fnc_muteAddonRadio;
};

//Reset Reviver variable
_unit setVariable ["G_Reviver", objNull, true];