params ["_group", "_spawner", "_placer"];

{
    addSwitchableUnit _x;

    if (!isMultiplayer) then {
        [_x] call ForceThrough_fnc_addDiaryEntries;
    };
} forEach units _group;

[_placer] call Rimsiakas_fnc_placer;
{[_x] remoteExec ["Rimsiakas_fnc_revealFriendlyGroupsOnMap", _x]} foreach allPLayers;