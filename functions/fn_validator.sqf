_patrolCenterHints = [];
if (isNil "patrolCenter") then {
    _patrolCenterHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> (Found in Systems > Logic Entities) entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">patrolCenter</t> where you want the mission to take place"];
} else {
    _patrolCenterMissingVariables = [];
    if (isNil { patrolCenter getVariable "patrolRadius" }) then {
        _patrolCenterMissingVariables append [parseText "<t align=""left"" color=""#ff0000"">this setVariable [""patrolRadius"", 150];</t><br/>where 150 would be the desired AO radius in meters"];
    };

    if (isNil { patrolCenter getVariable "friendlySpawnMinRadius" }) then {
        _patrolCenterMissingVariables append [parseText "<t align=""left"" color=""#ff0000"">this setVariable [""friendlySpawnMinRadius"", 800];</t><br/>where 800 would be the minimum distance from the center of the AO where friendly units should be spawned"];
    };

    if (isNil { patrolCenter getVariable "friendlySpawnMaxRadius" }) then {
        _patrolCenterMissingVariables append [parseText "<t align=""left"" color=""#ff0000"">this setVariable [""friendlySpawnMaxRadius"", 1000];</t><br/>where 1000 would be the maximum distance from the center of the AO where friendly units should be spawned"];
    };

    if (isNil { patrolCenter getVariable "enemySpawnMinRadius" }) then {
        _patrolCenterMissingVariables append [parseText "<t align=""left"" color=""#ff0000"">this setVariable [""enemySpawnMinRadius"", 0];</t><br/>where 0 would be the minimum distance from the center of the AO where enemy units should be spawned"];
    };

    if (isNil { patrolCenter getVariable "enemySpawnMaxRadius" }) then {
        _patrolCenterMissingVariables append [parseText "<t align=""left"" color=""#ff0000"">this setVariable [""enemySpawnMaxRadius"", 400];</t><br/>where 400 would be the maximum distance from the center of the AO where enemy units should be spawned"];
    };

    if ((count _patrolCenterMissingVariables) > 0) then {
        _commonPatrolCenterInstruction = [parseText "Find the <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">patrolCenter</t>. Enter these into said entity's init box:"];
        _patrolCenterHints = _commonPatrolCenterInstruction + _patrolCenterMissingVariables;
    };
};

_friendlySpawnerHints = [];
if (isNil "friendlySpawner") then {
    _friendlySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">friendlySpawner</t>."];

    _friendlySpawnerHints append [parseText "In its init box you should put a variable with an array of group config paths for friendly groups to be spawned. For example:<br/><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>(configfile >> ""CfgGroups"" >> ""West"" >> ""BLU_W_F"" >> ""Infantry"" >> ""B_W_InfSquad""),<br/>(configfile >> ""CfgGroups"" >> ""West"" >> ""BLU_W_F"" >> ""Infantry"" >> ""B_W_InfSquad""),<br/>(configfile >> ""CfgGroups"" >> ""West"" >> ""BLU_T_F"" >> ""Armored"" >> ""B_T_TankPlatoon"")<br/>]];</t>"];

    _friendlySpawnerHints append [parseText "You can find these config paths in <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t> in <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t>. Select the one you want and copy it from Config Path in the bottom of the screen"];
};

_enemySpawnerHints = [];
if (isNil "enemySpawner") then {
    _enemySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">enemySpawner</t>."];

    _enemySpawnerHints append [parseText "In its init box you should put a variable with an array of group config paths for friendly groups to be spawned. For example:<br/><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>(configfile >> ""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Mechanized"" >> ""I_E_MechInfSquad""),<br/>(configfile >> ""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Mechanized"" >> ""I_E_MechInfSquad""),<br/>(configfile >> ""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""),<br/>(configfile >> ""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""),<br/>(configfile >> ""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam"")<br/>]];</t>"];

    _enemySpawnerHints append [parseText "You can find these config paths in <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t> in <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t>. Select the one you want and copy it from Config Path in the bottom of the screen"];
};

_allHints = [];

if ((count _patrolCenterHints) > 0) then {
    _allHints append [["Mission Area Setup", _patrolCenterHints]];
};

if ((count _friendlySpawnerHints) > 0) then {
    _allHints append [["Friendly Groups Spawner Setup", _friendlySpawnerHints]];
};

if ((count _enemySpawnerHints) > 0) then {
    _allHints append [["Enemy Groups Spawner Setup", _enemySpawnerHints]];
};

_allHints;