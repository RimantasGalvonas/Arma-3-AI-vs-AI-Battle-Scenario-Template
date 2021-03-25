params ["_placer", "_groupConfig"];

private _placerPos = getPos _placer;
private _minSpawnRadius = _placer getVariable "minSpawnRadius";
private _maxSpawnRadius = _placer getVariable "maxSpawnRadius";



private _actuallyVehicleClasses = ["Car", "Armored", "Air", "Support"];
private _newGroup = nil;



// Convert from group config to units array
if (typeName _groupConfig == "CONFIG") then {
    private _newGroupArray = [];
    private _units = [_groupConfig] call Bis_fnc_getCfgSubClasses;
    {
        private _unitConfig = _groupConfig >> _x;
        private _vehicle = getText (_unitConfig >> "vehicle");
        private _unitClassName = configName (configFile >> "cfgVehicles" >> _vehicle);
        _newGroupArray append [_unitClassName];
    } foreach _units;

    _groupConfig = _newGroupArray;
};



if (typeName _groupConfig == "ARRAY") then {
    private _vehicleConfig = configFile >> "cfgVehicles" >> (_groupConfig select 0);;
    private _sideId = getNumber (_vehicleConfig >> "side");
    private _side = _sideId call BIS_fnc_sideType;

    _newGroup = createGroup [_side, true];

    {
        private _unitPosition = [getPos _placer, 0, 1000, 3, 0, 0.6, 0] call BIS_fnc_findSafePos; // Very basic temporary position search. The real repositioning is done in Rimsiakas_fnc_teleportSquadToRandomPosition
        private _spawnedUnit = [_unitPosition, 0, _x, _newGroup] call BIS_fnc_spawnVehicle;
        (_spawnedUnit select 0) disableAI "all"; // Temporarily disabled to avoid firefights breaking out while mission is initializing
    } foreach _groupConfig;
};



[_newGroup, _placerPos, _minSpawnRadius, _maxSpawnRadius, 0, 0.6, 0] call Rimsiakas_fnc_teleportSquadToRandomPosition;



if (G_Revive_System == true) then {
    (units _newGroup) spawn G_fnc_initNewAI;
};



if ("Support" in ([_newGroup] call Rimsiakas_fnc_getVehicleClassesInGroup)) then {
    _newGroup setVariable ["ignoreIntel", true];
    private _waypoint = _newGroup addWaypoint [(getPos leader _newGroup), 0];
    _waypoint setWaypointType "SUPPORT";
} else {
    [_newGroup] call Rimsiakas_fnc_searchForEnemies;
    [_newGroup] call Rimsiakas_fnc_orientGroupTowardsWaypoint;

    if (_placer getVariable ["highCommandSubordinates", false]) then {
        Rimsiakas_highCommandSubordinates append [_newGroup];
    };
};