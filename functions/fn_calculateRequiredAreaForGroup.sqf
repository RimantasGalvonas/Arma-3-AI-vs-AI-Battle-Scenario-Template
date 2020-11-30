params ["_groupConfig"];

_groupVehicles = [];
_actuallyVehicleClasses = ["Car", "Armored", "Air", "Support"];

_maxVehicleX = 0;
_maxVehicleY = 0;

_units = [_groupConfig] call Bis_fnc_getCfgSubClasses;

{
    _unitConfig = _groupConfig >> _x;
    _vehicle = getText (_unitConfig >> "vehicle");
    _vehicleConfig = configFile >> "cfgVehicles" >> _vehicle;
    _vehicleClass = getText (_vehicleConfig >> "vehicleClass");

    if (_vehicleClass in _actuallyVehicleClasses) then {
        _groupVehicles append [_unitConfig];
        _position = getArray (_unitConfig >> "position");
        _unitX = abs (_position select 0);
        _unitY = abs (_position select 1);
        if (_unitX > _maxVehicleX) then {
            _maxVehicleX = _unitX;
        };
        if (_unitY > _maxVehicleY) then {
            _maxVehicleY = _unitY;
        };
    };
} foreach _units;

if ((count _groupVehicles) == 0) then {
    0;
} else {
    (_maxVehicleX max _maxVehicleY) + 5;
}