params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];


waitUntil {count (spawner_01_friendly getVariable "spawnedUnitsAndCrewArrays") > 0 || {count (spawner_02_friendly getVariable "spawnedUnitsAndCrewArrays") > 0}};
private _unit = selectRandom ((spawner_01_friendly getVariable "spawnedUnitsAndCrewArrays") + (spawner_02_friendly getVariable "spawnedUnitsAndCrewArrays"));
player setSpeaker (speaker _unit);