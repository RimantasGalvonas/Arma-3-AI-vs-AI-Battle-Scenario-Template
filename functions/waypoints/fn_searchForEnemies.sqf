params ["_group", ["_destination", nil], ["_additionalWaypointStatements", ""], ["_waypointCondition", "true"]];



for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};

[_group] call Rimsiakas_fnc_unsetGroupTarget;



if (isNil "_destination") then {
    _destination = [[[getPos patrolCenter, (patrolCenter getVariable "patrolRadius") / 1.2]], ["water"]] call BIS_fnc_randomPos;
};



private _waypointRadius = 5;

private _groupHasVehicles = false;
{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;

if (_groupHasVehicles == true) then {
    _waypointRadius = 20;
} else {
    [_group, _destination] call Rimsiakas_fnc_createIntermediateMoveWaypoints;
};



// netId is used to get group in the statement rather than by (group this) due to some bug where "this" variable points to a unit from a different group
private _netId = _group call BIS_fnc_netId;
private _waypointStatements = format ["%1 _group = '%2' call BIS_fnc_groupFromNetId; [_group] call Rimsiakas_fnc_searchForEnemies;", _additionalWaypointStatements, _netId];

private _finalWaypoint = _group addWayPoint [_destination, 5];
_finalWaypoint setWaypointType "MOVE";
_finalWaypoint setWaypointStatements [_waypointCondition, _waypointStatements];