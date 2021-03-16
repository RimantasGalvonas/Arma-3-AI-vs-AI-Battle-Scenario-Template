if (isNil "Rimsiakas_markersForSyncedObjectsDebugging") then {
    Rimsiakas_markersForSyncedObjectsDebugging = [];
};

private _colorNames = [];

{
    _colorNames append [configName _x];
} forEach configProperties [configFile >> "CfgMarkerColors"];


_allMarkers = allMapMarkers;


private _drawPlacerDebugMarkers = {
    params ["_placer"];

    private _placerPos = getPos _placer;
    private _color = selectRandom _colorNames;
    private _maxSpawnMarkerName = "placerDebug" + str _placer + "maxSpawnRadius";
    private _minSpawnMarkerName = "placerDebug" + str _placer + "minSpawnRadius";
    private _dotMarkerName = "placerDebug" + str _placer + "dotMarker";

    if (!(_maxSpawnMarkerName in _allMarkers)) then {
        createMarkerLocal [_maxSpawnMarkerName, _placerPos];
        _maxSpawnMarkerName setMarkerShapeLocal "ELLIPSE";
        _maxSpawnMarkerName setMarkerColorLocal _color;
        _maxSpawnMarkerName setMarkerBrushLocal "Border";
        _maxSpawnMarkerName setMarkerSizeLocal [_placer getVariable "maxSpawnRadius", _placer getVariable "maxSpawnRadius"];
        _maxSpawnMarkerName setMarkerTextLocal (str _placer);
        Rimsiakas_markersForSyncedObjectsDebugging append [_maxSpawnMarkerName];

        if ((_placer getVariable "minSpawnRadius") > 0) then {
            createMarkerLocal [_minSpawnMarkerName, _placerPos];
            _minSpawnMarkerName setMarkerShapeLocal "ELLIPSE";
            _minSpawnMarkerName setMarkerColorLocal _color;
            _minSpawnMarkerName setMarkerBrushLocal "Border";
            _minSpawnMarkerName setMarkerSizeLocal [_placer getVariable "minSpawnRadius", _placer getVariable "minSpawnRadius"];
            Rimsiakas_markersForSyncedObjectsDebugging append [_minSpawnMarkerName];
        };

        createMarkerLocal [_dotMarkerName, getPos _placer];
        _dotMarkerName setMarkerColorLocal _color;
        _dotMarkerName setMarkerTypeLocal "mil_dot";
        _dotMarkerName setMarkerTextLocal (str _placer);
        Rimsiakas_markersForSyncedObjectsDebugging append [_dotMarkerName];
    } else {
        _maxSpawnMarkerName setMarkerPosLocal _placerPos;
        _maxSpawnMarkerName setMarkerSizeLocal [_placer getVariable "maxSpawnRadius", _placer getVariable "maxSpawnRadius"];
        if ((_placer getVariable "minSpawnRadius") > 0) then {
            _minSpawnMarkerName setMarkerPosLocal _placerPos;
            _minSpawnMarkerName setMarkerSizeLocal [_placer getVariable "minSpawnRadius", _placer getVariable "minSpawnRadius"];
        };
        _dotMarkerName setMarkerPosLocal _placerPos;
    };

    {
        private _connectionMarkerName = "placerDebug" + str _placer + "-" + str _x + "connection";
        if (!(_connectionMarkerName in _allMarkers)) then {
            createMarkerLocal [_connectionMarkerName, _placerPos];
            _connectionMarkerName setMarkerColorLocal _color;
            _connectionMarkerName setMarkerShapeLocal "POLYLINE";
            _connectionMarkerName setMarkerPolylineLocal [_placerPos select 0, _placerPos select 1, (getPos _x) select 0, (getPos _x) select 1];
            Rimsiakas_markersForSyncedObjectsDebugging append [_connectionMarkerName];
        } else {
            _connectionMarkerName setMarkerPosLocal _placerPos;
            _connectionMarkerName setMarkerPolylineLocal [_placerPos select 0, _placerPos select 1, (getPos _x) select 0, (getPos _x) select 1];
        };

        [_x] call _drawPlacerDebugMarkers;
    } forEach (_placer getVariable ["childPlacers", []]);
};




_synchronizedTriggers = (synchronizedObjects patrolCenter) select {(typeOf _x) find "EmptyDetector" == 0};

{
    private _color = selectRandom _colorNames;

    private _areaMarkerName = "triggerDebug" + str _x;
    private _dotMarkerName = "triggerDebug" + str _x + "dotMarker";

    if (!(_areaMarkerName in _allMarkers)) then {
        createMarkerLocal [_areaMarkerName, getPos _x];
        _areaMarkerName setMarkerColorLocal _color;
        _areaMarkerName setMarkerAlphaLocal 0.6;
        Rimsiakas_markersForSyncedObjectsDebugging append [_areaMarkerName];

        createMarkerLocal [_dotMarkerName, getPos _x];
        _dotMarkerName setMarkerColorLocal _color;
        _dotMarkerName setMarkerTypeLocal "mil_dot";
        _dotMarkerName setMarkerTextLocal (str _x);
        Rimsiakas_markersForSyncedObjectsDebugging append [_dotMarkerName];
    };

    [_areaMarkerName, _x, true] call BIS_fnc_markerToTrigger;
    _dotMarkerName setMarkerPosLocal (getPos _x);
} forEach _synchronizedTriggers;




_synchronizedSpawners = (synchronizedObjects patrolCenter) select {typeOf _x == "LOGIC" && {_x getVariable "logicType" == "placer" && {(_x getVariable ["dynamic", true])}}};

{
    [_x] call _drawPlacerDebugMarkers;
} forEach _synchronizedSpawners;