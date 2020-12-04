setGroupIconsVisible [true, false];
Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);

if ((count Rimsiakas_missionValidationResult) > 0) then {
        [] spawn {
            sleep 0.1; // Small delay required to make sure hintC happens after the mission is initialized. Couldn't find any proper event handler for that.
            waitUntil {!isNull player};
            {
                waitUntil {isNull findDisplay 72 && isNull findDisplay 57};
                (_x select 0) hintC (_x select 1);
            } forEach Rimsiakas_missionValidationResult;
        };
} else {
    [] spawn {
        titleCut ["Initializing...", "BLACK FADED", 999];
        sleep 0.1; // Small delay required to make sure the mission is initialized, otherwise isPlayerHighCommander is always false. Couldn't find any proper event handler for that.

        isPlayerHighCommander = (count (hcAllGroups player) > 0);

        {
            if (_x getVariable "logicType" == "placer") then {
                [_x] call Rimsiakas_fnc_placer
            };
        } forEach synchronizedObjects patrolCenter;


        if (isPlayerHighCommander == false) then {
            [group player] call Rimsiakas_fnc_recursiveSADWaypoint;
        };

        /* Enable team switch */
        {
            addSwitchableUnit _x;
        } forEach units group player;

        [] execVM "createGrid.sqf";

        titleCut ["", "BLACK IN", 1];
    };
};