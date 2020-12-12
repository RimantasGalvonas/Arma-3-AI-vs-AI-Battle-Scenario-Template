params ["_group", "_targets"];

if (behaviour (leader _group) == "combat") exitWith {}; // Already engaged

if ((isNull hcLeader (_group)) == false) exitWith {}; // Has high commander

_groupPos = getPos (leader _group);

_hasTanksInGroup = false;

{
    _vehicleConfig = configFile >> "cfgVehicles" >> (typeOf vehicle _x);
    _vehicleClass = getText (_vehicleConfig >> "vehicleClass");
    if (_vehicleClass == "Armored") exitWith {
        _hasTanksInGroup = true;
    };
} forEach (units _group);

{
    _canRespond = true;

    _alreadyRespondingPriority = _group getVariable ["respondingToIntelPriority", 0];
    _targetPriority = 1;

    _target = _x;
    _targetVehicleConfig = configFile >> "cfgVehicles" >> (typeOf vehicle _target);
    _targetVehicleClass = getText (_targetVehicleConfig >> "vehicleClass");

    if (_targetVehicleClass == "Armored") then {
        _targetPriority = 2;
    };

    if (_targetPriority <= _alreadyRespondingPriority) then {
        _canRespond = false;
    };

    if (_targetVehicleClass == "Armored" && _hasTanksInGroup == false) then {
        _canRespond = false;
    };

    if ((_groupPos distance (getPos _x)) > (500 * _targetPriority)) then {
        _canRespond = false;
    };

    if (_canRespond == true) exitWith {
        _group setVariable ["respondingToIntelPriority", _targetPriority];
        [_group, (getPos _target), "(group this) setVariable ['respondingToIntelPriority', 0];"] call Rimsiakas_fnc_recursiveSADWaypoint;
    };
} forEach _targets;