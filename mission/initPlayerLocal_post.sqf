"supplies_marker_1" setMarkerPos (getPos supplies_1);
"supplies_marker_2" setMarkerPos (getPos supplies_2);
"supplies_marker_1" setMarkerAlpha 1;
"supplies_marker_2" setMarkerAlpha 1;
["team2_start_marker", win_trigger] call BIS_fnc_markerToTrigger; 
["team1_start_marker", lose_trigger] call BIS_fnc_markerToTrigger;
"team2_start_marker" setMarkerAlpha 1;
"team1_start_marker" setMarkerAlpha 1;

if (!isMultiplayer) then {
    teamSwitch;
    setAccTime 1;

    hint "Use Team Switch (U button) to switch to any friendly unit.";
} else {
    private _factionConfig = (selectRandom [spawner_01_friendly, spawner_02_friendly]) call ForceThrough_fnc_getRandomSpawnerFactionConfig;

    if (_factionConfig != configNull) then {
        private _side = [getNumber (_factionConfig >> "side")] call BIS_fnc_sideType;

        [player] joinSilent (createGroup _side);
    };

    waitUntil {(!isNil "ForceThrough_respawnInventoriesAdded" && {ForceThrough_respawnInventoriesAdded == true})};

    forceRespawn player;
};

terminate ForceThrough_ReversePresetGenerationProcess; // In case the faction config was never opened and the process is still waiting