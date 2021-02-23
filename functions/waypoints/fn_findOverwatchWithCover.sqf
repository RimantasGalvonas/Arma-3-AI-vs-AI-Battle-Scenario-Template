/*
    Author:
        Rimantas Galvonas

    Description:
        Function to search an area for a position with cover from which a target location can be seen.

    Parameters:
        0: ARRAY - _centerPos - the position around which the search is done
        1: ARRAY - _targetPos - the target location (usually the enemy location)
        2: NUMBER - _maxDistance - maximum search radius
        3: (Optional) NUMBER - _minDistance - minimum search radius
        4: (Optional) NUMBER - _requiredFlatness- maximum terrain gradient (hill steepness)
        5: (Optional) BOOLEAN - _approachMode - approach mode
            When set to true, this function will serach the locations in a semicircle around the _targetPos from the direction of _centerPos

    Returns:
        ARRAY - position with cover from which the target location can be seen or _centerPos if no such location could be found.
*/

params ["_centerPos", "_targetPos", "_maxDistance", ["_minDistance", 1], ["_requiredFlatness", nil], ["_approachMode", false]];

_intersectionCheckInterval = 10;
_coverGroupingRadius = 30;

// Add a metre to the heights to measure visibility not straight from the ground
_targetPos = [_targetPos select 0, _targetPos select 1, ((_targetPos select 2) + 1)];

_selectedPositions = [];

_suitableCoverClasses = ["TREE", "SMALL TREE", "BUILDING", "HOUSE", "FOREST BORDER", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "FUELSTATION", "HOSPITAL", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWIND", "SHIPWRECK"];

_angleStart = 0;
_angleEnd = 359;



// For when _approachMode == true
_targetDirection = _centerPos getDir _targetPos;
_attackerPosition = _centerPos;
_approachConeAngle = 120;
if (_approachMode) then {
    _centerPos = _targetPos;
    _angleStart = 180 + _targetDirection - (_approachConeAngle / 2);
    _angleEnd = 180 + _targetDirection + (_approachConeAngle / 2);
};



// Collect spots that have visibility to the target area,
for "_radius" from _minDistance to _maxDistance step _intersectionCheckInterval do {
    _circumference = _radius * 2 * 3.14;
    _pointsCount = _circumference / _intersectionCheckInterval;
    _angleIncrement = 360 / _pointsCount;

    for "_angle" from _angleStart to _angleEnd step _angleIncrement do {

        _checkPos = _centerPos getPos [_radius, _angle];

        if (
            _approachMode && {!([_attackerPosition, _targetDirection, _approachConeAngle, _checkPos] call BIS_fnc_inAngleSector)}) then {
            continue;
        };

        _checkPos set [2, 1]; // Check from 1 meter above ground

        _isFlat = (isNil "_requiredFlatness" || {!(_checkPos isFlatEmpty [-1, -1, _requiredFlatness, _intersectionCheckInterval / 2, 0] isEqualTo [])});

        if (_isFlat) then {
            if (!terrainIntersect [_targetPos, _checkPos]) then {
                if (count (nearestTerrainObjects [_checkPos, _suitableCoverClasses, _intersectionCheckInterval, false]) > 0) then {
                    _selectedPositions append [_checkPos];

                    // Debugging
                    /*_markerName = "vantagePointDebug" + str _checkPos;
                    createMarkerLocal [_markerName, _checkPos];
                    _markerName setMarkerTypeLocal "mil_dot";
                    _markerName setMarkerAlphaLocal 0.3;
                    _markerName setMarkerColorLocal "ColorGreen";*/
                };
            };
        };
    };
};



// Group the separate positions into larger areas to calculate a score for each one taking available cover and height advantage into account. Positions and their scores are put into a flat array to be used with selectRandomWeighted command
_positionsAndScore = [];
for "_radius" from _minDistance to _maxDistance step _coverGroupingRadius do {
    _circumference = _radius * 2 * 3.14;
    _pointsCount = _circumference / _coverGroupingRadius;
    _angleIncrement = 360 / _pointsCount;

    for "_angle" from _angleStart to _angleEnd step _angleIncrement do {
        _checkPos = _centerPos getPos [_radius, _angle];

        _coverAroundThisPos = _selectedPositions inAreaArray [_checkPos, _coverGroupingRadius, _coverGroupingRadius, 0, false];

        if (count _coverAroundThisPos > 0) then {
            _heightDifference = (getTerrainHeightASL _checkPos) - (getTerrainHeightASL _targetPos);

            _heightMultiplier = 1;
            if (_heightDifference > 0) then {
                _heightMultiplier = 1 + (_heightDifference * 0.05); // Add 1 to multiplier with every 20 meters of height advantage
                _heightMultiplier = _heightMultiplier min 3;
            } else {
                if (_heightDifference < 0) then {
                    _heightMultiplier = 1 / (1 + (abs _heightDifference * 0.05)); // Halve the multiplier with every 20 meters of height disadvantage
                    _heightMultiplier = _heightMultiplier max 0.33;
                };
            };

            _score = (count _coverAroundThisPos) * _heightMultiplier;

            _positionsAndScore append [_checkPos, _score];


            // Debugging
            /*_markerName = "vantagePointDebug" + str _checkPos;
            createMarkerLocal [_markerName, _checkPos];
            _markerName setMarkerTypeLocal "mil_dot";
            _markerName setMarkerColorLocal "ColorYellow";
            _markerName setMarkerAlphaLocal 0.5;
            _markerName setMarkerTextLocal ((str count _coverAroundThisPos) + " " + str _heightDifference + " " + str _score);*/
        };
    };
};



// Don't always return the best position, but a bit randomized - otherwise nearby squads will be taking identical paths to the same target.
_result = selectRandomWeighted _positionsAndScore;

if (isNil "_result") then {
    _result = _centerPos;
} else {
    // Debugging
    /*_markerName = "overwatch" + str _result;
    createMarkerLocal [_markerName, _result];
    _markerName setMarkerTypeLocal "mil_dot";
    _markerName setMarkerColorLocal "ColorRed";
    _markerName setMarkerAlphaLocal 0.5;*/

};

_result;