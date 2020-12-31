sleep 0.1; // Small delay required because otherwise the Initializing... screen and validation hints are not shown.

if (isNull findDisplay 46421) then { // Check to make sure the mission selector dialog is not already opened
    titleCut ["Initializing...", "BLACK FADED", 999, false];
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
    titleCut ["", "BLACK IN", 1];
};



waitUntil {(!isNil "Rimsiakas_missionInitialized" && {Rimsiakas_missionInitialized == true})};


player setVariable ["CHVD_initialized", true];


// Create intel grid
[] execVM "createGrid.sqf";



// Set visible group icons (otherwise allied faction icons are not shown)
_friendlyGroups = [];
{
    if ([side player, side _x] call BIS_fnc_sideIsFriendly) then {
        _friendlyGroups append [_x];
    };
} forEach allGroups;

player setVariable ["MARTA_reveal", _friendlyGroups];

// Without this the military symbols would disappear after teamswitching.
onTeamSwitch {
    setGroupIconsVisible [true, false];
    _to setVariable ["MARTA_reveal", (_from getVariable "MARTA_reveal")];
    _from enableAI "all";
    if (!(_to getVariable ["CHVD_initialized", false])) then {
        call CHVD_fnc_init;
        _to setVariable ["CHVD_initialized", true];
    };
};



player addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    {
        _x call Rimsiakas_fnc_recursiveSADWaypoint;
    } forEach hcAllGroups _unit;
}];



titleCut ["", "BLACK IN", 1];