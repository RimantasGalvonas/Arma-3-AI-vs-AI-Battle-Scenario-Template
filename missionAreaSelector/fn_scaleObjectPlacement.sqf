params ["_scale"];


_scale = (patrolCenter getVariable ["scaling", 1]) + _scale;


private ["_synchronizedMoveableObjects", "_synchronizedMoveableObjects"];
_synchronizedMoveableObjects = (synchronizedObjects patrolCenter) select {typeOf _x == "LOGIC" && {_x getVariable "logicType" == "placer" && {(_x getVariable ["dynamic", true])}}};
_synchronizedMoveableObjects append ((synchronizedObjects patrolCenter) select {(typeOf _x) find "EmptyDetector" == 0}); // Triggers



private _scaleObjectPlacementFunc = {
    params ["_object", "_scale"];

    // Use unscaled values to keep this reversible. Otherwise it gets all messed up due to float imprecision
    private _originalDistance = _object getVariable ["originalDistanceFromCenter", nil];
    if (isNil "_originalDistance") then {
        _originalDistance = patrolCenter distance2D _object;
        _object setVariable ["originalDistanceFromCenter", _originalDistance];
    };

    private _azimuth = _object getVariable ["originalAzimuthFromCenter", nil];
    if (isNil "_azimuth") then {
        _azimuth = patrolCenter getDir _object;
        _object setVariable ["originalAzimuthFromCenter", _azimuth];
    } else {
        _azimuth = _azimuth + (patrolCenter getVariable ["rotation", 0]);
    };

    private _scaledDistance = _originalDistance * _scale;
    private _newPos = (getPos patrolCenter) getPos [_scaledDistance, _azimuth];
    _object setPos _newPos;



    if (_object getVariable ["scalable", true]) then {
        if ((typeOf _object) find "EmptyDetector" == 0) then {
            _origTriggerArea = nil;
            if (isNil {_object getVariable ["originalTriggerArea", nil]}) then {
                _origTriggerArea = triggerArea _object;
                // No idea why it needs to be cast into a string, but it does.
                _object setVariable ["originalTriggerArea", (str _origTriggerArea)];
            } else {
                _origTriggerArea = parseSimpleArray (_object getVariable "originalTriggerArea");
            };

            _triggerArea = triggerArea _object;
            _triggerArea set [0, (_origTriggerArea select 0) * _scale];
            _triggerArea set [1, (_origTriggerArea select 1) * _scale];
            _object setTriggerArea _triggerArea;
        };



        if (typeOf _object == "LOGIC" && {_object getVariable "logicType" == "placer"}) then {
            private _minSpawnRadius = _object getVariable ["minSpawnRadius_original", nil];

            if (isNil "_minSpawnRadius") then {
                _minSpawnRadius = _object getVariable "minSpawnRadius";
                _object setVariable ["minSpawnRadius_original", _minSpawnRadius];
            };

            _object setVariable ["minSpawnRadius", _minSpawnRadius * _scale];



            private _maxSpawnRadius = _object getVariable ["maxSpawnRadius_original", nil];

            if (isNil "_maxSpawnRadius") then {
                _maxSpawnRadius = _object getVariable "maxSpawnRadius";
                _object setVariable ["maxSpawnRadius_original", _maxSpawnRadius];
            };

            _object setVariable ["maxSpawnRadius", _maxSpawnRadius * _scale];
            {
                [_x, _scale] call _scaleObjectPlacementFunc;
            } forEach (_object getVariable ["childPlacers", []]);
        };
    };
};



{
    [_x, _scale] call _scaleObjectPlacementFunc;
} forEach _synchronizedMoveableObjects;


// Use unscaled values to keep this reversible. Otherwise it gets all messed up due to float imprecision
if (isNil {patrolCenter getVariable ["scaling", nil];}) then {
    patrolCenter setVariable ["patrolRadius_original", patrolCenter getVariable "patrolRadius"];
    patrolCenter setVariable ["intelGridSize_original", patrolCenter getVariable "intelGridSize"];
    patrolCenter setVariable ["maxInfantryResponseDistance_original", patrolCenter getVariable "maxInfantryResponseDistance"];
    patrolCenter setVariable ["maxVehicleResponseDistance_original", patrolCenter getVariable "maxVehicleResponseDistance"];
    patrolCenter setVariable ["maxAirResponseDistance_original", patrolCenter getVariable "maxAirResponseDistance"];
};

_patrolRadius = (patrolCenter getVariable "patrolRadius_original") * _scale;
patrolCenter setVariable ["patrolRadius", ceil _patrolRadius, true];
patrolCenter setVariable ["intelGridSize", floor ((patrolCenter getVariable "intelGridSize_original") * _scale), true];
patrolCenter setVariable ["maxInfantryResponseDistance", round ((patrolCenter getVariable "maxInfantryResponseDistance_original") * _scale), true];
patrolCenter setVariable ["maxVehicleResponseDistance", round ((patrolCenter getVariable "maxVehicleResponseDistance_original") * _scale), true];
patrolCenter setVariable ["maxAirResponseDistance", round ((patrolCenter getVariable "maxAirResponseDistance_original") * _scale), true];
patrolCenter setVariable ["scaling", _scale, true];

if ("missionAreaMarker" in allMapMarkers) then {
    private _markerSize = (markerSize "missionAreaMarker") select 0;
    "missionAreaMarker" setMarkerSizeLocal [_patrolRadius, _patrolRadius];
};