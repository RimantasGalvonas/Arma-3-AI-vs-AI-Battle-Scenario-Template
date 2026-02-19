params ["_group", "_spawner", "_placer"];

if (isNil "Rimsiakas_enemySpawnCount") then {
    Rimsiakas_enemySpawnCount = 0;
};

scopeName "mainCallbackScope";

if (Rimsiakas_enemySpawnCount < 4) then {
    Rimsiakas_enemySpawnCount = Rimsiakas_enemySpawnCount + 1;

    {
        if ((vehicle _x) != _x) then {
            breakTo "mainCallbackScope"; // Don't move the group if it's mounted
        };
    } forEach units _group;

    [_group, Placer_team2_start] call Rimsiakas_fnc_teleportSquadToRandomPosition;
    [_group] call Rimsiakas_fnc_searchForEnemies;
};

[_placer] call Rimsiakas_fnc_placer;