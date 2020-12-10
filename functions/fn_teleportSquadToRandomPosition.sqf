params ["_group", "_centerPos", "_minimumDistance", "_maximumDistance", "_maxGradient", "_waterMode", "_shoreMode"];

_actuallyVehicleClasses = ["Car", "Armored", "Air", "Support"];

_vehicles = [];
_dismounts = [];

{
    _vehicleConfig = configFile >> "cfgVehicles" >> (typeOf vehicle _x);

    _vehicleClass = getText (_vehicleConfig >> "vehicleClass");

    if (_vehicleClass in _actuallyVehicleClasses) then {
        _vehicles append [_x];
    } else {
        _dismounts append [_x];
    };
} forEach (units _group);



// No vehicles in group - simpler way to spawn infantry
if (count (_vehicles) == 0) exitWith {
    _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, 1, 0, 0.6, 0] call BIS_fnc_findSafePos;
    {
        _unitPosition = _randomPosition findEmptyPosition [2, 20, typeOf _x];
        _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition; // Set on vehicle because it might be a turret
        vehicle _x setDir _azimuth;
        sleep 0.01; // A small delay prevents the units spawning on the same position and exploding to shit.
    } foreach units _group;
};



// Try to find a road section
_startingRoadSection = nil;

_maxRoadFindTryAttempts = 10;
_roadFindAttemptsCount = 0;

_averageAvailableDistance = (_minimumDistance + _maximumDistance) / 2;
_randomPositionForRoadSearch = [[[_centerPos, (_averageAvailableDistance + 1)]], [[_centerPos, (_averageAvailableDistance - 1)]]] call BIS_fnc_randomPos;

while {isNil "_startingRoadSection" && _roadFindAttemptsCount < _maxRoadFindTryAttempts} do {
    _nearRoads = _randomPositionForRoadSearch nearRoads (_maximumDistance - _minimumDistance);
    {
        if (((getRoadInfo _x) select 2) == false) exitWith {_startingRoadSection = _x};
    } foreach _nearRoads;
    _roadFindAttemptsCount = _roadFindAttemptsCount + 1;
};



// No road section was found
if (isNil "_startingRoadSection" == true) exitWith {
    _requiredArea = 10 + (count (_vehicles) * 5);

    _defaultPos = [[0,0],[0,0]];

    _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, _requiredArea, 0, 0.6, 0, nil, _defaultPos] call BIS_fnc_findSafePos;

    if (str _randomPosition == str _defaultPos) then {
        _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, 1, 0, 0.6, 0] call BIS_fnc_findSafePos;
        _terrainObjects = nearestTerrainObjects [_randomPosition, [], _requiredArea, false];

        {
            _x hideObjectGlobal true;
        } forEach _terrainObjects;
    };


    {
        _unitPosition = [_randomPosition, 0, _requiredArea, 5, 0, 0.6, 0] call BIS_fnc_findSafePos;
        _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;

        sleep 0.01;
    } forEach _vehicles;

    {
        _unitPosition = _randomPosition findEmptyPosition [0, _requiredArea, typeOf _x];
        _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;
        sleep 0.01; // A small delay prevents the units spawning on the same position and exploding to shit.
    } forEach _dismounts;
};



// Road section was found
if (isNil "_startingRoadSection" == false) exitWith {
    _nearbyRoadSections = nearestTerrainObjects [getPos _startingRoadSection, ["ROAD", "MAIN ROAD", "TRACK"], 100, true];



    // Handle vehicles in group
    {
        _vehicle = vehicle _x;
        _availableRoadSection = nil;

        {
            _nearbyVehicles = nearestObjects [getPos _x, _actuallyVehicleClasses, 5];
            if ((count _nearbyVehicles) == 0) exitWith
                {_availableRoadSection = _x;
                _nearbyRoadSections deleteAt _forEachIndex;
            }
        } forEach _nearbyRoadSections;

        if (isNil "_availableRoadSection" == false) then {
            _vehicle setPos (getPos _availableRoadSection);
        } else {
            // No safe road section was found, so clear an area nearby
            _positionForVehicle = [_startingRoadSection, 5, 30, 0, 0, 0.6, 0] call BIS_fnc_findSafePos;
            _terrainObjects = nearestTerrainObjects [_positionForVehicle, [], 6, false];
            {
                _x hideObjectGlobal true;
            } forEach _terrainObjects;

            _vehicle setPos _positionForVehicle;
        };
        sleep 0.01;
    } forEach _vehicles;



    // Handle dismounts in group
    {
        _unitPosition = (getPos _startingRoadSection) findEmptyPosition [0, 10, typeOf _x];
        _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;
        sleep 0.01;
    } forEach _dismounts;
};