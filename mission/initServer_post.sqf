if (isMultiplayer) then {
    [] call ForceThrough_fnc_addRespawnInventories;
};

ForceThrough_respawnInventoriesAdded = true;
publicVariable "ForceThrough_respawnInventoriesAdded";

[] call ForceThrough_fnc_missionLocationChanger;
[] call ForceThrough_fnc_customAISpawnerModuleControl;
[] call ForceThrough_fnc_setFactionCosmetics;