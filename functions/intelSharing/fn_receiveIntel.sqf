params ["_group", "_targets"];

if ((isNull hcLeader (_group)) == false && isPlayerHighCommander == true) exitWith {}; // Has high commander

_groupPos = getPos (leader _group);


//Get current types of vehicles in the group
_typesOfVehiclesInGroup = [_group] call Rimsiakas_fnc_getVehicleClassesInGroup;
_hasTanksOrAircraftInGroup = count (_typesOfVehiclesInGroup arrayIntersect ["Air", "Armored"]) > 0;

// Get max response distance
_maxResponseDistance = patrolCenter getVariable ["maxInfantryResponseDistance", 500];
if (count (_typesOfVehiclesInGroup arrayIntersect ["Car", "Armored"]) > 0) then {
    _maxResponseDistance = patrolCenter getVariable ["maxVehicleResponseDistance", 1000];
};
if ("Air" in _typesOfVehiclesInGroup) then {
    _maxResponseDistance = patrolCenter getVariable ["maxAirResponseDistance", 10000];
};



{
    _canRespond = true;

    _alreadyRespondingPriority = _group getVariable ["respondingToIntelPriority", 0];
    _targetPriority = 1;

    _target = _x;
    _targetVehicleConfig = configFile >> "cfgVehicles" >> (typeOf vehicle _target);
    _targetVehicleClass = getText (_targetVehicleConfig >> "vehicleClass");

    if (_targetVehicleClass == "Armored") then {
        _targetPriority = 2;
    };



    // Ignore this target if current target has higher priority
    if (_targetPriority < _alreadyRespondingPriority) then {
        _canRespond = false;
    };



    // Ignore this target if it is armored and there are no armored or air units in group
    if (_targetVehicleClass == "Armored" && _hasTanksOrAircraftInGroup == false) then {
        _canRespond = false;
    };



    // Only air assets can catch up with other air assets
    if (_targetVehicleClass == "Air" && {!("Air" in _typesOfVehiclesInGroup)}) then {
        _canRespond = false;
    };



    // Ignore this target if it is too far
    _distanceToTarget = _groupPos distance (getPos _x);
    if (_distanceToTarget > _maxResponseDistance) then {
        _canRespond = false;
    };



    // Ignore this target if it has the same priority as current target and is not much closer
    if (_targetPriority == _alreadyRespondingPriority) then {
        _currentTargetPosition = _group getVariable ["currentTargetPosition", nil];

        _distanceToCurrentTarget = nil;
        if (!isNil "_currentTargetPosition") then {
            _distanceToCurrentTarget = _groupPos distance _currentTargetPosition;
        };

        if (!isNil "_distanceToCurrentTarget" && {_distanceToCurrentTarget + 300 > _distanceToTarget}) then {
            _canRespond = false;
        };
    };



    if (_canRespond == true) exitWith {
        _group setVariable ["respondingToIntelPriority", _targetPriority];
        _group setVariable ["currentTargetPosition", getPos _target];
        _waypointStatement = "(group this) setVariable ['currentTargetPosition', nil]; (group this) setVariable ['respondingToIntelPriority', 0];";

        if (_targetPriority == 2) then {
            // Redirect tank to attack another tank. Use waypoint type destroy to free up the tank instantly when the target is destroyed.

            for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
                deleteWaypoint [_group, _i];
            };

            _waypoint = _group addWaypoint [(getPos _target), 0];
            _waypoint setWaypointType "DESTROY";
            _waypoint setWaypointStatements ["true", _waypointStatement + " (group this) call Rimsiakas_fnc_recursiveSADWaypoint;"];
        } else {
            [_group, (getPos _target), _waypointStatement] call Rimsiakas_fnc_recursiveSADWaypoint;
        };
    };
} forEach _targets;