params ["_group", "_centerPos", "_minimumDistance", "_maximumDistance", "_maxGradient", "_waterMode", "_shoreMode"];

private _vehicles = [];
private _dismounts = [];

{
    private _unitVehicleType = (vehicle _x) call BIS_fnc_objectType;

    if ((_unitVehicleType select 0) in ["Vehicle", "VehicleAutonomous"]) then {
        _vehicles append [vehicle _x];
    } else {
        _dismounts append [_x];
    };
} forEach (units _group);
_vehicles = _vehicles arrayIntersect _vehicles;



// No vehicles in group - simpler way to spawn infantry
if (count (_vehicles) == 0) exitWith {
    private _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, 1, 0, 0.6, 0] call BIS_fnc_findSafePos;
    {
        private _unitPosition = _randomPosition findEmptyPosition [2, 20, typeOf _x];
        private _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition; // Set on vehicle because it might be a turret
        vehicle _x setDir _azimuth;
    } foreach units _group;
};



// Try to find a road section
private _startingRoadSection = [_centerPos, _minimumDistance, _maximumDistance] call Rimsiakas_fnc_findRoad;



// No road section was found
if (isNil "_startingRoadSection" == true) exitWith {
    private _requiredArea = 10 + (count (_vehicles) * 5);

    private _defaultPos = [[0,0],[0,0]];

    private _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, _requiredArea, 0, 0.3, 0, nil, _defaultPos] call BIS_fnc_findSafePos;

    if ((_randomPosition select 0) == 0) then {
        _randomPosition = [_centerPos, _minimumDistance, _maximumDistance, 1, 0, 0.3, 0] call BIS_fnc_findSafePos;
        private _terrainObjects = nearestTerrainObjects [_randomPosition, [], _requiredArea, false];

        {
            _x hideObjectGlobal true;
        } forEach _terrainObjects;
    };


    {
        private _unitPosition = [_randomPosition, 0, _requiredArea, 5, 0, 0.6, 0] call BIS_fnc_findSafePos;
        private _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;
    } forEach _vehicles;

    {
        private _unitPosition = _randomPosition findEmptyPosition [5, _requiredArea, typeOf _x];
        private _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;
    } forEach _dismounts;
};



// Road section was found
if (isNil "_startingRoadSection" == false) exitWith {
    private _nearbyRoadSections = nearestTerrainObjects [getPos _startingRoadSection, ["ROAD", "MAIN ROAD", "TRACK"], 100, true];



    // Handle vehicles in group
    {
        private _vehicle = vehicle _x;
        private _availableRoadSection = nil;

        {
            private _nearbyEntities = (getPos _x) nearEntities 5;
            if ((count _nearbyEntities) == 0) exitWith
                {_availableRoadSection = _x;
                _nearbyRoadSections deleteAt _forEachIndex;
            }
        } forEach _nearbyRoadSections;

        if (isNil "_availableRoadSection" == false) then {
            _vehicle setPos (getPos _availableRoadSection);
        } else {
            // No safe road section was found, so clear an area nearby
            private _positionForVehicle = [_startingRoadSection, 5, 30, 0, 0, 0.6, 0] call BIS_fnc_findSafePos;
            private _terrainObjects = nearestTerrainObjects [_positionForVehicle, [], 6, false];
            {
                _x hideObjectGlobal true;
            } forEach _terrainObjects;

            _vehicle setPos _positionForVehicle;
        };
    } forEach _vehicles;



    // Handle dismounts in group
    {
        private _unitPosition = (getPos _startingRoadSection) findEmptyPosition [5, 20, typeOf _x];
        private _azimuth = random [0, 180, 359];

        vehicle _x setPos _unitPosition;
        vehicle _x setDir _azimuth;
    } forEach _dismounts;
};