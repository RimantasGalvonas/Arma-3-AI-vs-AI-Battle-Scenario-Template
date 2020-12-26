params ["_playerUnit", "_didJIP"];



waitUntil {(!isNil "Rimsiakas_missionInitialized" && {Rimsiakas_missionInitialized == true})};



_syncedHighCommandModules = (synchronizedObjects _playerUnit) select {typeOf _x == "HighCommand"};

if (count _syncedHighCommandModules > 0) then {
    _subordinates = Rimsiakas_highCommandSubordinates select {side _x == side _playerUnit}; // Note to self: no need to worry about support groups here - they should not be included in the Rimsiakas_highCommandSubordinates in the first place
    {
        (hcLeader _x) hcRemoveGroup _x; // Unset previous commander (don't know why, but it's recommended)
        _playerUnit hcSetGroup [_x];

        if (!_didJIP) then {
            // delete all waypoints
            for "_i" from count (waypoints _x) - 1 to 0 step -1 do {
                deleteWaypoint [_x, _i];
            };

            // Make them stop at their current position
            _x setVariable ["respondingToIntelPriority", 0];
            _waypoint = _x addWaypoint [(getPos leader _x), 0];
            _waypoint setWaypointType "MOVE";
        }
    } forEach _subordinates;
};