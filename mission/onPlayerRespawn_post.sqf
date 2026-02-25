params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];


waitUntil {count (spawner_friendly_1 getVariable "spawnedunits") > 0 || {count (spawner_friendly_2 getVariable "spawnedunits")}};
private _unit = selectRandom ((spawner_friendly_1 getVariable "spawnedUnits") + (spawner_friendly_2 getVariable "spawnedUnits"));
player setSpeaker (speaker _unit);