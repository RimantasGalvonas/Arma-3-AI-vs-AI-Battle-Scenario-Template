#include "..\elementIds.hpp"

closeDialog 1;

if (!createDialog "Rimsiakas_MainConfigDialog") exitWith {
    hint "Couldn't open the mission area selector, using predefined position";

    Rimsiakas_missionConfigured = true;
};


_missionAreaSize = patrolCenter getVariable "patrolRadius";

createMarkerLocal ["missionAreaMarker", getPos patrolCenter];
"missionAreaMarker" setMarkerShapeLocal "RECTANGLE";
"missionAreaMarker" setMarkerColorLocal "ColorRed";
"missionAreaMarker" setMarkerBrushLocal "DiagGrid";
"missionAreaMarker" setMarkerSizeLocal [_missionAreaSize, _missionAreaSize];



waitUntil {!isNull findDisplay MAIN_CONFIG_IDD};

_dialog = findDisplay MAIN_CONFIG_IDD;



_map = _dialog displayCtrl MAIN_CONFIG_MAP_IDC;

_map ctrlAddEventHandler ["MouseButtonClick", {
    _ctrl = _this select 0;
    _x = _this select 2;
    _y = _this select 3;

    _pos = _ctrl ctrlMapScreenToWorld [_x, _y];

    [_pos] remoteExecCall ["Rimsiakas_fnc_handleMapClickOnServer", 2];
}];

[] call Rimsiakas_fnc_centerMapOnPatrolCenter;



ctrlSetText [MAIN_CONFIG_PATROLRADIUSVALUE_IDC, str ((patrolCenter getVariable "patrolRadius") * 2)];
lbSetCurSel [MAIN_CONFIG_FLARE_FIELD_IDC, patrolCenter getVariable ["flaresLevel", 0]];



if (isNil "Rimsiakas_defaultPresetGenerated") then {
   if (isNil "Rimsiakas_initialFactionsData") then {
       [] call Rimsiakas_fnc_collectFactionsData;
   };

   [] call Rimsiakas_fnc_generateDefaultConfigurationPreset;
};



private _spawners = entities "LOGIC" select {_x getVariable ["logicType", ""] == "spawner"};

if (count _spawners == 0) then {
    private _factionConfigButton = displayCtrl MAIN_CONFIG_BUTTONS_FACTIONCONFIG_IDC;
    private _presetsButton = displayCtrl MAIN_CONFIG_BUTTONS_FACTIONPRESETS_IDC;

    _factionConfigButton ctrlShow false;
    _factionButtonPos = ctrlPosition _factionConfigButton;
    _factionButtonPos resize 2;
    _presetsButton ctrlSetPosition _factionButtonPos;
    _presetsButton ctrlCommit 0;
};