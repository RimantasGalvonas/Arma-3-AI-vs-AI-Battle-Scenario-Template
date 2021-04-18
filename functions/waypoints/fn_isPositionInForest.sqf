params ["_position"];

private _targetPosForestFactor = selectBestPlaces [_position, 150, "-forest", 30, 1];

_targetPosForestFactor = (_targetPosForestFactor select 0) select 1;

if (str (_targetPosForestFactor) == "-1") exitWith { true }; // Only works properly when typecasted to string. Probably some floating-point bullshit.

false;