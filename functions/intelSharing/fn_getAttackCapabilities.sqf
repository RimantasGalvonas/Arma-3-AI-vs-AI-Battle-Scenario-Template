params ["_group"];



_capabilitiesMap = createHashMap;
_capabilitiesMap set ["maxResponseDistance", patrolCenter getVariable ["maxInfantryResponseDistance", 500]];
_capabilitiesMap set ["shouldAbandonCurrentTarget", false];
_capabilitiesMap set ["allowStartNewSearch", false];
_capabilitiesMap set ["alreadyRespondingPriority", _group getVariable ["respondingToIntelPriority", 0]];
_capabilitiesMap set ["canAttackAPCs", false];
_capabilitiesMap set ["canAttackTanks", false];
_capabilitiesMap set ["canAttackAircraft", false];



//Get current types of vehicles in the group
private _typesOfVehiclesInGroup = [];

{
    private _targetVehicleType = (vehicle _x) call BIS_fnc_objectType;
    _typesOfVehiclesInGroup append [_targetVehicleType select 1];
} forEach units _group;

_typesOfVehiclesInGroup = _typesOfVehiclesInGroup arrayIntersect _typesOfVehiclesInGroup; // Remove duplicates



if (count (_typesOfVehiclesInGroup arrayIntersect ["TrackedAPC", "Tank", "WheeledAPC", "Helicopter", "Plane"]) > 0) then {
    _capabilitiesMap set ["canAttackAPCs", true];
};

if (count (_typesOfVehiclesInGroup arrayIntersect ["Tank", "Helicopter", "Plane"]) > 0) then {
    _capabilitiesMap set ["canAttackTanks", true];
};

if (count (_typesOfVehiclesInGroup arrayIntersect ["Helicopter", "Plane"]) > 0) then {
    _capabilitiesMap set ["canAttackAircraft", true];
};



// Get max response distance
if (count (_typesOfVehiclesInGroup arrayIntersect ["Car", "Motorcycle", "Ship", "Submarine", "TrackedAPC", "Tank", "WheeledAPC"]) > 0) then {
    _capabilitiesMap set ["maxResponseDistance", patrolCenter getVariable ["maxVehicleResponseDistance", 1000]];
};

if (count (_typesOfVehiclesInGroup arrayIntersect ["Helicopter", "Plane"]) > 0) then {
    _capabilitiesMap set ["maxResponseDistance", patrolCenter getVariable ["maxAirResponseDistance", 10000]];
};



// Free up tanks and air assets as soon as they've dealt with their target
private _currentTarget = _group getVariable ["currentTarget", nil];
if (count (_typesOfVehiclesInGroup arrayIntersect ["Tank", "Helicopter", "Plane"]) > 0) then {
    if (!isNil "_currentTarget" && {!alive _currentTarget || {count ((crew _currentTarget) select {alive _x}) == 0}}) then {
        _capabilitiesMap set ["shouldAbandonCurrentTarget", true];
    };
};

private _currentTargetGroup = _group getVariable ["currentTargetGroup", nil];

if (isNil "_currentTargetGroup" && {patrolCenter getVariable ["aiConfigUnlimitedIdleGroupResponseDistance", false]}) then {
    _capabilitiesMap set ["maxResponseDistance", 10e10];
};

// Reset _alreadyRespondingPriority to allow assigning a new target if the entire target group was destroyed.
// Not setting "shouldAbandonCurrentTarget" instead, because it would clear the lastReportedTargetPosition which might still be useful at this point.
if (!isNil "_currentTargetGroup" && {typeName _currentTargetGroup == "GROUP" && {count ((units _currentTargetGroup) select {alive _x && {!fleeing _x}}) == 0}}) then {
    _capabilitiesMap set ["alreadyRespondingPriority", 0];

    if (count (allGroups select {_x != _group && {side _x == side _group && {(leader _x) distance2D (_group getVariable "lastReportedTargetPosition") < 200}}}) > 0) then {
        // There are other friendly groups within the viscinity of the last target. Skip sweeping the area (SAD waypoint) in the case no new target is selected to decrease group clumping.
        _capabilitiesMap set ["allowStartNewSearch", true];
    };
};



_capabilitiesMap;