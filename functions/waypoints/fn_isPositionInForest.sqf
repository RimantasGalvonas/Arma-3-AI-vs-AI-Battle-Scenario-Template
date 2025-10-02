params ["_position"];

private _depth = 100;
private _expression = "((trees + forest) / -2) + meadow*2";

// This uses negative values, because what I'm trying to do here is check whether the LEAST forested area around here is still at least 0.65 "forest points"
private _threshold = -0.65;

switch (toLower worldName) do
{
	case "tanoa": {_expression = "((trees + forest) / -2) + meadow*1.25"; _depth = 50; _threshold = -0.4;}; // Lots of vegetation, can afford lower depth and threshold. Gotta go easy on meadows, because they're often overgrown
	case "cam_lao_nam": {_expression = "-trees + meadow*2"; _depth = 50;}; // Trees instead of forest due to rice fields
	case "vn_khe_sanh": {_expression = "-trees"; _threshold = -0.3}; // Trees instead of forest due to rice fields
	case "vn_the_bra": {_expression = "(trees * 1.9 + forest * 0.1) / -2"; _threshold = -0.3}; // Trees instead of forest due to rice fields, gotta still use some due to tall grass
	case "stozec": {_depth = 75;}; // Thick foliage even at the edge of forests, needs less depth. Higher threshold removes some forest roads and such.
	case "enoch": {_expression = "((trees + forest) / -2) + meadow*100"; _threshold = -0.8;}; // Very foresty, with clearly defined meadows, can afford lower tolerances.
};

private _targetPosForestFactor = selectBestPlaces [_position, _depth, _expression, 30, 1];

_targetPosForestFactor = (_targetPosForestFactor select 0) select 1;

if (_targetPosForestFactor < _threshold) exitWith { true };

false;