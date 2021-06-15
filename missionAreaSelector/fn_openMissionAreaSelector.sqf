closeDialog 1;

if (!createDialog "Rimsiakas_MissionAreaSelectorDialog") exitWith {
    hint "Couldn't open the mission area selector, using predefined position";

    Rimsiakas_missionAreaSelected = true;
};


_missionAreaSize = patrolCenter getVariable "patrolRadius";

createMarkerLocal ["missionAreaMarker", getPos patrolCenter];
"missionAreaMarker" setMarkerShapeLocal "RECTANGLE";
"missionAreaMarker" setMarkerColorLocal "ColorRed";
"missionAreaMarker" setMarkerBrushLocal "DiagGrid";
"missionAreaMarker" setMarkerSizeLocal [_missionAreaSize, _missionAreaSize];

waitUntil {!isNull findDisplay 46421};

_dialog = findDisplay 46421;

_map = _dialog displayCtrl 1001;

_map ctrlAddEventHandler ["MouseButtonClick", {
    _ctrl = _this select 0;
    _x = _this select 2;
    _y = _this select 3;

    _pos = _ctrl ctrlMapScreenToWorld [_x, _y];
    "missionAreaMarker" setMarkerPosLocal _pos;

    [_pos] remoteExecCall ["Rimsiakas_fnc_moveMissionArea", 2];
}];
