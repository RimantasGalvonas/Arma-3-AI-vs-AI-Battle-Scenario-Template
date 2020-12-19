/*
    Author: Joris-Jan van 't Land (original function), Rimantas Galvonas (modifications to include units)

    Description:
    Converts a set of placed objects to an object array for the DynO mapper.
    Places this information in the debug output for processing.

    Parameter(s):
    _this select 0: position of the anchor point (Array)
    _this select 1: size of the covered area (Scalar)
    _this select 2: grab object orientation? (Boolean) [default: false]

    Returns:
    Ouput text (String)
*/

private ["_anchorPos", "_anchorDim", "_grabOrientation"];
_anchorPos = _this param [0, [0, 0], [[]]];
_anchorDim = _this param [1, 50, [-1]];
_grabOrientation = _this param [2, false, [false]];

private ["_objs"];
_objs = nearestObjects [_anchorPos, ["All"], _anchorDim];

//Formatting for output
private ["_br", "_tab", "_outputText"];
_br = toString [13, 10];
_tab = toString [9];

_outputText = "[" + _br;

//First filter illegal objects
{
    private ["_allDynamic"];
    _allDynamic = allMissionObjects "All";

    if (_x == player) then {
        _objs set [_forEachIndex, -1]; //Exclude player
    } else {
        if (_x in _allDynamic) then {
            //Exclude characters
            private ["_sim"];
            _sim = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "simulation");

            if (_sim in ["soldier"]) then {
                _x setVariable ["isSoldier", true];
            };
        } else {
            _objs set [_forEachIndex, -1]; //Exclude non-dynamic objects (world objects)
        };
    };

} forEach _objs;

_objs = _objs - [-1];

//Process remaining objects
{
    private ["_type", "_ATL", "_objPos", "_dX", "_dY", "_z", "_azimuth", "_fuel", "_damage", "_orientation", "_varName", "_init", "_simulation", "_replaceBy", "_outputArray"];
    _type = typeOf _x;
    _ATL = _x getVariable ["ATL", false] || {_x getVariable ["isSoldier", false]};
    if (!_ATL) then {_objPos = position _x;} else {_objPos = getPosATL _x;}; //To cover some situations (inside objects with multiple roadways)

    _dX = (_objPos select 0) - (_anchorPos select 0);
    _dY = (_objPos select 1) - (_anchorPos select 1);
    _z = _objPos select 2;
    _azimuth = direction _x;
    _fuel = fuel _x;
    _damage = damage _x;
    if (_grabOrientation) then {_orientation = _x call BIS_fnc_getPitchBank;} else {_orientation = [];};
    _varName = vehicleVarName _x;
    _init = _x getVariable ["init", ""];
    //TODO: re-enable once 3D editor simulation is fixed
    //_simulation = simulationEnabled _x;
    _simulation = _x getVariable ["simulation", true];

    _replaceBy = _x getVariable ["replaceBy", ""];
    if (_replaceBy != "") then {_type = _replaceBy;};

    _outputArray = [_type, [_dX, _dY, _z], _azimuth, _fuel, _damage, _orientation, _varName, _init, _simulation, _ATL];
    _outputText = _outputText + _tab + _tab + (str _outputArray);
    _outputText = if (_forEachIndex < ((count _objs) - 1)) then {_outputText + ", " + _br} else {_outputText + _br};

    debugLog (format ["Log: objectGrabber: %1", _outputArray]);
} forEach _objs;

_outputText = _outputText + _tab + "]";

_outputText = "[" + _br + _tab + _outputText + "," + _br + _tab + str _anchorDim + _br + "]";

copyToClipboard _outputText;

hint format ["%1 objects copied to clipboard.", str (count _objs)];

_outputText;