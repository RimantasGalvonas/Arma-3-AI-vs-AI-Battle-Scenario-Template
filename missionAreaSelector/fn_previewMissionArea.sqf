Rimsiakas_missionAreaPreviewProcessId = [] spawn {
    if (!createDialog "Rimsiakas_MissionAreaPreviewDialog") exitWith {
        hint "Couldn't open the mission area preview";
    };

    _pos = getMarkerPos "missionAreaMarker";
    _posX = _pos select 0;
    _posY = _pos select 1;
    _radius = ((getMarkerSize "missionAreaMarker") select 0) * 1.5;
    _altitude = 300;

    _coords = [_pos, _radius, 0] call BIS_fnc_relPos;
    _coords set [2, _altitude];

    Rimsiakas_missionAreaPreviewCamera = "camera" camCreate _coords;
    Rimsiakas_missionAreaPreviewCamera camPrepareTarget _pos;
    Rimsiakas_missionAreaPreviewCamera cameraEffect ["internal", "back"];

    for "_angle" from 0 to 360 do {
        _coords = [_pos, _radius, _angle] call BIS_fnc_relPos;
        _coords set [2, _altitude];

        Rimsiakas_missionAreaPreviewCamera camPreparePos _coords;
        Rimsiakas_missionAreaPreviewCamera camCommitPrepared (15/360); // 15 seconds for full rotation

        waitUntil {camCommitted Rimsiakas_missionAreaPreviewCamera};
    };


    sleep 3;

    call Rimsiakas_fnc_terminateMissionAreaPreview;
};