waitUntil {!isNil "Rimsiakas_initialFactionsData"};

sleep 0.5; // Let the old default get updated, if there were changes.

private _presets = missionProfileNamespace getVariable ["Rimsiakas_configurationPresets", createHashMap];

while {isNil {_presets get "Default"}} do {
    sleep 0.5;
};

private _defaultPreset = _presets get "Default";
private _defaultSpawners = (_defaultPreset get "factionsData") get "spawners";
private _factionsData = +(_defaultPreset get "factionsData");
private _spawners = _factionsData get "spawners";

_spawners set ["spawner_01_friendly", (_defaultSpawners get "spawner_03_enemy")];
_spawners set ["spawner_02_friendly", (_defaultSpawners get "spawner_04_enemy")];
_spawners set ["spawner_03_enemy", (_defaultSpawners get "spawner_01_friendly")];
_spawners set ["spawner_04_enemy", (_defaultSpawners get "spawner_02_friendly")];

_reversedPreset = +_defaultPreset;
_reversedPreset set ["order", 1];
_reversedPreset set ["factionsData", _factionsData];

_presets set ["Default (Reversed factions)", _reversedPreset];

missionProfileNamespace setVariable ["Rimsiakas_configurationPresets", _presets];
saveMissionProfileNamespace;