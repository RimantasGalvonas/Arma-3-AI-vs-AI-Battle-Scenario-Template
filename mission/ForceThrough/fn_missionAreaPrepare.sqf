[] spawn {
    _rotation = selectRandom [0, 90, 180, 270];
    if (_rotation != 0) then {
        [(getPos patrolCenter), _rotation] call Rimsiakas_fnc_moveMissionArea;
    };
    [Rimsiakas_missionAreaScale] call Rimsiakas_fnc_scaleObjectPlacement;

    _allPlacers = (entities "LOGIC") select {_x getVariable ["logicType", ""] == "placer"};
    {
        _x setVariable ["relocateToNearestLandIfOnWater", true];
    } forEach _allPlacers;

    Rimsiakas_fnc_showMissionSelectorHints = {
        waitUntil {!isNull findDisplay 46421};
        "Select a mission location" hintC [parseText "If you want to select a mission area near a coast or the edge of the map, use <t font=""PuristaBold"">Advanced Config</t> to make sure all the required mission entities fit on land.", parsetext "Use <t font=""PuristaBold"">Advanced Config</t> to resize and rotate the mission area. Choose a large (~1000m radius) area for slower, more tactical gameplay, smaller (~400m radius) for quick-paced, intense gameplay.", parseText "When hosting a server, wait for the loading screen to go away before using the <t font=""PuristaBold"">Preview</t> button."];
    };

    if (hasInterface) then {
        call Rimsiakas_fnc_showMissionSelectorHints;
    } else {
        waitUntil {!isNil "Rimsiakas_loggedInAdmin"};
        (owner Rimsiakas_loggedInAdmin) publicVariableClient "Rimsiakas_fnc_showMissionSelectorHints";
        remoteExec ["Rimsiakas_fnc_showMissionSelectorHints", Rimsiakas_loggedInAdmin];
    };
};