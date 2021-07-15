params ["_position"];

private _targetPosForestFactor = selectBestPlaces [_position, 100, "-forest", 30, 1];

_targetPosForestFactor = (_targetPosForestFactor select 0) select 1;

if (_targetPosForestFactor < -0.3) exitWith { true };

false;