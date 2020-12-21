params ["_group"];

_typesOfVehiclesInGroup = [];

{
    _vehicleClass = getText (configfile >> "CfgVehicles" >> (typeOf vehicle _x) >> "vehicleClass");
    _typesOfVehiclesInGroup append [_vehicleClass];
} forEach units _group;

_typesOfVehiclesInGroup = _typesOfVehiclesInGroup arrayIntersect _typesOfVehiclesInGroup; // Remove duplicates

_typesOfVehiclesInGroup;