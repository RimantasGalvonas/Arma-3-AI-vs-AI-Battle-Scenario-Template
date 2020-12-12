//Drop (from Carry or Drag)
//Local to _rescuer

private _rescuer = _this select 0;
private _dropActionID = _this select 2;
private _unit = _this select 3;

//Remove Drop action
_rescuer removeAction _dropActionID;

//Handle drop from Drag or Drop
if (_unit getVariable "G_Dragged") then {
	//From Drag
	if (_rescuer getVariable "G_Incapacitated") then {
		//Rescuer was incapacitated, so set both as incapacitated
		[_rescuer, "UnconsciousFaceDown"] remoteExec ["switchMove", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
	}
	else
	{
		//Rescuer animation to lower down to ground
		[_rescuer, "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMove", 0, true];
		//bug - I'd like to use these, but they don't seem to work right
		//[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["playMoveNow", 0, true];
		//[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["switchMove", 0, true];
		//Unit animation to return to incapacitated animation
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
	};
	//Detach unit from rescuer
	detach _unit;
	//Allow time for animations to set
	sleep 3;
	//Reset Drag-related variables
	_unit setVariable ["G_Dragged", false, true];
	_rescuer setVariable ["G_Dragging", false, true];
}
else
{
	//From Carry
	if (_rescuer getVariable "G_Incapacitated") then {
		//Rescuer was incapacitated, so set both as incapacitated
		[_rescuer, "UnconsciousFaceDown"] remoteExec ["switchMove", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
		//Allow time for animations to set
		//bug - is this necessary? Why not sleep for both?
		sleep 4;
	}
	else
	{
		if ((!alive _unit) || (!(_unit getVariable "G_Incapacitated"))) then {
			//Unit died, reset rescuer animation
			[_rescuer, ""] remoteExec ["switchMove", 0, true];
		}
		else
		{
			//Unit still alive
			//Rescuer animation to lower to ground from carry
			[_rescuer, "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
			//Unit animation of being lowered to ground from carry
			[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["playMoveNow", 0, true];
			[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["switchMove", 0, true];
			//Allow time for animations to set
			//bug - is this necessary?
			sleep 5;
			//Unit animation to return to incapacitated animation
			[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
			[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
		};
	};

	//Detach unit from rescuer
	detach _unit;
	//Reset Carry-related variables
	_unit setVariable ["G_Carried", false, true];
	_rescuer setVariable ["G_Carrying", false, true];
};