params ["_group", "_targets"];

if (isPlayer (hcLeader _group)) exitWith {}; // Has high commander
if (_group getVariable ["ignoreIntel", false]) exitWith {};
if (_group getVariable ["processingIntel", false]) exitWith {}; // Prevents multiple instances of this script being run for this group due to some scheduling nonsense

_group setVariable ["processingIntel", true];

_groupPos = getPos (leader _group);



//Get current types of vehicles in the group
_typesOfVehiclesInGroup = [];

{
    private _targetVehicleType = (vehicle _x) call BIS_fnc_objectType;
    _typesOfVehiclesInGroup append [_targetVehicleType select 1];
} forEach units _group;

_typesOfVehiclesInGroup = _typesOfVehiclesInGroup arrayIntersect _typesOfVehiclesInGroup; // Remove duplicates



// Get max response distance
_maxResponseDistance = patrolCenter getVariable ["maxInfantryResponseDistance", 500];
if (count (_typesOfVehiclesInGroup arrayIntersect ["Car", "Motorcycle", "Ship", "Submarine", "TrackedAPC", "Tank", "WheeledAPC"]) > 0) then {
    _maxResponseDistance = patrolCenter getVariable ["maxVehicleResponseDistance", 1000];
};
if (count (_typesOfVehiclesInGroup arrayIntersect ["Helicopter", "Plane"]) > 0) then {
    _maxResponseDistance = patrolCenter getVariable ["maxAirResponseDistance", 10000];
};



// Free up tanks and air assets as soon as they've dealt with their target
_currentTarget = _group getVariable["currentTarget", nil];
if (count (_typesOfVehiclesInGroup arrayIntersect ["Tank", "Helicopter", "Plane"]) > 0) then {
    if (!isNil "_currentTarget" && {!alive _currentTarget}) then {
        [_group] call Rimsiakas_fnc_unsetGroupTarget;
    };
};



{
    _canRespond = true;



    _alreadyRespondingPriority = _group getVariable ["respondingToIntelPriority", 0];

    _currentTargetGroup = _group getVariable ["currentTargetGroup", nil];
    if (!isNil "_currentTargetGroup" && {typeName _currentTargetGroup == "GROUP" && {count ((units _currentTargetGroup) select {alive _x}) == 0}}) then {
        _alreadyRespondingPriority = 0; // Entire target group was destroyed so allow assigning a new target
    };



    _targetPriority = 1;

    _target = _x;
    _targetVehicleType = ((vehicle _target) call BIS_fnc_objectType) select 1;



    // Only tanks, helicopters, planes and APCs can attack APCs
    if (_targetVehicleType in ["TrackedAPC", "WheeledAPC"]) then {
        if (count (_typesOfVehiclesInGroup arrayIntersect ["TrackedAPC", "Tank", "WheeledAPC", "Helicopter", "Plane"]) == 0) then {
            _canRespond = false;
        } else {
            _targetPriority = 2;
        }
    };



    // Only tanks, helicopters and planes can attack tanks
    if (_targetVehicleType == "Tank") then {
        if (count (_typesOfVehiclesInGroup arrayIntersect ["Tank", "Helicopter", "Plane"]) == 0) then {
            _canRespond = false;
        } else {
            _targetPriority = 3;
        }
    };



    // Ignore this target if current target has higher priority
    if (_targetPriority < _alreadyRespondingPriority) then {
        _canRespond = false;
    };



    // Only air assets can catch up with other air assets
    if (_targetVehicleType in ["Helicopter", "Plane"] && {count (_typesOfVehiclesInGroup arrayIntersect ["Helicopter", "Plane"]) == 0}) then {
        _canRespond = false;
    };



    // Ignore this target if it is too far
    _distanceToTarget = _groupPos distance (getPos _x);
    if (_distanceToTarget > _maxResponseDistance) then {
        _canRespond = false;
    };



    if (_targetPriority == _alreadyRespondingPriority) then {
        _lastReportedTargetPosition = _group getVariable ["lastReportedTargetPosition", nil];

        if (_target == _currentTarget) then {
            if ((_lastReportedTargetPosition distance getPos _target) < 150) then {
                _canRespond = false; // This is the same target that was set previously and it is in about the same position
            };
        } else {
            _distanceToCurrentTarget = nil;
            if (!isNil "_lastReportedTargetPosition") then {
                _distanceToCurrentTarget = _groupPos distance _lastReportedTargetPosition;
            };

            if (!isNil "_distanceToCurrentTarget" && {_distanceToTarget > _distanceToCurrentTarget || {_distanceToCurrentTarget - _distanceToTarget < 200}}) then {
                _canRespond = false; //The suggested target is not that much closer than the current target, so stick to the old one
            };
        }
    };



    if (_canRespond == true) exitWith {
        _group setVariable ["lastReportedTargetPosition", getPos _target];
        _group setVariable ["respondingToIntelPriority", _targetPriority];
        _group setVariable ["currentTargetGroup", group _target];
        _group setVariable ["currentTarget", _target];

        [_group, (getPos _target)] call Rimsiakas_fnc_attackEnemy;
    };
} forEach _targets;

_group setVariable ["processingIntel", false];