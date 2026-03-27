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
        hint parseText "<t align=""left""><t font=""PuristaBold"">Welcome to Force Through!</t><br/><br/>Please read the <t font=""PuristaBold"">briefing</t> for introduction and mission configuration tips.</t>";
    };

    if (hasInterface) then {
        call Rimsiakas_fnc_showMissionSelectorHints;
    } else {
        waitUntil {!isNil "Rimsiakas_loggedInAdmin"};
        (owner Rimsiakas_loggedInAdmin) publicVariableClient "Rimsiakas_fnc_showMissionSelectorHints";
        remoteExec ["Rimsiakas_fnc_showMissionSelectorHints", Rimsiakas_loggedInAdmin];
    };
};