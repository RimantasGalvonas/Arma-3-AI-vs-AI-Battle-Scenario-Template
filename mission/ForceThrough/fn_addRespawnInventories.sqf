private _friendlyUnitTypes = [spawner_friendly_1] call ForceThrough_fnc_getSpawnerUnitTypes;
_friendlyUnitTypes append ([spawner_friendly_2] call ForceThrough_fnc_getSpawnerUnitTypes);
_friendlyUnitTypes = _friendlyUnitTypes arrayIntersect _friendlyUnitTypes; // filter out duplicates

{
    [missionNamespace, _x] call BIS_fnc_addRespawnInventory
} foreach _friendlyUnitTypes;