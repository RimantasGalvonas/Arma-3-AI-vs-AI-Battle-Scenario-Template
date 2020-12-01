params ["_groupConfig", "_minRadius", "_maxRadius", ["_isHighCommand", false]];

_newGroup = false;

if (typeName _groupConfig == "CONFIG") then {
    _side = (getNumber (_x >> "side")) call BIS_fnc_sideType;
    _safetyMargin = [_groupConfig] call Rimsiakas_fnc_calculateRequiredAreaForGroup;

    _randomPosition = [patrolCenter, _minRadius, _maxRadius, _safetyMargin, 0, 0.6, 0] call BIS_fnc_findSafePos;

    _azimuth = 0;
    if (_side == playerSide) then {
        _azimuth = _randomPosition getDir patrolCenter;
    } else {
        _azimuth = patrolCenter getDir _randomPosition;
    };

    _newGroup = [_randomPosition, _side, _groupConfig, nil, nil, nil, nil, nil, _azimuth] call BIS_fnc_spawnGroup;
};

if (typeName _groupConfig == "ARRAY") then {
    _vehicleConfig = configFile >> "cfgVehicles" >> (_groupConfig select 0);;
    _sideId = getNumber (_vehicleConfig >> "side");
    _side = _sideId call BIS_fnc_sideType;

    _newGroup = createGroup _side;

    _randomPosition = [patrolCenter, _minRadius, _maxRadius, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;

    _azimuth = 0;
    if (_side == playerSide) then {
        _azimuth = _randomPosition getDir patrolCenter;
    } else {
        _azimuth = patrolCenter getDir _randomPosition;
    };

    {
        _unitPosition = _randomPosition findEmptyPosition [0, 100, _x];
        [_unitPosition, _azimuth, _x, _newGroup] call BIS_fnc_spawnVehicle;
        sleep 0.01; // A small delay prevents the units spawning on the same position and exploding to shit.
    } foreach _groupConfig;
};

if (!_isHighCommand) then {
    _newGroup call Rimsiakas_fnc_recursiveSADWaypoint;
} else {
    player hcSetGroup [_newGroup];
};