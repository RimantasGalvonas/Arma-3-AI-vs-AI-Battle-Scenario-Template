params ["_side", "_placer"];

_placerPos = getPos _placer;
_minSpawnRadius = _placer getVariable "minSpawnRadius";
_maxSpawnRadius = _placer getVariable "maxSpawnRadius";

if (isNil "campAreas") then {
    campAreas = [];
};

if (typeName _side != "SIDE") then {
    throw "Param passed to the spawnCamp function must be a SIDE OBJECT, not a string. Use [opfor]/[blufor]/[independent]";
};

// TODO: refactor this completely. The spaghettiest of all spaghetti code.

// Explanation on how to get this is at the bottom
_composition = [[["Land_MedicalTent_01_wdl_closed_F",[-1.71948,8.01758,0],358.243,1,0,[0,0],"","",true,false],["Land_Cargo_House_V1_F",[0.54834,-11.7954,0],178.528,1,0,[0,-0],"","",true,false],["Land_FieldToilet_F",[-12.7649,-4.70313,0.0310001],270.259,1,0,[0,0],"","",false,false],["Land_Cargo20_military_green_F",[-6.66309,-12.2012,0.145],90.138,1,0,[0,-0],"","",false,false],["Land_FieldToilet_F",[-12.7319,-5.99414,0.0310001],270.259,1,0,[0,0],"","",false,false],["Land_HBarrier_01_wall_6_green_F",[0.717529,15.5063,0],359.596,1,0,[0,0],"","",true,false],["Land_FieldToilet_F",[-12.7881,-7.2749,0.0310001],270.259,1,0,[0,0],"","",false,false],["Land_HBarrier_01_wall_6_green_F",[16.4167,-2.38818,0],90.306,1,0,[0,-0],"","",true,false],["Land_HBarrier_01_big_tower_green_F",[11.1316,-10.7217,0],359.21,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[-15.8462,-5.84082,0],270.779,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[-7.5813,15.353,0],359.596,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[1.49097,-17.2192,0],180.27,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_4_green_F",[-14.6992,6.87793,0],269.78,1,0,[0,0],"","",true,false],["Land_Cargo_Patrol_V4_F",[13.0374,10.2637,0],268.632,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[8.94458,15.5283,0],359.596,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[-6.79126,-17.4731,0],180.27,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_4_green_F",[15.447,-9.65869,0],89.691,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_6_green_F",[9.83374,-16.9941,0],180.27,1,0,[0,0],"","",true,false],["Land_HBarrier_01_big_4_green_F",[-18.6191,2.93555,0],359.674,1,0,[0,0],"","",true,false],["Land_HBarrier_01_big_4_green_F",[18.7832,2.39014,0],180.008,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_4_green_F",[16.1584,10.106,0],91.1212,1,0,[0,-0],"","",true,false],["Land_HBarrier_01_big_tower_green_F",[-14.4202,13.1167,0],135.273,1,0,[0,-0],"","",true,false],["Land_HBarrier_01_tower_green_F",[-14.1538,-14.3711,0],0,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_corner_green_F",[15.5193,14.5381,0],359.001,1,0,[0,0],"","",true,false],["Land_HBarrier_01_wall_corner_green_F",[15.3337,-15.2241,0],90.1587,1,0,[0,-0],"","",true,false],["Land_HBarrier_01_big_4_green_F",[-22.071,-2.67236,0],88.1191,1,0,[0,0],"","",true,false],["Land_HBarrier_01_big_4_green_F",[23.4075,7.66064,0],88.1191,1,0,[0,0],"","",true,false]],[["I_E_soldier_M_F",[12.6472,11.814,4.34548],0],["I_E_Soldier_F",[15.4084,-15.7798,1.24882],125.499],["I_E_Soldier_AR_F",[-14.928,13.7671,2.28173],309.687],["I_E_Soldier_AR_F",[-15.1064,-16.2832,2.78144],188.344],["I_E_Soldier_F",[11.1025,-11.5288,2.28173],173.042]]];

_compositionSize = 30; // TODO: calculate

// Find random position that fits the composition. If none can be found, clear any flattish area of terrain objects within the required radius and use that one.
_randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, _compositionSize, 0, 0.3, 0, campAreas, [[0,0],[0,0]]] call BIS_fnc_findSafePos;
if ((_randomPosition select 0) == 0) then {
    _randomPosition = [_placerPos, _minSpawnRadius, _maxSpawnRadius, 5, 0, 0.3, 0, campAreas] call BIS_fnc_findSafePos;
    _terrainObjects = nearestTerrainObjects [_randomPosition,[], _compositionSize, false];

    {
        _x hideObjectGlobal true;
    } forEach _terrainObjects;
};

_compositionObjects = _composition select 0;
_compositionUnits = _composition select 1;

// Spawn the composition (without units)
[_randomPosition, 0, _composition select 0] call BIS_fnc_objectsMapper;

// Register the area of this camp to prevent other camps on spawning at the same place
_topLeftCorner = [((_randomPosition select 0) - _compositionSize), ((_randomPosition select 1) + _compositionSize)];
_bottomRightCorner = [((_randomPosition select 0) + _compositionSize), ((_randomPosition select 1) - _compositionSize)];
campAreas append [[_topLeftCorner, _bottomRightCorner]];

// Get a list of factions of the given side that are active in the mission;
/*_enemyFactions = [];
{
    if ([side player, side _x] call BIS_fnc_sideIsEnemy) then {
        _enemyUnit = (units _x) select 0;
        _enemyUnitConfig = configFile >> "cfgVehicles" >> typeOf _enemyUnit;
        _enemyFactions append [getText (_enemyUnitConfig >> "faction")];
    };
} forEach allGroups;
_enemyFactions = _enemyFactions arrayIntersect _enemyFactions; // remove duplicates*/


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
    _x append [_matchingSoldiers]; // Must compile them into an array and not just replace the class because there is no guarantee that the first selected config can actually spawn a soldier, so might have to try a few different ones. No idea why.
    _compositionUnits set [_forEachIndex, _x];
} foreach _compositionUnits;

// Create a group for the composition units
_group = createGroup _side;

// Spawn the units from correct factions in correct positions
{
    _relPos = _x select 1;
    _azimuth =  _x select 2;

    _unitPosition = [((_randomPosition select 0) + (_relPos select 0)), ((_randomPosition select 1) + (_relPos select 1)), (_relPos select 2)];

    _soldier = nil;

    _matchingRoleSoldiers = _x select 3;
    {
        _unitClass = configName _x;
        _soldier = [(getPos patrolCenter), _azimuth, _unitClass, _group] call BIS_fnc_spawnVehicle;
        _soldier = _soldier select 0;
        if (typeOf _soldier != "") exitWith {}; // This needs to be done because some classes do not spawn a soldier. No idea why.
    } forEach _matchingRoleSoldiers;

    if (isNil "_soldier") then {
        hint _unitClass;
    } else {
        doStop _soldier;
        commandStop _soldier;

        _soldier setVehiclePosition [_unitPosition, [], 0, "CAN_COLLIDE"];
    };
} foreach _compositionUnits;


// TODO: should modify the existing BIS_fnc_ObjectsGrabber and BIS_fnc_objectsMapper to support units instead. Would make the process simpler and that would support rotation of the entire thing

// Had to use inline comments for this because there is a multiline comment delimiter in the logic below.
// The _composition array was generated like this:
// 1. Open a mission in Virtual Reality terrain
// 2. Create a composition, place units around it.
// 3. Place a Logic Entity somewhere. Enter this into its init box:
//     buildFullCompositionArray = {
//         params ["_triggerUnits", "_trigger"];

//         _compositionUnits = [];
//         {
//             _unit = _x;
//             _unitConfig = configFile >> "cfgVehicles" >> typeOf _unit;
//             if (_unit != player && getText (_unitConfig >> "vehicleClass") == "Men") then {
//                 _unitPos = getPos _unit;
//                 _triggerPos = getPos _trigger;
//                 _relPos = [((_unitPos select 0) - (_triggerPos select 0)), ((_unitPos select 1) - (_triggerPos select 1))];
//                 _unitHeight = (getPosATL _unit) select 2;
//                 _compositionUnit = [typeOf _unit, _relPos, _unitHeight];
//                 _compositionUnits append [_compositionUnit];
//             };
//         } forEach _triggerUnits;

//         _compositionObjectsString = copyFromClipboard;
//         _endOfCommentPos = _compositionObjectsString find "*/";
//         _compositionObjectsString = [_compositionObjectsString, _endOfCommentPos + 2] call BIS_fnc_trimString;
//         _compositionObjects = parseSimpleArray _compositionObjectsString;
//         _fullComposition = [_compositionObjects, _compositionUnits];
//         copyToClipboard str _fullComposition;
//         hint "Composition objects and units copied to clipboard";
//     };

// 4. Place a round trigger on the composition. It must be large enough for the entire composition.
//    Set its activation to "Anybody" and activation type to "Present".
//    Enter this into it's condition box:
//      player in thisList;
//    Enter this into it's on activation box:
//      [getPos thisTrigger, 28, true] call BIS_fnc_ObjectsGrabber;
//      [thisList, thisTrigger] call buildFullCompositionArray;
//    The 28 above is the radius of the trigger. Adjust it to match your trigger.
// 5. Enter the composition. An array like that will be copied to your clipboard;
// 6. If an object flies into the air or something after spawning, add this to its init box before building the array: this setVariable ["simulation", false];