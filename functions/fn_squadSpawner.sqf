params ["_placer", "_groupConfig", ["_isHighCommand", false]];

_minRadius = _placer getVariable "minSpawnRadius";
_maxRadius = _placer getVariable "maxSpawnRadius";

_newGroup = false;

if (typeName _groupConfig == "CONFIG") then {
    _side = (getNumber (_x >> "side")) call BIS_fnc_sideType;
    _safetyMargin = [_groupConfig] call Rimsiakas_fnc_calculateRequiredAreaForGroup;

    _randomPosition = [_placer, _minRadius, _maxRadius, _safetyMargin, 0, 0.6, 0] call BIS_fnc_findSafePos;

    _azimuth = 0;
    if (_side == playerSide) then {
        _azimuth = _randomPosition getDir _placer;
    } else {
        _azimuth = _placer getDir _randomPosition;
    };

    _newGroup = [_randomPosition, _side, _groupConfig, nil, nil, nil, nil, nil, _azimuth] call BIS_fnc_spawnGroup;
};

if (typeName _groupConfig == "ARRAY") then {
    _vehicleConfig = configFile >> "cfgVehicles" >> (_groupConfig select 0);;
    _sideId = getNumber (_vehicleConfig >> "side");
    _side = _sideId call BIS_fnc_sideType;

    _newGroup = createGroup _side;

    _randomPosition = [_placer, _minRadius, _maxRadius, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;

    _azimuth = 0;
    if (_side == playerSide) then {
        _azimuth = _randomPosition getDir _placer;
    } else {
        _azimuth = _placer getDir _randomPosition;
    };

    {
        _unitPosition = _randomPosition findEmptyPosition [0, 100, _x];
        [_unitPosition, _azimuth, _x, _newGroup] call BIS_fnc_spawnVehicle;
        sleep 0.01; // A small delay prevents the units spawning on the same position and exploding to shit.
    } foreach _groupConfig;
};

if (!_isHighCommand || {_placer getVariable ["highCommandSubordinates", false] == false}) then {
    _newGroup call Rimsiakas_fnc_recursiveSADWaypoint;
} else {
    player hcSetGroup [_newGroup];
};