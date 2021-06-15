if (!createDialog "Rimsiakas_AdvancedConfigDialog") exitWith {
    hint "Couldn't open the mission area selector, using predefined position";

    Rimsiakas_missionAreaSelected = true;
};



waitUntil {!isNull findDisplay 46424};

call Rimsiakas_fnc_refreshAdvancedConfigInfo;

_dialog = findDisplay 46424;

_map = _dialog displayCtrl 1001;

_map ctrlAddEventHandler ["MouseButtonClick", {
    _ctrl = _this select 0;
    _x = _this select 2;
    _y = _this select 3;

    _pos = _ctrl ctrlMapScreenToWorld [_x, _y];
    [_pos, "advanced"] remoteExecCall ["Rimsiakas_fnc_handleMapClick", 2];
}];

_map ctrlMapAnimAdd [0, 0.25, getMarkerPos "missionAreaMarker"];
ctrlMapAnimCommit _map;

if (!isServer) then {
    // This script runs on a client which sends mission location changes to the dedicated server.
    // There's no way to know when the server has received and processed the mission location changes so this needs to be refreshed constantly.
    [] spawn {
        while {!isNull findDisplay 46424} do {
            call Rimsiakas_fnc_createMarkersForSyncedObjects;
            sleep 0.3;
        };
    };
};


waitUntil {isNull findDisplay 46424};

{
    deleteMarkerLocal _x
} forEach Rimsiakas_markersForSyncedObjectsDebugging;


waitUntil {!isNull findDisplay 46421};
_dialog = findDisplay 46421;
_map = _dialog displayCtrl 1001;
_map ctrlMapAnimAdd [0, 0.25, getMarkerPos "missionAreaMarker"];
ctrlMapAnimCommit _map;