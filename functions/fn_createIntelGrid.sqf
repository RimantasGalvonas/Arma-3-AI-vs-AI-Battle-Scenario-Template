private _gridSize = patrolCenter getVariable ["intelGridSize", 0];



// Delete old grid if it exists
if (!isNil "intelGridTriggers") then {
    {
        deleteMarkerLocal (_x getVariable ["attachedMarker", ""]);
        deleteVehicle _x;
    } forEach intelGridTriggers;
} else {
    intelGridTriggers = [];
};
deleteMarkerLocal "missionAreaBorderMarker0";
deleteMarkerLocal "missionAreaBorderMarker1";
deleteMarkerLocal "missionAreaBorderMarker2";


for "_i" from 0 to 2 do {
    private _missionAreaBorderMarker = createMarkerLocal [("missionAreaBorderMarker" + str _i), getPos patrolCenter];
    private _patrolRadius = (patrolCenter getVariable "patrolRadius") + _i;
    _missionAreaBorderMarker setMarkerSizeLocal [_patrolRadius, _patrolRadius];
    _missionAreaBorderMarker setMarkerDirLocal (patrolCenter getVariable ["rotation", 0]);
    _missionAreaBorderMarker setMarkerShapeLocal "RECTANGLE";
    _missionAreaBorderMarker setMarkerBrushLocal "Border";
};



if (_gridSize == 0) exitWith {};


private _rotateRelativePosition = {
    params ["_rotation", "_relPos"];

    private _rotMatrix =
    [
        [cos _rotation, sin _rotation],
        [-(sin _rotation), cos _rotation]
    ];

    private _result = [
        (((_rotMatrix select 0) select 0) * (_relPos select 0)) + (((_rotMatrix select 0) select 1) * (_relPos select 1)),
        (((_rotMatrix select 1) select 0) * (_relPos select 0)) + (((_rotMatrix select 1) select 1) * (_relPos select 1))
    ];

    _result;
};



private _middlePos = getPos patrolCenter;
private _patrolRadius = (patrolCenter getVariable "patrolRadius");
private _leftmostGrid = (_middlePos select 0) - _patrolRadius + (_gridSize / 2);
private _rightmostGrid = (_middlePos select 0) + _patrolRadius;
private _topGrid = (_middlePos select 1) - _patrolRadius + (_gridSize / 2);
private _bottomGrid = (_middlePos select 1) + _patrolRadius - (_gridSize / 2);
private _positions = [];

for "_i" from _leftmostGrid to _rightmostGrid step _gridSize do {
    for "_j" from _topGrid to _bottomGrid step _gridSize do {
        private _position = [_i, _j];
        private _rotation = patrolCenter getVariable ["rotation", 0];

        if (_rotation != 0) then {
            private _relPos = [_i - (_middlePos select 0), _j - (_middlePos select 1)];
            private _rotatedRelPos = [_rotation, _relPos] call _rotateRelativePosition;

            _position = [(_middlePos select 0) + (_rotatedRelPos select 0), (_middlePos select 1) + (_rotatedRelPos select 1)];
        };

        _positions append [_position];
    }
};

{
    private _xPos = _x select 0;
    private _yPos = _x select 1;
    private _rotation = patrolCenter getVariable ["rotation", 0];

    private _markerName = "MarkerX" + str _xPos + "Y" + str _yPos + str player;
    _marker = createMarkerLocal [_markerName, [_xPos, _yPos]];
    _marker setMarkerAlphaLocal 0;

    _trg = createTrigger ["EmptyDetector", [_xPos, _yPos], false];
    _trg setVariable ["attachedMarker", _marker];
    _trg setTriggerArea [(_gridSize / 2), (_gridSize / 2), _rotation, true];
    _trg setTriggerActivation ["ANY", "PRESENT", true];
    [_markerName, _trg, true] call BIS_fnc_markerToTrigger;

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
            (thisTrigger getVariable ""attachedMarker"") setMarkerAlphaLocal 0.5;
        };
    } forEach thisList;";
    _trg setTriggerStatements [_triggerCondition, _triggerActivation, "(thisTrigger getVariable ""attachedMarker"") setMarkerAlphaLocal 0"];

    intelGridTriggers append [_trg];
} forEach _positions;

