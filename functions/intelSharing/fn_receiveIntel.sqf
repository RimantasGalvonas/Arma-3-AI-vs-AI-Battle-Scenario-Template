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
private _targetPriority = nil;

_targets = _targets call BIS_fnc_arrayShuffle;

{
    private _target = _x;
    private _targetVehicleType = ((vehicle _target) call BIS_fnc_objectType) select 1;



    // Empty vehicle (or already dead unit)
    if (count ((crew _target) select {alive _x}) == 0) then {
        continue;
    };

    _targetPriority = 1;

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

    if (_targetVehicleType in ["Helicopter", "Plane"] && {!(_attackCapabilities get "canAttackAircraft")}) then {
        continue;
    };



    if (_targetPriority < _alreadyRespondingPriority) then {
        continue;
    };



    // Ignore this target if it is too far
    private _distanceToTarget = _groupPos distance (getPos _x);
    if (_distanceToTarget > _maxResponseDistance) then {
        continue;
    };



    if (_targetPriority == _alreadyRespondingPriority) then {
        private _lastReportedTargetPosition = _group getVariable ["lastReportedTargetPosition", nil];

        if (_target == _currentTarget) then {
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
} forEach _targets;



if (!isNil "_selectedNewTarget") then {
    [_group, _selectedNewTarget, _targetPriority] call Rimsiakas_fnc_attackEnemy;
} else {
    if (_attackCapabilities get "allowStartNewSearch") then {
        [_group] call Rimsiakas_fnc_searchForEnemies;
    };
};



_group setVariable ["processingIntel", false];