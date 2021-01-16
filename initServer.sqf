[] execVM "G_Revive_init.sqf";



Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);
publicVariable "Rimsiakas_missionValidationResult";
if ((count Rimsiakas_missionValidationResult) > 0) exitWith {};



Rimsiakas_highCommandSubordinates = [];



// Small delay required to make sure the mission is initialized, otherwise there are problems with High Commander mode
sleep 0.1;


// Mission area selector
if (patrolCenter getVariable ["dynamic", false] && {hasInterface}) then {
    titleCut ["", "BLACK IN", 1];
    _actionId = player addAction ["Select mission area", {call Rimsiakas_fnc_openMissionAreaSelector}];
    call Rimsiakas_fnc_openMissionAreaSelector;
    waitUntil {!isNil "Rimsiakas_missionAreaSelected"};
    player removeAction _actionId;
    titleCut ["Initializing...", "BLACK FADED", 999, false];
};



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


[] spawn {
    call Rimsiakas_fnc_shareIntel;
};


addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "_id", "_uid", "_name"];

    {
        [_x] call Rimsiakas_fnc_searchForEnemies
    } forEach hcAllGroups _unit;

    true;
}];



Rimsiakas_missionInitialized = true;
publicVariable "Rimsiakas_missionInitialized";