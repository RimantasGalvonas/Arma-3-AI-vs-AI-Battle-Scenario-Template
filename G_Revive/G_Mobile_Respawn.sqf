//Mobile respawn
//Local to executor, not necessarily _MRV

//Define array of MRVs and associated side
private _MRV_Array = [[G_Mobile_Respawn_WEST, WEST], [G_Mobile_Respawn_EAST, EAST], [G_Mobile_Respawn_IND, RESISTANCE], [G_Mobile_Respawn_CIV, CIVILIAN]];

//Define functions for MRV action
G_fnc_MRV_Deploy_Action = {
	//MRV Deployment
	private _mobile = _this select 0;
	private _MRV_Logic = _this select 3 select 0;

	//Create respawn position
	private _mobileRespawnID = [_MRV_Logic getVariable "G_Side", _mobile] call BIS_fnc_addRespawnPosition;
	//Store respawn ID
	_mobile setVariable ["G_MRV_SpawnID", _mobileRespawnID, true];

	//Handle MRV if not movable
	if !(G_Mobile_Respawn_Movable) then {
		//Create empty helipad as anchor and position it on MRV
		private _anchor = "Land_HelipadEmpty_F" createVehicle (getPos _mobile);
		_anchor setDir (getDir _mobile); 
		//Sleep required to avoid MRV attaching to still-moving _anchor
		sleep 0.1;
		//Anchor the MRV to the helipad
		_mobile attachTo [_anchor];
	};

	//Set MRV as deployed for usage and marker handling
	_MRV_Logic setVariable ["G_MRV_Deployed", true, true];
};

//Create definition for Undeploy action
G_fnc_MRV_UnDeploy_Action = {
	private _mobile = _this select 0;
	private _MRV_Logic = _this select 3 select 0;
	//Obtain spawnID from object variable
	private _mobileRespawnID = _mobile getVariable "G_MRV_SpawnID";
	
	//Delete the MRV respawn position
	_mobileRespawnID call BIS_fnc_removeRespawnPosition; 

	//Detach and delete helipad anchor if used
	if !(G_Mobile_Respawn_Movable) then {
		private _anchor = attachedTo _mobile;
		detach _mobile;
		deleteVehicle _anchor;
	};
	
	//Mark MRV as Undeployed and broadcast
	_MRV_Logic setVariable ["G_MRV_Deployed", false, true];
};

//Define functions for common MRV action conditions
if (G_Revive_System) then {
	//Common conditions for action when revive is enabled
	G_fnc_MRV_Common_actionCondition = {
		params ["_target", "_this"];
		((alive _target) && ((_target distance _this) < 6) && (_target != _this) && !(_this getVariable "G_Dragged") && !(_this getVariable "G_Carried") && !(_this getVariable "G_Carrying") && !(_this getVariable "G_Dragging") && ([side _this, ((_target getVariable "G_MRV_Logic") getVariable "G_Side")] call BIS_fnc_areFriendly))
	};
}
else
{
	//Common conditions for action when revive is disabled
	G_fnc_MRV_Common_actionCondition = {
		params ["_target", "_this"];
		((alive _target) && ((_target distance _this) < 6) && (_target != _this) && ([side _this, ((_target getVariable "G_MRV_Logic") getVariable "G_Side")] call BIS_fnc_areFriendly))
	};
};

//Define functions for more specific MRV action conditions
if (G_Mobile_Respawn_Movable) then {
	//Deployed MRV is movable
	//Condition for Deploy action
	G_fnc_MRV_Deploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && !((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed"))
	};
	//Condition for UnDeploy action
	G_fnc_MRV_UnDeploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && ((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed"))
	};
}
else
{
	//Deployed MRV is not movable
	//Condition for Deploy action
	G_fnc_MRV_Deploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && !((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed") && ((speed _target) < 1) && ((speed _target) > -1))
	};
	//Condition for UnDeploy action
	G_fnc_MRV_UnDeploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && ((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed") && ((speed _target) < 1) && ((speed _target) > -1))
	};
};

//Define function for MRV init
//bug - Tried executing this only on MRV owner's machine, then remoteExecing the addActions, but nothing happened on all other clients because server execs before client loads and it never execs to client.
G_fnc_MRV_init = {
	params ["_side", "_MRV"];
	
	//Create an indvisible helipad to act as game logic for MRV identity to persist on
	//Define MRV-specific variables on game logic
	private ["_MRV_Logic"];
	if (local _MRV) then {
		_MRV_Logic = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
		_MRV_Logic setVariable ["G_MRV_Dir", getDir _MRV, true];
		_MRV_Logic setVariable ["G_MRV_Pos", getPos _MRV, true];
		_MRV_Logic setVariable ["G_MRV_Type", typeOf _MRV, true];
		_MRV_Logic setVariable ["G_Side", _side, true];
		_MRV_Logic setVariable ["G_MRV_Name", vehicleVarName _MRV, true];
		_MRV_Logic setVariable ["G_MRV_Deployed", false, true];
		_MRV setVariable ["G_MRV_Logic", _MRV_Logic, true];
	};
	
	//System variables only being defined on server, so all other clients need to wait for definitions
	waitUntil {(!isNil {_MRV getVariable "G_MRV_Logic"})};
	//Define logic from MRV (on all machines now)
	if (!(local _MRV)) then {
		_MRV_Logic = _MRV getVariable "G_MRV_Logic";
	};
	
	//Add Deploy and Undeploy actions, with conditions, to MRV based on Movable setting
	private _deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_Deploy_Action, [_MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_Deploy_actionCondition"];
	private _undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_UnDeploy_Action, [_MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_UnDeploy_actionCondition"];	
};

//Define function to handle vehicle being locked to enemy
if (G_isServer) then {
	G_fnc_MRV_Lock = {
		params ["_MRV", "_MRV_Logic"];
		//On unit getting in, kick them back out if they are not friendly
		_MRV addEventHandler ["GetIn", {
			private _MRV = _this select 0;
			private _unit = _this select 2;
			//Obtain MRV logic from MRV
			private _MRV_Logic = _MRV getVariable "G_MRV_Logic";
			//If the MRV and unit side are different, prevent entry
			if !([_MRV_Logic getVariable "G_Side", side _unit] call BIS_fnc_areFriendly) then {
				//Unit needs to be removed, so handle accordingly
				//Handle MRV engine
				private _fuel = fuel _MRV;
				0 remoteExecCall ["setFuel", _MRV, false];
				//Finish handling MRV engine in parallel
				[_unit, _MRV, _fuel] spawn {
					params ["_unit", "_MRV", "_fuel"];
					//Wait for unit to be out of the vehicle
					waitUntil {sleep 0.5; (vehicle _unit == _unit)};
					//Add fuel back to MRV
					_fuel remoteExecCall ["setFuel", _MRV, false];
				};
				
				//Remove unit from vehicle
				_unit action ["eject", _MRV];
				//Announce kick out using MRV's display name
				if (isPlayer _unit) then {
					[[format["You are not on the right team to enter %1!", getText (configFile >> "CfgVehicles" >> typeOf _MRV >> "displayName")], "PLAIN", 1]] remoteExecCall ["titleText", _unit, false];
					4 remoteExecCall ["titleFadeOut", _unit, false];
				};
			};
		}];
	};
};

//Define function for handling MRV onKilled
G_fnc_MRV_onKilled_EH = {
	params ["_MRV", "_MRV_Logic"];
	//Define onKilled EH for MRV to manage respawn position, actions, and its own respawn
	_MRV_killed_EH = _MRV addEventHandler ["Killed",
		{
			//Executing on local machine
			params ["_MRV"];
			//Get MRV Logic from MRV
			private _MRV_Logic = _MRV getVariable "G_MRV_Logic";
			//If MRV is deployed, Undeploy it
			if (_MRV_Logic getVariable "G_MRV_Deployed") then {
				[_MRV, "", "", [_MRV_Logic]] call G_fnc_MRV_UnDeploy_Action;
			};
			//Manage MRV wreck in parallel
			[_MRV] spawn {
				params ["_oldMRV"];
				//Wait for set wreck deletion time
				sleep G_Mobile_Respawn_Wreck;
				//Delete old MRV wreck
				deleteVehicle _oldMRV;
			};
			//Handle MRV respawn
			[_MRV_Logic] spawn G_fnc_MRV_onRespawn_EH;
		}
	];
};

//Define function for handling MRV onRespawn
G_fnc_MRV_onRespawn = {
	params ["_MRV", "_MRV_Logic"];
	
	//Set new MRV name
	_MRV setVehicleVarName (_MRV_Logic getVariable "G_MRV_Name");
	
	if (local _MRV) then {
		//Broadcast the new MRV name and non-Deployed status from local machine
		//bug - what?
		_MRV call compile format ["%1 = _this; publicVariable ""%1""", _MRV_Logic getVariable "G_MRV_Name"];
		
		//Obtain and set MRV direction
		_MRV setDir (_MRV_Logic getVariable "G_MRV_Dir");
	};
	
	//bug - a lot of the below is done on init, so consider making a function
	
	//Add Deploy and Undeploy actions, with conditions, to MRV based on Movable setting
	private _deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_Deploy_Action, [_MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_Deploy_actionCondition"];
	private _undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_UnDeploy_Action, [_MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_UnDeploy_actionCondition"];	

	//Manage MRV locking if enabled
	if (G_isServer && G_Mobile_Respawn_Locked) then {
		[_MRV, _MRV_Logic] spawn G_fnc_MRV_Lock;
	};
	//Manage MRV spawn marker init
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
	//Add MRV onkilled EH
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;

	if (local _MRV) then {
		//Custom execution
		if (!isNil "G_fnc_Custom_Exec_4") then {
			[_MRV] spawn G_fnc_Custom_Exec_4;
		};
	};
};

//Define function for handling MRV respawn
G_fnc_MRV_onRespawn_EH = {
	params ["_MRV_Logic"];

	//Wait for respawn timer
	sleep G_Mobile_Respawn_RespTimer;
	//Create MRV at initial spawn position
	private _MRV = (_MRV_Logic getVariable "G_MRV_Type") createVehicle (_MRV_Logic getVariable "G_MRV_Pos");
	//Reassign MRV Logic to new MRV
	_MRV setVariable ["G_MRV_Logic", _MRV_Logic, true];
	//Publically handle MRV onRespawn
	[_MRV, _MRV_Logic] remoteExec ["G_fnc_MRV_onRespawn", 0, true];
};

//Define function for handling MRV markers
G_fnc_MRV_Marker_Process = {
	params ["_MRV", "_MRV_Logic", "_MRV_mkr"];
	//Check if MRV marker is displayed only when Deployed or not
	if !(G_Mobile_Respawn_Mkr_Display) then {
		//MRV marker only displayed when Deployed
		//Manage appropriately for PvP
		if (G_PvP) then {
			//Is PvP, so is local marker
			//Handle marker while MRV is alive
			while {alive _MRV} do {
				//Wait for MRV to be deployed or destroyed
				waitUntil {sleep 0.5; ((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
				//Display marker
				_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
				//Handle marker while MRV is deployed
				while {((_MRV_Logic getVariable "G_MRV_Deployed") && (alive _MRV))} do {
					//Reposition marker onto MRV
					_MRV_mkr setMarkerPosLocal (getPos _MRV);
					//Wait for refresh time
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				//Hide marker
				_MRV_mkr setMarkerTypeLocal "empty";
			};
			//Delete local marker
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			//Is not PvP, so is public marker
			//Only handle public marker on server
			if (G_isServer) then {
				//Handle marker while MRV is alive
				while {alive _MRV} do {
					//Wait for MRV to be deployed or destroyed
					waitUntil {sleep 0.5; ((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
					//Display marker
					_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
					//Handle marker while MRV is deployed
					while {((_MRV_Logic getVariable "G_MRV_Deployed") && (alive _MRV))} do {
						//Reposition marker onto MRV
						_MRV_mkr setMarkerPos (getPos _MRV);
						//Wait for refresh time
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					//Hide marker
					_MRV_mkr setMarkerType "empty";
				};
				//Delete public marker
				deleteMarker _MRV_mkr;
			};
		};
	}
	else
	{
		//MRV marker always displayed
		//Manage appropriately for PvP
		if (G_PvP) then {
			//Is PvP, so is local marker
			//Display marker
			_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
			//Handle marker while MRV is alive
			while {alive _MRV} do {
				//Reposition marker onto MRV
				_MRV_mkr setMarkerPosLocal (getPos _MRV);
				//Wait for refresh time
				sleep G_Mobile_Respawn_Mkr_Refresh;
			};
			//Hide marker
			_MRV_mkr setMarkerTypeLocal "empty";
			//Delete local marker
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			//Is not PvP, so is public marker
			//Only handle public marker on server
			if (G_isServer) then {
				//Display marker
				_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
				//Handle marker while MRV is alive
				while {alive _MRV} do {
					//Reposition marker onto MRV
					_MRV_mkr setMarkerPos (getPos _MRV);
					//Wait for refresh time
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				//Hide marker
				_MRV_mkr setMarkerType "empty";
				//Delete local marker
				deleteMarker _MRV_mkr;
			};
		};
	};	
};

//Define function for creating MRV markers
G_fnc_MRV_Marker_Creation = {
	params ["_MRV", "_MRV_Logic"];
	//Create local marker for each client if in PvP
	if (G_PvP && G_isClient) then {
		//Check if MRV is on player's side
		if ([player getVariable "G_Side", _MRV_Logic getVariable "G_Side"] call BIS_fnc_areFriendly) then {
			//MRV and player on same side, so create local marker
			private _MRV_mkr = createMarkerLocal [format["G_MRV_mkr_%1", _MRV], getPos _MRV];
			_MRV_mkr setMarkerColorLocal G_Mobile_Respawn_Mkr_Color;
			_MRV_mkr setMarkerTextLocal G_Mobile_Respawn_Mkr_Text;
			//If respawn marker is enabled, handle it
			//bug - why did we create the marker before checking if this is enabled?
			if (G_Mobile_Respawn_Marker) then {
				[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
			};
		};
	};

	//Create public marker on server if not PvP
	if (!G_PvP && G_isServer) then {
		//Local to server and not in PvP, so create public marker
		private _MRV_mkr = createMarker [format["G_MRV_mkr_%1",_MRV], getPos _MRV];
		_MRV_mkr setMarkerColor G_Mobile_Respawn_Mkr_Color;
		_MRV_mkr setMarkerText G_Mobile_Respawn_Mkr_Text;
		//If respawn marker is enabled, handle it
		//bug - why did we create the marker before checking if this is enabled?
		if (G_Mobile_Respawn_Marker) then {
			[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
		};
	};
};

//Execute MRV init
{
	//_x = [[MRV], Side]
	private _side = _x select 1;
	{
		//_x = MRV
		[_side, _x] call G_fnc_MRV_init;
		private _MRV_Logic = _x getVariable "G_MRV_Logic";
		//Manage MRV locking on server if enabled
		if (G_isServer && G_Mobile_Respawn_Locked) then {
			[_x, _MRV_Logic] spawn G_fnc_MRV_Lock;
		};
		//Manage MRV spawn marker init
		[_x, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
		//Add MRV onkilled EH
		[_x, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;
		//bug - onRespawn custom execution here, or no? Since this is init, could all just go in editor init
	} forEach (_x select 0);
} forEach _MRV_Array; 