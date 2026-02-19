params ["_spawner"];

private _randomUnit = selectRandom (_spawner call ForceThrough_fnc_getSpawnerUnitTypes);

getText (configFile >> "cfgVehicles" >> _randomUnit >> "faction");

private _faction = getText (configFile >> "cfgVehicles" >> _randomUnit >> "faction");

configFile >> "CfgFactionClasses" >> _faction;
