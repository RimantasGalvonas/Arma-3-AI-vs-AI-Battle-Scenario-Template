params ["_action"];

switch (_action) do
{
    case "rotate_ccw": {
        [nil, -5] call Rimsiakas_fnc_moveMissionArea;
    };
    case "rotate_cw": {
        [nil, 5] call Rimsiakas_fnc_moveMissionArea;
    };
    case "scale_down": {
        [-0.1] call Rimsiakas_fnc_scaleObjectPlacement;
    };
    case "scale_up": {
        [0.1] call Rimsiakas_fnc_scaleObjectPlacement;
    };
    default {};
};

if (!isMultiplayer || {hasInterface}) then {
    call Rimsiakas_fnc_refreshAdvancedConfigInfo;
} else {
    if (!isNil "Rimsiakas_loggedInAdmin") then {
        [] remoteExec ["Rimsiakas_fnc_refreshAdvancedConfigInfo", Rimsiakas_loggedInAdmin];
    };
};