//Carry
//Local to _rescuer
params ["_unit", "_rescuer"];

//Set carry-related variables and broadcast
_unit setVariable ["G_Carried", true, true];
_rescuer setVariable ["G_Carrying", true, true];

//Make unit's head farthest from rescuer for sake of the animation
[_unit, (getDir _rescuer) + 180] remoteExecCall ["setDir", _unit, false];

//Prepare for lift
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["playMoveNow", 0, false];
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["switchMove", 0, false];
[_unit, "AidlPpneMstpSnonWnonDnon_AI"] remoteExecCall ["switchMove", 0, false];
//Begin lift
[_unit, "AinjPfalMstpSnonWnonDf_carried_dead"] remoteExecCall ["playMoveNow", 0, false];

//Slight delay before rescuer animation starts
sleep 2;

//Start rescuer's lift
[_rescuer, "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, false];

//Wait for unit's animation to be set
waitUntil {animationState _unit == "AinjPfalMstpSnonWnonDf_carried_dead"};

//Attach unit to rescuer
_unit attachTo [_rescuer, [-0.2, 0.25, 0]];

//Create drop action
private _dropActionID = _rescuer addAction [format["<t color='%1'>Drop</t>", G_Revive_Action_Color], G_fnc_actionDrop, _unit, 10.8, true, true, ""];

//Wait for Drop or someone to die
waitUntil {sleep 0.1; (!(_unit getVariable "G_Carried") || !(alive _unit) || (_rescuer getVariable "G_Incapacitated"));};  

//If unit or rescuer died, handle in Drop function
if ((!alive _unit) || (!(_unit getVariable "G_Incapacitated")) || (_rescuer getVariable "G_Incapacitated")) then {
	[_rescuer, "", _dropActionID, _unit] spawn G_fnc_actionDrop;
};