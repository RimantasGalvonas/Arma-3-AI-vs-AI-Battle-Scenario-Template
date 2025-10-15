params ["_group", "_targets"];

if (isPlayer (hcLeader _group)) exitWith {}; // Has high commander
if (_group getVariable ["ignoreIntel", false]) exitWith {};
if (_group getVariable ["processingIntel", false]) exitWith {}; // Prevents multiple instances of this script being run for this group due to some scheduling nonsense
if (getText ((configOf (units _group select 0)) >> "simulation") == "UAVPilot") exitWith {};

_group setVariable ["processingIntel", true];

_attackCapabilities = [_group] call Rimsiakas_fnc_getAttackCapabilities;

if (_attackCapabilities get "shouldAbandonCurrentTarget") then {
    [_group] call Rimsiakas_fnc_unsetGroupTarget;
};

private _groupPos = getPos (leader _group);

private _currentTarget = _group getVariable ["currentTarget", nil];

private _maxResponseDistance = _attackCapabilities get "maxResponseDistance";

private _alreadyRespondingPriority = _attackCapabilities get "alreadyRespondingPriority";

private _selectedNewTarget = nil;
private _selectedNewTargetPriority = 0;

// Sort from furthest to closest, so that once the entire target list is looped through, the last found suitable target would be the closest.
_targets = [_targets, [leader _group], { _input0 distance _x }, "DESCEND"] call BIS_fnc_sortBy;

{
    private _target = _x;
    private _targetVehicleType = ((vehicle _target) call BIS_fnc_objectType) select 1;


    
    // Empty vehicle (or already dead unit)
    if (count ((crew _target) select {alive _x}) == 0) then {
        continue;
    };

    // Ignore this target if it is too far
    private _distanceToTarget = _groupPos distance (getPos _x);
    if (_distanceToTarget > _maxResponseDistance) then {
        continue;
    };

    if (_targetVehicleType in ["Helicopter", "Plane"] && {!(_attackCapabilities get "canAttackAircraft")}) then {
        continue;
    };



    private _targetPriority = 1;

    if (_targetVehicleType in ["TrackedAPC", "WheeledAPC"]) then {
        if (_attackCapabilities get "canAttackAPCs") then {
            _targetPriority = 2;
        } else {
            continue;
        };
    };

    if (_targetVehicleType == "Tank") then {
        if (_attackCapabilities get "canAttackTanks") then {
            _targetPriority = 3;
        } else {
            continue;
        };
    };



    // TODO: should actually only pay attention to other FRIENDLY units. Might be that there's a scenario where three hostile factions are fighting.
    private _targetAlreadyAttackedBy = (group _target) getVariable ["targetedBy", []];

    // TODO: should add a GUI config for this number? Make sure the number is also updated in fn_afterTargetChange.sqf if I update this.
    // The second part of the condition is there to allow the current target to reach the "_lastReportedTargetPosition" part.
    if (count _targetAlreadyAttackedBy > 2 && {!(group _target isEqualTo (_group getVariable ["currentTargetGroup", false]))}) then {
        continue;
    };

    _targetPriority = _targetPriority - (0.33 * (count _targetAlreadyAttackedBy));



    if (_targetPriority < (_alreadyRespondingPriority max _selectedNewTargetPriority)) then {
        continue;
    };



    if (_targetPriority == _alreadyRespondingPriority) then {
        private _lastReportedTargetPosition = _group getVariable ["lastReportedTargetPosition", nil];

        if (!isNil "_currentTarget" && {_target == _currentTarget}) then {
            if ((_lastReportedTargetPosition distance getPos _target) < 150) then {
                continue; // This is the same target that was set previously and it is in about the same position
            };
        } else {
            private _distanceToCurrentTarget = nil;
            if (!isNil "_lastReportedTargetPosition") then {
                _distanceToCurrentTarget = _groupPos distance _lastReportedTargetPosition;
            };

            if (!isNil "_distanceToCurrentTarget" && {_distanceToTarget > _distanceToCurrentTarget || {_distanceToCurrentTarget - _distanceToTarget < 200}}) then {
                continue; //The suggested target is not that much closer than the current target, so stick to the old one
            };
        };
    };



    _selectedNewTarget = _target;
    _selectedNewTargetPriority = _targetPriority;
} forEach _targets;

if (!isNil "_selectedNewTarget") then {
    [_group, _selectedNewTarget, _selectedNewTargetPriority] call Rimsiakas_fnc_attackEnemy;
} else {
    if (_attackCapabilities get "allowStartNewSearch") then {
        [_group] call Rimsiakas_fnc_searchForEnemies;
    };
};



_group setVariable ["processingIntel", false];