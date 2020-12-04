params ["_group", "_centerPos", "_minimumDistance", "_maximumDistance", "_maxGradient", "_waterMode", "_shoreMode"];

_groupLeader = leader _group;

_groupHasVehicles = false;
_maxDistanceFromLeader = 0;
{
    _relDis = _x distance _groupLeader;

    if (_relDis > _maxDistanceFromLeader) then {
        _maxDistanceFromLeader = _relDis;
    };

    if ((vehicle _x) isKindOf "landVehicle") then {
        _groupHasVehicles = true;
    };
} forEach units _group; // TODO: this max distance calculation is kind of similar to fn_calculateRequiredAreForGroup. Might need refactoring

if (_groupHasVehicles == false) then {
    _maxDistanceFromLeader = 5;
};

_randomPosition = [_centerPos, _minimumDistance, _maximumDistance, _maxDistanceFromLeader, _waterMode, _maxGradient, _shoreMode] call BIS_fnc_findSafePos;

_alreadyTeleportedVehicles = [];

{
    if (_x != _groupLeader) then {
        _vehicle = vehicle _x;

        if (_vehicle != vehicle _groupLeader && {!(_vehicle in _alreadyTeleportedVehicles)}) then {
            _relDis = _vehicle distance _groupLeader;
            _relDir = [_groupLeader, _vehicle] call BIS_fnc_relativeDirTo;
            _vehicle setPos ([_randomPosition, _relDis, _relDir] call BIS_fnc_relPos);
            _alreadyTeleportedVehicles append [_vehicle];
        };
    };
} forEach units _group;

(vehicle _groupLeader) setPos _randomPosition;