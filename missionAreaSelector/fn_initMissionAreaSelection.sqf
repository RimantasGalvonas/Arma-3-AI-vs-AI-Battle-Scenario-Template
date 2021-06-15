titleCut ["", "BLACK IN", 1];
_actionId = player addAction ["Select mission area", {call Rimsiakas_fnc_openMissionAreaSelector}];
call Rimsiakas_fnc_openMissionAreaSelector;
waitUntil {!isNil "Rimsiakas_missionAreaSelected"};
player removeAction _actionId;
titleCut ["Initializing...", "BLACK FADED", 999, false];

publicVariable "Rimsiakas_missionAreaSelected";