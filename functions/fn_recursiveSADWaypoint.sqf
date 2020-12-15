params ["_group", ["_finalWaypointPos", nil], ["_additionalWaypointStatements", ""]];

// delete all waypoints
for "_i" from count (waypoints _group) - 1 to 0 step -1 do {
    deleteWaypoint [_group, _i];
};

_waypointStatements = format ["%1 (group this) call Rimsiakas_fnc_recursiveSADWaypoint;", _additionalWaypointStatements];

_groupHasVehicles = false;
{
    if ((vehicle _x) != _x) exitWith {_groupHasVehicles = true};
} forEach units _group;


if (_groupHasVehicles == true) exitWith {
    if (isNil "_finalWaypointPos") then {
        _finalWaypointPos = [[[getPos patrolCenter, (patrolCenter getVariable "patrolRadius") / 2]], ["water"]] call BIS_fnc_randomPos;
    };
    _waypoint = _group addWayPoint [_finalWaypointPos, 20];
    _waypoint setWaypointType "SAD";
    _waypoint setWaypointStatements ["true", _waypointStatements];
};


_waypointStepDistance = 100;

_startingPos = getPos (leader _group);

if (isNil "_finalWaypointPos") then {
    _finalWaypointPos = [[[getPos patrolCenter, (patrolCenter getVariable "patrolRadius") / 2]], ["water"]] call BIS_fnc_randomPos;
};
_preferablePosition = selectBestPlaces[_finalWaypointPos, (_waypointStepDistance / 2), "houses + trees + hills - (100 * waterDepth)", 5, 1];
_preferablePosition = (_preferablePosition select 0) select 0;
_preferablePosition = [_preferablePosition, 0, 10, 1] call BIS_fnc_findSafePos; // To avoid placing waypoints inside houses. Makes the units get stuck

// TODO: check if water intercepts the two locations and skip this shit if it does

_distance = _startingPos distance _finalWaypointPos;
if (_distance > 2000) then {
    _waypointStepDistance = _distance / 10;
};

_lastPos = _startingPos;
while {_distance > (_waypointStepDistance * 1.5)} do {
    _dir = _lastPos getDir _finalWaypointPos;

    // Infantry should prefer moving between high ground, trees and buildings
    _intermediatePosition = _lastPos getPos [_waypointStepDistance, _dir];
    _preferablePosition = selectBestPlaces[_intermediatePosition, (_waypointStepDistance / 2), "houses + trees + hills - (100 * waterDepth)", 5, 1];
    _preferablePosition = (_preferablePosition select 0) select 0;

    if (surfaceIsWater _preferablePosition == false) then {
        _preferablePosition = [_preferablePosition, 0, 10, 1] call BIS_fnc_findSafePos; // To avoid placing waypoints inside houses. Makes the units get stuck

        _intermediateWaypoint = _group addWayPoint [_preferablePosition, 5];
        _intermediateWaypoint setWaypointType "MOVE";
    };

    _distance = _preferablePosition distance _finalWaypointPos;

    _lastPos = _preferablePosition;
};

_finalWaypoint = _group addWayPoint [_finalWaypointPos, 5];
_finalWaypoint setWaypointType "SAD";
_waypointStatements = format ["%1 (group this) call Rimsiakas_fnc_recursiveSADWaypoint;", _additionalWaypointStatements];
_finalWaypoint setWaypointStatements ["true", _waypointStatements];