waitUntil {!isNil "Rimsiakas_initialSpawnersData"};

sleep 0.5; // Let the old default get updated, if there were changes.

private _presets = missionProfileNamespace getVariable ["Rimsiakas_factionPresets", createHashMap];

while {isNil {_presets get "Default"}} do {
    sleep 0.5;
};

private _defaultPreset = (_presets get "Default") get "preset";
private _defaultSpawners = _defaultPreset get "spawners";


private _reversedPreset = createHashMapFromArray [
    ["order", 1],
    ["readonly", true],
    [
        "preset",
        createHashMapFromArray
        [
            ["independentRelation", _defaultPreset get "independentRelation"],
            [
                "spawners",
                createHashMapFromArray
                [
                    ["spawner_friendly_1", (_defaultSpawners get "spawner_enemy_1")],
                    ["spawner_friendly_2", (_defaultSpawners get "spawner_enemy_2")],
                    ["spawner_enemy_1", (_defaultSpawners get "spawner_friendly_1")],
                    ["spawner_enemy_2", (_defaultSpawners get "spawner_friendly_2")]
                ]
            ]
        ]
    ]
];


_presets set ["Default (Reversed)", _reversedPreset];

missionProfileNamespace setVariable ["Rimsiakas_factionPresets", _presets];
saveMissionProfileNamespace;