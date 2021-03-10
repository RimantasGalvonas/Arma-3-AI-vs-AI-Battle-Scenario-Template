params ["_newMissionPos", ["_rotation", 0]];



// Function to multiply a [2, 2] matrix by a [2, 1] matrix
_multiplyMatrixFunc =
{
    private ["_array1", "_array2", "_result"];
    _array1 = _this select 0;
    _array2 = _this select 1;

    _result =
    [
        (((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),
        (((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))
    ];

    _result
};



_oldMissionPos = getPos patrolCenter;



_synchronizedMoveableObjects = (synchronizedObjects patrolCenter) select {typeOf _x == "LOGIC" && {_x getVariable "logicType" == "placer" && {(_x getVariable ["dynamic", true])}}};
_synchronizedMoveableObjects append ((synchronizedObjects patrolCenter) select {(typeOf _x) find "EmptyDetector" == 0}); // Triggers




{
    _objectPos = getPos _x;
    _relPos = [(_objectPos select 0) - (_oldMissionPos select 0), (_objectPos select 1) - (_oldMissionPos select 1)];

    if (_rotation != 0) then {
        _rotMatrix =
        [
            [cos _rotation, sin _rotation],
            [-(sin _rotation), cos _rotation]
        ];
        _relPos = [_rotMatrix, _relPos] call _multiplyMatrixFunc;
    };

    _newObjectPos = [(_newMissionPos select 0) + (_relPos select 0), (_newMissionPos select 1) + (_relPos select 1)];

    _x setPos _newObjectPos;

    if ((typeOf _x) find "EmptyDetector" == 0) then {
        _triggerArea = triggerArea _x;
        _triggerArea set [2, (_triggerArea select 2) + _rotation];
        _x setTriggerArea _triggerArea;
    } else {
        _x setDir ((getDir _x) + _rotation);
    };
} forEach _synchronizedMoveableObjects;




patrolCenter setPos _newMissionPos;