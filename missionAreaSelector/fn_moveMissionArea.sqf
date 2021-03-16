params [["_newMissionPos", nil], ["_rotation", 0]];

if (isNil "_newMissionPos") then {
    _newMissionPos = getPos patrolCenter; // For example, when you only want to rotate.
};


private ["_oldMissionPos", "_synchronizedMoveableObjects", "_synchronizedMoveableObjects"];
_oldMissionPos = getPos patrolCenter;
_synchronizedMoveableObjects = (synchronizedObjects patrolCenter) select {typeOf _x == "LOGIC" && {_x getVariable "logicType" == "placer" && {(_x getVariable ["dynamic", true])}}};
_synchronizedMoveableObjects append ((synchronizedObjects patrolCenter) select {(typeOf _x) find "EmptyDetector" == 0}); // Triggers



private _rotateRelativePosition = {
    params ["_rotation", "_relPos", "_result"];

    private _rotMatrix =
    [
        [cos _rotation, sin _rotation],
        [-(sin _rotation), cos _rotation]
    ];

    _result = [
        (((_rotMatrix select 0) select 0) * (_relPos select 0)) + (((_rotMatrix select 0) select 1) * (_relPos select 1)),
        (((_rotMatrix select 1) select 0) * (_relPos select 0)) + (((_rotMatrix select 1) select 1) * (_relPos select 1))
    ];

    _result;
};



private _moveObjectFunc = {
    params ["_object", "_oldMissionPos", "_newMissionPos", "_rotation"];

    private _objectPos = getPos _object;
    private _relPos = [(_objectPos select 0) - (_oldMissionPos select 0), (_objectPos select 1) - (_oldMissionPos select 1)];

    if (isNil {_object getVariable ["originalAzimuthFromCenter", nil]}) then {
        _object setVariable ["originalAzimuthFromCenter", patrolCenter getDir _object]; // This is used to ensure scaling reversability
    };

    if (_rotation != 0) then {
        _relPos = [_rotation, _relPos] call _rotateRelativePosition;
    };

    private _newObjectPos = [(_newMissionPos select 0) + (_relPos select 0), (_newMissionPos select 1) + (_relPos select 1)];

    _object setPos _newObjectPos;

    if ((typeOf _object) find "EmptyDetector" == 0) then {
        private _triggerArea = triggerArea _object;
        _triggerArea set [2, (_triggerArea select 2) + _rotation];
        _object setTriggerArea _triggerArea;
    } else {
        _object setDir ((getDir _object) + _rotation);

        if (typeOf _object == "LOGIC" && {_object getVariable "logicType" == "placer"}) then {
            {
                [_x, _oldMissionPos, _newMissionPos, _rotation] call _moveObjectFunc;
            } forEach (_object getVariable ["childPlacers", []]);
        };
    };
};



{
    [_x, _oldMissionPos, _newMissionPos, _rotation] call _moveObjectFunc;
} forEach _synchronizedMoveableObjects;




patrolCenter setPos _newMissionPos;
private _oldRotation = patrolCenter getVariable ["rotation", 0];
patrolCenter setVariable ["rotation", _oldRotation + _rotation, true];

if ("missionAreaMarker" in allMapMarkers) then {
    "missionAreaMarker" setMarkerDirLocal (_oldRotation + _rotation);
};