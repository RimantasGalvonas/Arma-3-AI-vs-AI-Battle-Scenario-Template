params ["_group", ["_destination", nil], ["_additionalWaypointStatements", ""], ["_waypointCondition", "true"]];



for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};



_waypointRadius = 5;
_waypointStatements = format ["%1 (group this) call Rimsiakas_fnc_recursiveSADWaypoint;", _additionalWaypointStatements];



if (isNil "_destination") then {
    _destination = [[[getPos patrolCenter, (patrolCenter getVariable "patrolRadius") / 2]], ["water"]] call BIS_fnc_randomPos;
};



_groupHasVehicles = false;
{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;



if (_groupHasVehicles == true) then {
    _waypointRadius = 20;
} else {
    [_group, _destination] call Rimsiakas_fnc_createIntermediateMoveWaypoints;
};



_finalWaypoint = _group addWayPoint [_destination, 5];
_finalWaypoint setWaypointType "SAD";
_finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];