params ["_group"];

private _previousTargetGroup = _group getVariable ["currentTargetGroup", false];

_group setVariable ["lastReportedTargetPosition", nil];
_group setVariable ["respondingToIntelPriority", 0];
_group setVariable ["currentTargetGroup", nil];
_group setVariable ["currentTarget", nil];

[_group, _previousTargetGroup] call Rimsiakas_fnc_afterTargetChange;