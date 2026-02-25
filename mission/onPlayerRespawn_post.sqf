params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];


waitUntil {count (spawner_01_friendly getVariable "spawnedunits") > 0 || {count (spawner_02_friendly getVariable "spawnedunits")}};
private _unit = selectRandom ((spawner_01_friendly getVariable "spawnedUnits") + (spawner_02_friendly getVariable "spawnedUnits"));
player setSpeaker (speaker _unit);