Rimsiakas_missionAreaPreviewProcessId = [] spawn {
    if (!createDialog "Rimsiakas_MissionAreaPreviewDialog") exitWith {
        hint "Couldn't open the mission area preview";
    };



    // Border dots
    private _middlePos = getPos patrolCenter;
    private _radius = patrolCenter getVariable "patrolRadius";
    private _rotation = patrolCenter getVariable ["rotation", 0];
    private _hypotenuse = sqrt (2 * _radius * _radius);
    private _corners = [
        _middlePos getPos [_hypotenuse, _rotation + 45],
        _middlePos getPos [_hypotenuse, _rotation + 135],
        _middlePos getPos [_hypotenuse, _rotation + 225],
        _middlePos getPos [_hypotenuse, _rotation + 315]
    ];
    private _dotPositions = [];
    {
        private _currentPos = _x;
        private _endPos = [];

        if (_forEachIndex == 3) then {
            _endPos = _corners select 0;
        } else {
            _endPos = _corners select (_forEachIndex + 1);
        };

        while {(_currentPos distance2D _endPos > 25)} do {
            _nextPos = _currentPos getPos [25, _currentPos getDir _endPos];
            _dotPositions append [_nextPos];
            _currentPos = _nextPos;
        };
        _dotPositions append [_endPos];
    } forEach _corners;

    Rimsiakas_MissionAreaPreviewHandlerId = addMissionEventHandler [
        "Draw3D",
        {
            private _dotPositions = _thisArgs select 0;
            {
                private _dotPosAboveGround = +_x; // The plus sign copies the array instead of referencing. This is so the next line doesn't change the coordinate of the actual position.
                _dotPosAboveGround set [2, (_x select 2) + 1];

                private _color = [1, 0, 0, 0.35];
                if (isNil "Rimsiakas_missionAreaPreviewCamera" || {terrainIntersect [getPos Rimsiakas_missionAreaPreviewCamera, _dotPosAboveGround]}) then {
                    _color = [1, 0, 0, 0.15];
                };

                drawIcon3D ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _color, _x, 1, 1, 0];
            } forEach _dotPositions;
        },
        [_dotPositions]
    ];



    // Camera movement
    private _pos = getMarkerPos "missionAreaMarker";
    private _posX = _pos select 0;
    private _posY = _pos select 1;
    private _radius = ((getMarkerSize "missionAreaMarker") select 0) * 1.5;
    private _altitude = 300;

    private _coords = [_pos, _radius, 0] call BIS_fnc_relPos;
    _coords set [2, _altitude];

    Rimsiakas_missionAreaPreviewCamera = "camera" camCreate _coords;
    Rimsiakas_missionAreaPreviewCamera camPrepareTarget _pos;
    Rimsiakas_missionAreaPreviewCamera cameraEffect ["internal", "back"];

    for "_angle" from 0 to 360 do {
        _coords = [_pos, _radius, _angle] call BIS_fnc_relPos;
        _coords set [2, _altitude];

        Rimsiakas_missionAreaPreviewCamera camPreparePos _coords;
        Rimsiakas_missionAreaPreviewCamera camCommitPrepared (15/360); // 15 seconds for full rotation
        cameraEffectEnableHUD true;

        waitUntil {camCommitted Rimsiakas_missionAreaPreviewCamera};
    };


    sleep 3;

    call Rimsiakas_fnc_terminateMissionAreaPreview;
};