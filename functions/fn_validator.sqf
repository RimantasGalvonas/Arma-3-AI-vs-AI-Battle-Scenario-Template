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



_spawnerInitInstructions = [
    parseText "In its init box you should put a variable with an array of group config paths for friendly groups to be spawned. For example:<br/><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(<t color=""#6666ff"">GROUP_CONFIG_PATH</t>)<br/>]];</t>",

    parseText "Replace <t color=""#ff0000""></t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000""></t> with a group config path which can be found in the Eden editor <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t>. Find <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t> on the left. Select the one you want and copy it from <t font=""PuristaBold"" color=""#ff0000"">Config Path</t> in the bottom of the screen. It should look something like this:<br/><t color=""#6666ff"">configFile >>""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""</t><br/>You may add as many as you want. Add duplicates if you want more of the same group.",

    parseText "You may also create custom groups out of individual units by replacing <t color=""#ff0000"">(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">)</t> with for example:<br/><t color=""#ff0000"">[""</t><t color=""#6666ff"">B_Truck_01_ammo_F</t><t color=""#ff0000"">"", ""</t><t color=""#6666ff"">B_Truck_01_Repair_F</t><t color=""#ff0000"">""]</t><br/>These <t color=""#6666ff"">names in blue</t> can be found by hovering over a unit placed in the Eden editor or in <t font=""PuristaBold"" color=""#ff0000"">configFile >> ""CfgVehicles""</t>"
];


_friendlySpawnerHints = [];
if (isNil "friendlySpawner" || {isNil {friendlySpawner getVariable "groups"} || {count(friendlySpawner getVariable "groups") == 0}}) then {
    _friendlySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">friendlySpawner</t>."];

    _friendlySpawnerHints = _friendlySpawnerHints + _spawnerInitInstructions;
};


_enemySpawnerHints = [];
if (isNil "enemySpawner" || {isNil {enemySpawner getVariable "groups"} || {count(enemySpawner getVariable "groups") == 0}}) then {
    _enemySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">enemySpawner</t>."];

    _enemySpawnerHints = _enemySpawnerHints + _spawnerInitInstructions;
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