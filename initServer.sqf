[] execVM "G_Revive_init.sqf";



Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);
publicVariable "Rimsiakas_missionValidationResult";
if ((count Rimsiakas_missionValidationResult) > 0) exitWith {};



Rimsiakas_highCommandSubordinates = [];



// Small delay required to make sure the mission is initialized, otherwise there are problems with High Commander mode
sleep 0.1;



// Spawn/place units
_placersToProcessLast = [];
{
    if (_x getVariable "logicType" == "placer") then {
        if (count(_x getVariable ["camps", []]) == 0) then {
            [_x] call Rimsiakas_fnc_placer;
        } else {
            _placersToProcessLast append [_x]; // placers with camps need to be processed last so it can select the camp garrison from one of the already active factions
        };
    };
} forEach synchronizedObjects patrolCenter;

{
    [_x] call Rimsiakas_fnc_placer;
} forEach _placersToProcessLast;



 remoteExec ["Rimsiakas_fnc_reenableAI"];



// Start groups intel sharing
{
    [_x] spawn { // This makes it run parallel for all groups
        params["_group"];
        _group call Rimsiakas_fnc_shareIntel;
    };
} forEach allGroups;



addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "_id", "_uid", "_name"];

    {
        [_x] call Rimsiakas_fnc_recursiveSADWaypoint
    } forEach hcAllGroups _unit;

    true;
}];



Rimsiakas_missionInitialized = true;
publicVariable "Rimsiakas_missionInitialized";