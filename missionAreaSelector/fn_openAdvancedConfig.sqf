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
    "missionAreaMarker" setMarkerPosLocal _pos;

    [_pos] call Rimsiakas_fnc_moveMissionArea;
    call Rimsiakas_fnc_createMarkersForSyncedObjects;
}];

_map ctrlMapAnimAdd [0, 0.25, getMarkerPos "missionAreaMarker"];
ctrlMapAnimCommit _map;


waitUntil {isNull findDisplay 46424};

{
    deleteMarkerLocal _x
} forEach Rimsiakas_markersForSyncedObjectsDebugging;


waitUntil {!isNull findDisplay 46421};
_dialog = findDisplay 46421;
_map = _dialog displayCtrl 1001;
_map ctrlMapAnimAdd [0, 0.25, getMarkerPos "missionAreaMarker"];
ctrlMapAnimCommit _map;