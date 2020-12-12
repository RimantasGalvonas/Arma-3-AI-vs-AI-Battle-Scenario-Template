params ["_placer", "_groupConfig", ["_isHighCommand", false]];

_placerPos = getPos _placer;
_minSpawnRadius = _placer getVariable "minSpawnRadius";
_maxSpawnRadius = _placer getVariable "maxSpawnRadius";

_actuallyVehicleClasses = ["Car", "Armored", "Air", "Support"];
_newGroup = nil;

if (typeName _groupConfig == "CONFIG") then {
    _newGroupArray = [];
    _units = [_groupConfig] call Bis_fnc_getCfgSubClasses;
    {
        _unitConfig = _groupConfig >> _x;
        _vehicle = getText (_unitConfig >> "vehicle");
        _unitClassName = configName (configFile >> "cfgVehicles" >> _vehicle);
        _newGroupArray append [_unitClassName];
    } foreach _units;

    _groupConfig = _newGroupArray;
};

if (typeName _groupConfig == "ARRAY") then {
    _vehicleConfig = configFile >> "cfgVehicles" >> (_groupConfig select 0);;
    _sideId = getNumber (_vehicleConfig >> "side");
    _side = _sideId call BIS_fnc_sideType;

    _newGroup = createGroup [_side, true];

    {
        _unitPosition = [getPos _placer, 0, 1000, 3, 0, 0.6, 0] call BIS_fnc_findSafePos; // Very basic temporary position search. The real repositioning is done in Rimsiakas_fnc_teleportSquadToRandomPosition
        [_unitPosition, 0, _x, _newGroup] call BIS_fnc_spawnVehicle;
    } foreach _groupConfig;
};

[_newGroup, _placerPos, _minSpawnRadius, _maxSpawnRadius, 0, 0.6, 0] call Rimsiakas_fnc_teleportSquadToRandomPosition;

if (!_isHighCommand || {_placer getVariable ["highCommandSubordinates", false] == false}) then {
    _newGroup call Rimsiakas_fnc_recursiveSADWaypoint;
    _newGroup call Rimsiakas_fnc_orientGroupTowardsWaypoint;
} else {
    player hcSetGroup [_newGroup];
};