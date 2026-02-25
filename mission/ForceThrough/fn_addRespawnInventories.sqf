private _friendlyUnitTypes = [spawner_01_friendly] call ForceThrough_fnc_getSpawnerUnitTypes;
_friendlyUnitTypes append ([spawner_02_friendly] call ForceThrough_fnc_getSpawnerUnitTypes);
_friendlyUnitTypes = _friendlyUnitTypes arrayIntersect _friendlyUnitTypes; // filter out duplicates

{
    [missionNamespace, _x] call BIS_fnc_addRespawnInventory
} foreach (_friendlyUnitTypes select {_x isKindOf "man"});