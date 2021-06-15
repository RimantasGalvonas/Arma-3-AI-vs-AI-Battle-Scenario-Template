params ["_pos", "_dialog"];

[_pos] call Rimsiakas_fnc_moveMissionArea;

if (!isMultiplayer || {hasInterface}) then {
    "missionAreaMarker" setMarkerPosLocal _pos;
    if (_dialog == "advanced") then {
        call Rimsiakas_fnc_createMarkersForSyncedObjects;
    };
} else {
    if (!isNil "Rimsiakas_loggedInAdmin") then {
        ["missionAreaMarker", _pos] remoteExec ["setMarkerPosLocal", Rimsiakas_loggedInAdmin];
        if (_dialog == "advanced") then {
            ["missionAreaMarker", _pos] remoteExec ["Rimsiakas_fnc_createMarkersForSyncedObjects", Rimsiakas_loggedInAdmin];
        };
    };
};