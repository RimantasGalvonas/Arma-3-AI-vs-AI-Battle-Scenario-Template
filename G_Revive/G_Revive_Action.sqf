//Reviver
//Local to _rescuer
params ["_unit", "_rescuer"];

//Handle First Aid Kit (FAK) requirement if enabled
	//Only for players here because an AI would have already done this
private _hasItem = 0;
if ((isPlayer _rescuer) && (G_Revive_Requirement > 0)) then {
	//1 or more FAK, or Medikit, is required
	//Get array of rescuer's items
	private _rescitemsArray = items _rescuer;
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

//If FAK requirement is enabled and not achieved, exit with error message and reset variables
	//Only for players here because an AI would have already done this
if ((isPlayer _rescuer) && (G_Revive_Requirement > 0) && (_hasItem < G_Revive_Requirement)) exitWith {
	titleText [format["You require either %2 First Aid Kit(s) or a single Medikit to revive %1!", name _unit, G_Revive_Requirement], "PLAIN", 1]; 
	sleep 1; 
	titleFadeOut 4;
};

//Set and broadcast Revive variables
_rescuer setVariable ["G_Reviving", _unit, true];
_unit setVariable ["G_Reviver", _rescuer, true];

//Revive announcement for rescuer
//bug - add progress of some sort?
if (isPlayer _rescuer) then {
	titleText [format["You are reviving %1! This will take %2 seconds!", name _unit, G_Revive_actionTime], "PLAIN", 1]; 
	titleFadeOut 5;
};

//Handle revive abort for players
if (isPlayer _rescuer) then {
	//Common fix before displayAddEH
	waitUntil {!isNull (findDisplay 46)};
	//Define KeyDown EH for abort upon any key stroke
	//bug - rename to something useful?
	//bug - does it need to be global?
	G_Revive_Global_KeyDown_EH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		//Remove this EH (so only happens once)
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", G_Revive_Global_KeyDown_EH];
		//Obtain unit from player's object
		_unit = player getVariable "G_Reviving";
		//Reset revive action variables
		player setVariable ["G_Reviving", objNull, true];
		_unit setVariable ["G_Reviver", objNull, true];
		//Announce revive abort
		titleText [format["You have aborted the revive process of %1!", name _unit], "PLAIN", 1]; 
		titleFadeOut 5;
	}];  
}; 

//Define what game time revive action should be completed
private _endTime = time + G_Revive_actionTime;
//Until the end time is reached, make sure the revive animation continues to play as long as revive is not aborted and nobody is incapacitated/killed
while {(time < _endTime) && (!isNull (_rescuer getVariable "G_Reviving")) && (alive _unit) && (!(_rescuer getVariable "G_Incapacitated")) && (alive _rescuer)} do {
	//Execute revive animation
	[_rescuer, "AinvPknlMstpSnonWrflDr_medic3"] remoteExec ["playMoveNow", 0, false];
	//Wait for revive animation to be set
	waitUntil {sleep 0.05; ((animationState _rescuer) == "AinvPknlMstpSnonWrflDr_medic3")};
	//Wait for revive animation to be finished, abort, or something happens
	waitUntil {sleep 0.05; (!(time < _endTime) || (isNull (_rescuer getVariable "G_Reviving")) || (!alive _unit) || (_rescuer getVariable "G_Incapacitated") || (!alive _rescuer) || ((animationState _rescuer) != "AinvPknlMstpSnonWrflDr_medic3"))};
};

//Wait for revive timer or abort
//bug - is this not always true here?
waitUntil {sleep 0.1; (!(time < _endTime) || (isNull (_rescuer getVariable "G_Reviving")) || (!alive _unit) || (_rescuer getVariable "G_Incapacitated") || (!alive _rescuer))};
//Either way, reset reviver animation to kneeling position to prevent revive animation cycling
[_rescuer, "AmovPknlMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
[_rescuer, "AmovPknlMstpSrasWrflDnon"] remoteExecCall ["switchMove", 0, true];

//Make sure KeyDown EH is removed
if (isPlayer _rescuer) then {
	(findDisplay 46) displayRemoveEventHandler ["KeyDown", G_Revive_Global_KeyDown_EH];
};

//Exit if revive was aborted, the victim died, or the rescuer was incapacitated
if ((isNull (_rescuer getVariable "G_Reviving")) || (!alive _unit) || (_rescuer getVariable "G_Incapacitated") || (!alive _rescuer)) exitWith {
	//Reset revive action variables
	_rescuer setVariable ["G_Reviving", objNull, true];
	_unit setVariable ["G_Reviver", objNull, true];
};

//Revive action was successful
//Reset variables
_unit setVariable ["G_Incapacitated", false, true];
_rescuer setVariable ["G_Reviving", objNull, true];
//_unit's "G_Reviver" is reset with abort or later after its use in G_Incapacitated

//Handle revive announcement depending on use of life rewarding system
//Obtain number of lives (or determine if unlimited with -1)
private _lives = _rescuer getVariable "G_Lives";
if ((_lives >= 0) && (G_Revive_Reward > 0)) then {
	//Limited lives
	//+1 to life count
	_lives = _lives + G_Revive_Reward;
	//Announce revive success life count for players
	if (isPlayer _rescuer) then {
		//Determine plurality
		private _livesPlural = "lives";
		if (_lives == 1) then {
			_livesPlural = "life";
		};
		//Format and display text
		titleText [format["You have been rewarded an additional life for reviving %1! You have %2 %3 remaining!", name _unit, _lives, _livesPlural], "PLAIN", 1];
		titleFadeOut 4;
	};
	//Set new life count and broadcast
	_rescuer setVariable ["G_Lives", _lives, true];
}
else
{
	//Unlimited lives
	//Announce revive success for players
	if (isPlayer _rescuer) then {
		//Format and display text
		titleText [format["You have revived %1!", name _unit], "PLAIN", 1]; 
		titleFadeOut 4;
	};
};

//Handle First Aid Kit (FAK) requirement if enabled
if (G_Revive_Requirement > 0) then {
	//If has Medikit, no action, otherwise remove validated amount of FAKs
	if (!("Medikit" in (items _rescuer))) then {
		//No Medikit, so remove required number of FAKs
		for "_i" from 1 to G_Revive_Requirement do {
			_rescuer removeItem "FirstAidKit";
		};
	};
};