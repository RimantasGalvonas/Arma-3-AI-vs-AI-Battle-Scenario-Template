params ["_group", "_duration"];

_waypointIndex = currentWaypoint _group;

_waypointPreConditionCheckTime = _group getVariable ["waypointPreConditionCheckTime", nil];

if (isNil "_waypointPreConditionCheckTime") then {
    _waypointPreConditionCheckTime = time;
    _group setVariable ["waypointPreConditionCheckTime", _waypointPreConditionCheckTime];
};

_enoughTimePassed = false;

if (time - _waypointPreConditionCheckTime > _duration) then {
    _enoughTimePassed = true;
    _group setVariable ["waypointPreConditionCheckTime", nil];
};

_enoughTimePassed;