params ["_group"];

_waypointPosition = waypointPosition [_group, currentWaypoint _group];
if ((_waypointPosition isEqualTo [0,0,0]) == false) then {
    {
        _dir = (vehicle _x) getDir _waypointPosition;
        (vehicle _x) setDir _dir;
    } forEach units _group;
};