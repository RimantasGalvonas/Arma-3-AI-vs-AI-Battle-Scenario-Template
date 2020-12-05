_patrolCenterHints = [];
_placerHints1 = [];
_placerHints2 = [];
_placerHints3 = [];
_highCommandHints = [];

_placers = [];
_hasProperlyConfiguredPlacers = false;
if (isNil "patrolCenter" || {isNil {patrolCenter getVariable "patrolRadius"} || isNil {patrolCenter getVariable "intelGridSize"}}) then {
    _patrolCenterHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity (Found in Systems > Logic Entities) where you want the mission to take place. You must name that entity <t font=""PuristaBold"" color=""#ff0000"">patrolCenter</t>."];
    _patrolCenterHints append [parseText "Enter these into said entity's init box:<br/><t align=""left"" color=""#ff0000"">this setVariable [""patrolRadius"", </t><t color=""#6666ff"">600</t><t align=""left"" color=""#ff0000"">];<br/>this setVariable [""intelGridSize"", </t><t color=""#6666ff"">100</t><t color=""#ff0000"">];</t>"];
    _patrolCenterHints append [parseText "<t color=""#6666ff"">600</t> is radius of the mission area. Units will roam around it looking for enemies. You may adjust the number."];
    _patrolCenterHints append [parseText "<t color=""#6666ff"">100</t> is the size of a colored square on the map showing you the approximate location of enemies in the mission area. You may adjust this number or set it to <t color=""#6666ff"">0</t> to disable it. Setting the value to something very low will give you very precise positions but may negatively impact performance."];
    _patrolCenterHints append [parseText "Once you've done that, start the mission again. If successful, you will be shown a different text here, explaining how to set up unit placers."];

} else {
    {
        if (
            (_x getVariable ["logicType", ""]) == "placer" && {!isNil {_x getVariable "minSpawnRadius"} &&{!isNil {_x getVariable "maxSpawnRadius"}}}
        ) then {
            _placers append [_x];
        };

    } forEach (synchronizedObjects patrolCenter);

    if ((count _placers) == 0) then {
        _placerHints1 append [parseText "You must create some <t font=""PuristaBold"" color=""#ff0000"">placers</t> and sync them to the <t font=""PuristaBold"" color=""#ff0000"">Patrol Center</t> entity. <t font=""PuristaBold"" color=""#ff0000"">Placers</t> are used to place AI units randomly within a certain area."];
        _placerHints1 append [parseText "To create a <t font=""PuristaBold"" color=""#ff0000"">placer</t>, place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity somewhere."];
        _placerHints1 append [parseText "In its init box enter this:<br/><t align=""left"" color=""#ff0000"">this setVariable [""logicType"", ""placer""];<br/>this setVariable [""minSpawnRadius"", </t><t color=""#6666ff"">0</t><t align=""left"" color=""#ff0000"">];<br/>this setVariable [""maxSpawnRadius"", </t><t color=""#6666ff"">600</t><t color=""#ff0000"">];</t>"];
        _placerHints1 append [parseText "You may adjust the <t color=""#6666ff"">numbers</t> for <t color=""#ff0000"">minSpawnRadius</t> and <t color=""#ff0000"">maxSpawnRadius</t>. These values determine the min/max distance from the placer where units can be spawned."];
        _placerHints1 append [parseText "Sync the <t font=""PuristaBold"" color=""#ff0000"">placer</t> to the <t font=""PuristaBold"" color=""#ff0000"">Patrol Center</t> entity."];
        _placerHints1 append [parseText "You may repeat these steps to make as many placers as you want. At least two are recommended - one for each side."];
        _placerHints1 append [parseText "You may also sync the player group with one of the placers to randomize the starting position."];
        _placerHints1 append [parseText "Once you've done that, start the mission again. If successful, you will be shown a different text here, explaining how to assign units to placers."];
    } else {
        {
            _placer = _x;

            if (!isNil {_placer getVariable "groups"} && {count(_placer getVariable "groups") > 0}) exitWith {
                _hasProperlyConfiguredPlacers = true;
            };

            {
                _syncedUnit = _x;
                _syncedGroup = nil;

                if (_syncedUnit isKindOf "landVehicle") then {
                    _syncedUnit = (crew _x) select 0;
                };
                if (_syncedUnit isKindOf "man") then {
                    _syncedGroup = group _syncedUnit;
                };

                if (!isNil {_syncedGroup}) exitWith {
                    _hasProperlyConfiguredPlacers = true;
                };
            } foreach synchronizedObjects _placer;
        } forEach _placers;

        if (_hasProperlyConfiguredPlacers == false) then {
            _placerHints2 append [parseText "The simplest way to make a placer spawn units is to place a unit or a group in the editor and sync it to the placer (sync only one unit from the group, not all of them). This will randomize that unit's position according to the placer and makes them roam the mission area."];
            _placerHints2 append [parseText "Another way to make it spawn units is to add this to the placer's init box:<br/><t align=""left"" color=""#ff0000""><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(<t color=""#6666ff"">GROUP_CONFIG_PATH</t>)<br/>]];</t>"];
            _placerHints2 append [parseText "Replace <t color=""#ff0000""></t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000""></t> with a group config path which can be found in the Eden editor <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t>. Find <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t> on the left. Select the one you want and copy it from <t font=""PuristaBold"" color=""#ff0000"">Config Path</t> in the bottom of the screen. It should look something like this:<br/><t color=""#6666ff"">configFile >>""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""</t><br/>You may add as many as you want. Add duplicates if you want more of the same group."];
            _placerHints2 append [parseText "You may also create custom groups out of individual units by replacing <t color=""#ff0000"">(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">)</t> with for example:<br/><t color=""#ff0000"">[""</t><t color=""#6666ff"">B_Truck_01_ammo_F</t><t color=""#ff0000"">"", ""</t><t color=""#6666ff"">B_Truck_01_Repair_F</t><t color=""#ff0000"">""]</t><br/>These <t color=""#6666ff"">names in blue</t> can be found by hovering over a unit placed in the Eden editor or in <t font=""PuristaBold"" color=""#ff0000"">configFile >> ""CfgVehicles""</t>"];
            _placerHints3 append [parseText "You can also make <t font=""PuristaBold"" color=""#ff0000"">placers</t> place other <t font=""PuristaBold"" color=""#ff0000"">placers</t>. Due to technical reasons it has to be done this way:"];
            _placerHints3 append [parseText "Create a <t font=""PuristaBold"" color=""#ff0000"">placer</t> as usual, sync it to the <t font=""PuristaBold"" color=""#ff0000"">patrolCenter</t>"];
            _placerHints3 append [parseText "Create another <t font=""PuristaBold"" color=""#ff0000"">placer</t> as usual but DON'T sync it to anything. You must give this <t font=""PuristaBold"" color=""#ff0000"">placer</t> a <t color=""#6666ff"">name</t>"];
            _placerHints3 append [parseText "Add this to the first <t font=""PuristaBold"" color=""#ff0000"">placer's</t> init box:<br/><t align=""left"" color=""#ff0000"">this setVariable [""childPlacers"", [<t color=""#6666ff"">that_name_from_before</t><t color=""#ff0000"">]];</t>"];
            _placerHints3 append [parseText "You can use more than one:<br/><t align=""left"" color=""#ff0000"">this setVariable [""childPlacers"", [<t color=""#6666ff"">unitPlacer1</t><t color=""#ff0000"">, </t><t color=""#6666ff"">unitPlacer2</t><t color=""#ff0000"">]];</t>"];
            _highCommandHints append [parseText "It is recommended to place a <t font=""PuristaBold"" color=""#ff0000"">Military Symbols</t> module in the editor (found in: <t font=""PuristaBold"" color=""#ff0000"">Systems > Modules > Other</t>). It allows you to see the position of friendly groups on the map"];
            _highCommandHints append [parseText "You may sync the player character with a <t font=""PuristaBold"" color=""#ff0000"">High Coommand - Commander</t> module (found in the same place as above). This will allow you to manually assign waypoints to AI groups instead of having them roam the mission area randomly."];
            _highCommandHints append [parseText "Add this to the init box of some <t font=""PuristaBold"" color=""#ff0000"">placers</t>. It will allow you to command the units from that placer:<br/><t align=""left"" color=""#ff0000"">this setVariable [""highCommandSubordinates"", true];</t>"];
            _highCommandHints append [parseText "To enter high command mode, press <t font=""PuristaBold"" color=""#ff0000"">Left Ctrl+Space</t>."];
        };
    };
};



_allHints = [];

if ((count _patrolCenterHints) > 0) then {
    _allHints append [["Mission Area Setup", _patrolCenterHints]];
};

if ((count _placerHints1) > 0) then {
    _allHints append [["Unit Placer Setup", _placerHints1]];
};

if ((count _placerHints2) > 0) then {
    _allHints append [["Configuring Placers To Place Units", _placerHints2]];
};

if ((count _placerHints3) > 0) then {
    _allHints append [["Configuring Placers To Place Other Placers", _placerHints3]];
};

if ((count _highCommandHints) > 0) then {
    _allHints append [["High Command", _highCommandHints]];
};

_allHints;
/*
_placerInitInstructions = [
    parseText "In its init box enter this:<br/><t align=""left"" color=""#ff0000"">this setVariable [""minSpawnRadius"", </t><t color=""#6666ff"">0</t><t align=""left"" color=""#ff0000"">];<br/>this setVariable [""maxSpawnRadius"", </t><t color=""#6666ff"">600</t><t color=""#ff0000"">];</t><br/><t align=""left"" color=""#ff0000"">this setVariable [""groups"", [<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">),<br/>&#160;&#160;&#160;&#160;(<t color=""#6666ff"">GROUP_CONFIG_PATH</t>)<br/>]];</t>",

    parseText "You may adjust the <t color=""#6666ff"">numbers</t> for <t color=""#ff0000"">minSpawnRadius</t> and <t color=""#ff0000"">maxSpawnRadius</t>",

    parseText "Replace <t color=""#ff0000""></t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000""></t> with a group config path which can be found in the Eden editor <t font=""PuristaBold"" color=""#ff0000"">Tools -> Config Viewer</t>. Find <t font=""PuristaBold"" color=""#ff0000"">cfgGroups</t> on the left. Select the one you want and copy it from <t font=""PuristaBold"" color=""#ff0000"">Config Path</t> in the bottom of the screen. It should look something like this:<br/><t color=""#6666ff"">configFile >>""CfgGroups"" >> ""Indep"" >> ""IND_E_F"" >> ""Infantry"" >> ""I_E_InfTeam""</t><br/>You may add as many as you want. Add duplicates if you want more of the same group.",

    parseText "You may also create custom groups out of individual units by replacing <t color=""#ff0000"">(</t><t color=""#6666ff"">GROUP_CONFIG_PATH</t><t color=""#ff0000"">)</t> with for example:<br/><t color=""#ff0000"">[""</t><t color=""#6666ff"">B_Truck_01_ammo_F</t><t color=""#ff0000"">"", ""</t><t color=""#6666ff"">B_Truck_01_Repair_F</t><t color=""#ff0000"">""]</t><br/>These <t color=""#6666ff"">names in blue</t> can be found by hovering over a unit placed in the Eden editor or in <t font=""PuristaBold"" color=""#ff0000"">configFile >> ""CfgVehicles""</t>"
];

_enemyplacerHints = [];
if (
    isNil "enemyplacer" ||
    {
        isNil {enemyplacer getVariable "minSpawnRadius"} ||
        {
            isNil {enemyplacer getVariable "maxSpawnRadius"} ||
            {
                isNil {enemyplacer getVariable "groups"} ||
                {
                    count(enemyplacer getVariable "groups") == 0
                }
            }
        }
    }
) then {
    _enemyplacerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">enemyplacer</t>. Enemy groups will be spawned around it."];

    _enemyplacerHints = _enemyplacerHints + _placerInitInstructions;
};


_friendlyplacerHints = [];
if (
    isNil "friendlyplacer" ||
    {
        isNil {friendlyplacer getVariable "minSpawnRadius"} ||
        {
            isNil {friendlyplacer getVariable "maxSpawnRadius"} ||
            {
                isNil {friendlyplacer getVariable "groups"} ||
                {
                    count(friendlyplacer getVariable "groups") == 0
                }
            }
        }
    }
) then {
    _friendlyplacerHints append [parseText "You must place a <t font=""PuristaBold"" color=""#ff0000"">Game Logic</t> entity with the variable name <t font=""PuristaBold"" color=""#ff0000"">friendlyplacer</t>. friendly groups will be spawned around it."];

    _friendlyplacerHints = _friendlyplacerHints + _placerInitInstructions;
};



_allHints = [];

if ((count _patrolCenterHints) > 0) then {
    _allHints append [["Mission Area Setup", _patrolCenterHints]];
};

if ((count _friendlyplacerHints) > 0) then {
    _allHints append [["Friendly Groups placer Setup", _friendlyplacerHints]];
};

if ((count _enemyplacerHints) > 0) then {
    _allHints append [["Enemy Groups placer Setup", _enemyplacerHints]];
};

_allHints;
*/