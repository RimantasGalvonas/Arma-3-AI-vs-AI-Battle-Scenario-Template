_gridSize = patrolCenter getVariable ["intelGridSize", 0];

if (_gridSize == 0) exitWith {};


// Delete old grid if it exists
if (!isNil "intelGridTriggers") then {
    {
        deleteMarkerLocal (_x getVariable ["attachedMarker", ""]);
        deleteVehicle _x;
    } forEach intelGridTriggers;
} else {
    intelGridTriggers = [];
};



_middlePos = getPos patrolCenter;
_patrolRadius = (patrolCenter getVariable "patrolRadius");
_leftmostGrid = (_middlePos select 0) - _patrolRadius + (_gridSize / 2);
_rightmostGrid = (_middlePos select 0) + _patrolRadius;
_topGrid = (_middlePos select 1) - _patrolRadius + (_gridSize / 2);
_bottomGrid = (_middlePos select 1) + _patrolRadius - (_gridSize / 2);

for "_i" from _leftmostGrid to _rightmostGrid step _gridSize do {
    for "_j" from _topGrid to _bottomGrid step _gridSize do {
        _markerName = "MarkerX" + str _i + "Y" + str _j + str player;
        _marker = createMarkerLocal [_markerName, [_i, _j]];
        _marker setMarkerShapeLocal "RECTANGLE";
        _marker setMarkerAlphaLocal 0.5;
        _marker setMarkerSizeLocal [(_gridSize / 2), ((_gridSize / 2))];

        _trg = createTrigger ["EmptyDetector", [_i, _j], false];
        _trg setVariable ["attachedMarker", _marker];
        _trg setTriggerArea [(_gridSize / 2), (_gridSize / 2), 0, true];
        _trg setTriggerActivation ["ANY", "PRESENT", true];
        _triggerCondition = "_enemiesDetected = false;
        {
            _isEnemy = [side player, side _x] call BIS_fnc_sideIsEnemy;
            if (_isEnemy == true) exitWith {_enemiesDetected = true};
        } forEach thisList;
        _enemiesDetected";
        _triggerActivation = "{
            _isEnemy = [side player, side _x] call BIS_fnc_sideIsEnemy;
            if (_isEnemy == true) exitWith {
                _color = [side _x, true] call BIS_fnc_sideColor;
                (thisTrigger getVariable ""attachedMarker"") setMarkerColorLocal _color;
            };
        } forEach thisList;";
        _trg setTriggerStatements [_triggerCondition, _triggerActivation, "(thisTrigger getVariable ""attachedMarker"") setMarkerColorLocal ""ColorBLACK"""];

        intelGridTriggers append [_trg];
    }
};