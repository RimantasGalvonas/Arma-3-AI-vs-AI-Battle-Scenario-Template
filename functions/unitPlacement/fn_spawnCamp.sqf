params ["_side", "_placer"];

if (typeName _side != "SIDE") then {
    throw "Param passed to the spawnCamp function must be a SIDE OBJECT, not a string. Use [opfor]/[blufor]/[independent]";
};

_placerPos = getPos _placer;
_minSpawnRadius = _placer getVariable "minSpawnRadius";
_maxSpawnRadius = _placer getVariable "maxSpawnRadius";
_compositionAzimuth = random 360;

if (isNil "campAreas") then {
    campAreas = [];
};


_compositions = call Rimsiakas_fnc_getCamps;
_composition = selectRandom _compositions;
_compositionSize = _composition select 1;
_compositionElements = _composition select 0;


// Find random position that fits the composition. If none can be found, clear any flattish area of terrain objects within the required radius and use that one.
_randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, _compositionSize, 0, 0.3, 0, campAreas, [[0,0],[0,0]]] call BIS_fnc_findSafePos;
if ((_randomPosition select 0) == 0) then {
    _randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, 5, 0, 0.3, 0, campAreas] call BIS_fnc_findSafePos;
    _terrainObjects = nearestTerrainObjects [_randomPosition, [], _compositionSize, false];

    {
        _x hideObjectGlobal true;
    } forEach _terrainObjects;
};



// Separate soldiers from objects
_compositionObjects = [];
_compositionUnits = [];
{
    _sim = getText (configFile >> "CfgVehicles" >> _x select 0 >> "simulation");

    if (_sim == "soldier") then {
        _compositionUnits append [_x];
    } else {
        _compositionObjects append [_x];
    };
} forEach _compositionElements;



// Spawn the composition (without units)
[_randomPosition, _compositionAzimuth, _compositionObjects] call Rimsiakas_fnc_objectsMapperWithATL;



// Register the area of this camp to prevent other camps on spawning at the same place
_topLeftCorner = [((_randomPosition select 0) - _compositionSize), ((_randomPosition select 1) + _compositionSize)];
_bottomRightCorner = [((_randomPosition select 0) + _compositionSize), ((_randomPosition select 1) - _compositionSize)];
campAreas append [[_topLeftCorner, _bottomRightCorner]];



// Pick a faction to use for the units in the composition
_activeSideFactions = [];
{
    if (_side == side _x) then {
        _unit = (units _x) select 0;
        _unitConfig = configFile >> "cfgVehicles" >> typeOf _unit;

        _activeSideFactions append [getText (_unitConfig >> "faction")];
    };
} forEach allGroups;
_activeSideFactions = _activeSideFactions arrayIntersect _activeSideFactions; // remove duplicates

_factionToUse = nil;

if (count _activeSideFactions > 0) then {
    _factionToUse = selectRandom _activeSideFactions;
} else {
    _allSideFactionsSearchString = format["getNumber (_x >> 'side') == %1", ([_side] call BIS_fnc_sideID)];
    _allSideFactions = _allSideFactionsSearchString configClasses (configFile >> "CfgFactionClasses");
    _factionToUse = selectRandom _allSideFactions;
    _factionToUse = configName _factionToUse;
};



// Assign soldiers with matching roles from the selected faction to the units in the composition
{
    _unitClass = _x select 0;
    _unitConfig = configFile >> "cfgVehicles" >> _unitClass;

    _role = getText (_unitConfig >> "role");

    _configSearchString = format ["getText (_x >> 'role') == '%1' && getText (_x >> 'faction') == '%2'", _role, _factionToUse];
    _matchingSoldiers = _configSearchString configClasses (configFile >> "CfgVehicles");

    if ((count _matchingSoldiers) == 0) then {
        _configSearchString = format ["getText (_x >> 'role') == 'Rifleman' && getText (_x >> 'faction') == '%1'", _factionToUse];
        _matchingSoldiers = _configSearchString configClasses (configFile >> "CfgVehicles");
    };

    _x append [_matchingSoldiers]; // Must compile them into an array and not just replace the class because there is no guarantee that the first selected config can actually spawn a soldier, so might have to try a few different ones. No idea why.
    _compositionUnits set [_forEachIndex, _x];
} foreach _compositionUnits;



// Create a group for the composition units
_group = createGroup [_side, true];
_group setVariable ["ignoreIntel", true];



// Define a function to rotate relative to composition center. Taken from BIS_fnc_objectsMapper
_multiplyMatrixFunc = {
    private ["_array1", "_array2", "_result"];
    _array1 = _this select 0;
    _array2 = _this select 1;

    _result =
    [
        (((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),
        (((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))
    ];

    _result;
};


// Spawn the units from correct factions in correct positions
{
    _relPos = _x select 1;
    _azimuth =  _x select 2;
    _init = _x select 7;

    private ["_rotMatrix", "_newRelPos", "_newPos"];
    _rotMatrix =
    [
        [cos _compositionAzimuth, sin _compositionAzimuth],
        [-(sin _compositionAzimuth), cos _compositionAzimuth]
    ];
    _newRelPos = [_rotMatrix, _relPos] call _multiplyMatrixFunc;

    _unitPosition = [((_randomPosition select 0) + (_newRelPos select 0)), ((_randomPosition select 1) + (_newRelPos select 1)), (_relPos select 2)];

    _soldier = nil;

    _matchingRoleSoldiers = _x select 10;
    {
        _unitClass = configName _x;
        _soldier = [(getPos patrolCenter), _azimuth + _compositionAzimuth, _unitClass, _group] call BIS_fnc_spawnVehicle;
        _soldier = _soldier select 0;
        if (typeOf _soldier != "") exitWith {}; // This needs to be done because some classes do not spawn a soldier. No idea why.
    } forEach _matchingRoleSoldiers;

    if (isNil "_soldier" == false) then {
        _soldier call (compile ("this = _this; " + _init));

        _soldier setVehiclePosition [_unitPosition, [], 0, "CAN_COLLIDE"];
    };
} foreach _compositionUnits;