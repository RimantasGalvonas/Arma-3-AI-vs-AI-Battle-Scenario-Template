_patrolCenterHints = [];
if (isNil "patrolCenter" ||
    {
        isNil { patrolCenter getVariable "patrolRadius" }
    }
) then {
    _patrolCenterHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity (Found in Systems > Logic Entities) where you want the mission to take place. You must name that entity <t font=""PuristaBold"" color=""#ff0000"">patrolCenter</t>."];
    _patrolCenterHints append [parseText "Enter these into said entity's init box:<br/><t align=""left"" color=""#ff0000"">this setVariable [""patrolRadius"", </t><t color=""#6666ff"">150</t><t color=""#ff0000"">];</t>"];
    _patrolCenterHints append [parseText "<t color=""#6666ff"">150</t> is radius of the mission area. You may adjust it."];
};

_spawnerInitInstructions = [
    parseText "In its init box enter this:<br/><t align=""left"" color=""#ff0000"">this setVariable [""minSpawnRadius"", </t><t color=""#6666ff"">0</t><t align=""left"" color=""#ff0000"">];<br/>this setVariable [""maxSpawnRadius"", </t><t color=""#6666ff"">600</t><t color=""#ff0000"">];</t><br/><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(<t color=""#6666ff"">GROUP_CONFIG_PATH</t>)<br/>]];</t>",

    parseText "You may adjust the <t color=""#6666ff"">numbers</t> for <t color=""#ff0000"">minSpawnRadius</t> and <t color=""#ff0000"">maxSpawnRadius</t>",

    parseText "Replace <t color=""#ff0000""></t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000""></t> with a group config path which can be found in the Eden editor <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t>. Find <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t> on the left. Select the one you want and copy it from <t font=""PuristaBold"" color=""#ff0000"">Config Path</t> in the bottom of the screen. It should look something like this:<br/><t color=""#6666ff"">configFile >>""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""</t><br/>You may add as many as you want. Add duplicates if you want more of the same group.",

    parseText "You may also create custom groups out of individual units by replacing <t color=""#ff0000"">(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">)</t> with for example:<br/><t color=""#ff0000"">[""</t><t color=""#6666ff"">B_Truck_01_ammo_F</t><t color=""#ff0000"">"", ""</t><t color=""#6666ff"">B_Truck_01_Repair_F</t><t color=""#ff0000"">""]</t><br/>These <t color=""#6666ff"">names in blue</t> can be found by hovering over a unit placed in the Eden editor or in <t font=""PuristaBold"" color=""#ff0000"">configFile >> ""CfgVehicles""</t>"
];

_enemySpawnerHints = [];
if (
    isNil "enemySpawner" ||
    {
        isNil {enemySpawner getVariable "minSpawnRadius"} ||
        {
            isNil {enemySpawner getVariable "maxSpawnRadius"} ||
            {
                isNil {enemySpawner getVariable "groups"} ||
                {
                    count(enemySpawner getVariable "groups") == 0
                }
            }
        }
    }
) then {
    _enemySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">enemySpawner</t>. Enemy groups will be spawned around it."];

    _enemySpawnerHints = _enemySpawnerHints + _spawnerInitInstructions;
};


_friendlySpawnerHints = [];
if (
    isNil "friendlySpawner" ||
    {
        isNil {friendlySpawner getVariable "minSpawnRadius"} ||
        {
            isNil {friendlySpawner getVariable "maxSpawnRadius"} ||
            {
                isNil {friendlySpawner getVariable "groups"} ||
                {
                    count(friendlySpawner getVariable "groups") == 0
                }
            }
        }
    }
) then {
    _friendlySpawnerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">friendlySpawner</t>. friendly groups will be spawned around it."];

    _friendlySpawnerHints = _friendlySpawnerHints + _spawnerInitInstructions;
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