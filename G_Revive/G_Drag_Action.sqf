//Drag
//Local to _rescuer
params ["_unit", "_rescuer"];

//Set carry-related variables and broadcast
_unit setVariable ["G_Dragged", true, true];
_rescuer setVariable ["G_Dragging", true, true];

//Rescuer animation to reach down and lift up
[_rescuer, "AcinPknlMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, false];

//Victim animation to be lifted up
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["playMoveNow", 0, false];
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["switchMove", 0, false];

//Attach unit to rescuer
_unit attachTo [_rescuer, [0, 1.1, 0.05]];
//Orient unit to be set appropriately
[_unit, 180] remoteExecCall ["setDir", _unit, false];

//Create drop action
private _dropActionID = _rescuer addAction [format["<t color='%1'>Drop</t>", G_Revive_Action_Color], G_fnc_actionDrop, _unit, 10.8, true, true, ""];

//Temp fix for stuck due to combat pace
//Detect lack of movement and provide notice
if (isPlayer _rescuer) then {
	private _startPos = getPos _rescuer;
	[_rescuer, _startPos] spawn {
		params ["_rescuer", "_startPos"];
		sleep 5;
		if ((_rescuer distance _startPos) < 2) then {
			titleText [format["Exit Combat Pace via %1", (actionKeysNamesArray "TactToggle") select 0], "PLAIN", 1]; 
			sleep 1; 
			titleFadeOut 4;
		};
	};
};

//Wait for Drop or someone to die
waitUntil {sleep 0.1; (!(_unit getVariable "G_Dragged") || !(alive _unit) || (_rescuer getVariable "G_Incapacitated"));};  

//If unit or rescuer died, handle in Drop function
if ((!alive _unit) || (!(_unit getVariable "G_Incapacitated")) || (_rescuer getVariable "G_Incapacitated")) then {
	[_rescuer, "", _dropActionID, _unit] spawn G_fnc_actionDrop;
};