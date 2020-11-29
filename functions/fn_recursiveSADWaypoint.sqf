params ["_group"];
_waypoint = _group addWayPoint [patrolCenter, patrolCenter getVariable "patrolRadius"];
_waypoint setWaypointType "SAD";
_waypoint setWaypointStatements ["true", "deleteWaypoint [group this, currentWaypoint (group this)]; (group this) call Rimsiakas_fnc_recursiveSADWaypoint"];