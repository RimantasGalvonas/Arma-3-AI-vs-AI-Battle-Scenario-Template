sleep 0.1; // Small delay required because otherwise the Initializing... screen and validation hints are not shown.

if (isNull findDisplay 46421) then { // Check to make sure the mission selector dialog is not already opened
    cutText ["Initializing...", "BLACK FADED", 3600, false];
};


setGroupIconsVisible [true, false];

waitUntil {!isNil "Rimsiakas_missionValidationResult"};



if ((count Rimsiakas_missionValidationResult) > 0) exitWith {
    [] spawn {
        waitUntil {!isNull player};
        {
            waitUntil {isNull findDisplay 72 && isNull findDisplay 57};
            (_x select 0) hintC (_x select 1);
        } forEach Rimsiakas_missionValidationResult;
    };
    cutText ["", "BLACK IN", 1];
};


if (patrolCenter getVariable ["dynamic", false] && {!isServer && {isNil "Rimsiakas_missionAreaSelected" || {!Rimsiakas_missionAreaSelected}}}) then {
    cutText ["Waiting for the host to select the mission location.\n(On dedicated servers this requires an admin to login or be elected.)", "BLACK FADED", 3600, false];
    waitUntil {!isNil "Rimsiakas_missionAreaSelected" && {Rimsiakas_missionAreaSelected}};
    cutText ["Initializing...", "BLACK FADED", 3600, false];
};



waitUntil {(!isNil "Rimsiakas_missionInitialized" && {Rimsiakas_missionInitialized == true})};


player setVariable ["CHVD_initialized", true];


// Create intel grid
[] call Rimsiakas_fnc_createIntelGrid;



// Set visible group icons (otherwise allied faction icons are not shown)
[player] call Rimsiakas_fnc_revealFriendlyGroupsOnMap;

// Without this the military symbols would disappear after teamswitching.
addMissionEventHandler ["TeamSwitch", {
    params ["_from", "_to"];

    _to setVariable ["MARTA_reveal", (_from getVariable ["MARTA_reveal", []])];
    setGroupIconsVisible [true, false];

    _from enableAI "all";

    if (!(_to getVariable ["CHVD_initialized", false])) then {
        call CHVD_fnc_init;
        _to setVariable ["CHVD_initialized", true];
    };
}];



player addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    {
        [_x] call Rimsiakas_fnc_searchForEnemies;
    } forEach hcAllGroups _unit;
}];



cutText ["", "BLACK IN", 1];