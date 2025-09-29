[] execVM "G_Revive_init.sqf";



Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);
publicVariable "Rimsiakas_missionValidationResult";
if ((count Rimsiakas_missionValidationResult) > 0) exitWith {};



Rimsiakas_highCommandSubordinates = [];



// Small delay required to make sure the mission is initialized, otherwise there are problems with High Commander mode
sleep 0.1;


// Mission area selector
if (patrolCenter getVariable ["dynamic", false]) then {
    if (hasInterface) then {
        [] call Rimsiakas_fnc_initMissionAreaSelection;
    } else {
        Rimsiakas_loggedInAdmin = nil;
        while {isNil "Rimsiakas_loggedInAdmin"} do {
            sleep 1;
            {
                if ((admin owner _x) > 0) exitWith {
                    Rimsiakas_loggedInAdmin = _x;
                };
            } forEach allPlayers;
        };

        remoteExec ["Rimsiakas_fnc_initMissionAreaSelection", Rimsiakas_loggedInAdmin];
    };

    waitUntil {!isNil "Rimsiakas_missionAreaSelected"};
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

[] spawn {
    call Rimsiakas_fnc_controlGroupSpeed;
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