closeDialog 1;

_newMissionPos = getMarkerPos "missionAreaMarker";

[_newMissionPos] call Rimsiakas_fnc_moveMissionArea;

deleteMarkerLocal "missionAreaMarker";

Rimsiakas_missionAreaSelected = true;