_gridSize = patrolCenter getVariable "intelGridSize";
if (_gridSize == 0) exitWith {};

_middlePos = getPos patrolCenter;
_patrolRadius = (patrolCenter getVariable "patrolRadius") * 1.5;
_centerGridStartX = floor ((_middlePos select 0) / _gridSize) * _gridSize + _gridSize / 2;
_centerGridStartY = floor ((_middlePos select 1) / _gridSize) * _gridSize + _gridSize / 2;
_gridStartY = floor ((_middlePos select 1) / _gridSize) * _gridSize + _gridSize / 2;
_leftmostGrid = (_centerGridStartX - floor (_patrolRadius / 2));
_rightmostGrid = (_centerGridStartX + ceil (_patrolRadius / 2));
_topGrid = (_centerGridStartY - floor (_patrolRadius / 2));
_bottomGrid = (_centerGridStartY + ceil (_patrolRadius / 2));

for "_i" from _leftmostGrid to _rightmostGrid step _gridSize do {
    for "_j" from _topGrid to _bottomGrid step _gridSize do {
        _markerName = "MarkerX" + str _i + "Y" + str _j;
        _marker = createMarker [_markerName, [_i, _j]];
        _marker setMarkerShape "RECTANGLE";
        _marker setMarkerAlpha 0.5;
        _marker setMarkerSize [(_gridSize / 2), ((_gridSize / 2))];

        _trg = createTrigger ["EmptyDetector", [_i, _j]];
        _trg setVariable ["attachedMarker", _marker];
        _trg setTriggerArea [_gridSize, _gridSize, 0, true];
        _trg setTriggerActivation ["ANY", "PRESENT", true];
        _triggerActivation = "{
            _isEnemy = [side player, side _x] call BIS_fnc_sideIsEnemy;
            if (_isEnemy == true) exitWith {
                _color = [side _x, true] call BIS_fnc_sideColor;
                (thisTrigger getVariable ""attachedMarker"") setMarkerColor _color;
            };
        } forEach thisList;";
        _trg setTriggerStatements ["this", _triggerActivation, "(thisTrigger getVariable ""attachedMarker"") setMarkerColor ""ColorBLACK"""];
    }
};