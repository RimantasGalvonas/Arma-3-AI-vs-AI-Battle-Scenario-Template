# Arma 3 AI vs AI Battle Scenario Framework
This is a customizeable mission framework to be used in the Eden editor. It allows you to quickly create a variety of battle scenarios involving many AI units just by placing and configuring a few objects in the editor.

#### Features
- Randomized placement of AI units at predefined spawn areas.
- Automatic waypoint creation that has the AI groups searching for and attacking enemies across the mission area.
- AI groups sharing locations of known enemies with friendly units, distributing targets to attack among themselves.
- Smart AI infantry group movement - groups try to stick to areas with cover, pick advantageous positions to attack from, taking height advantage, amount of cover and distance from other friendly units into account. Option to have them walk slowly in covered areas and run across open terrain.
- Ability for players to switch to another nearby group or take over as the group's leader.
- Mission configuration GUI with options to select the mission area, spawned units, weather and some AI options.
- Battlefield illumination by flares at night.
- Colored grid on the map showing the approximate location of enemies.
- Works on all levels of command: you can setup missions where you play as a simple soldier, a squad leader, a battlefield commander, or switch between these roles.
- Works from small-scale engagements to battles spanning across the entire map.
- Suitable both for singleplayer and multiplayer scenarios.

# Installation
1. Open up Arma, open up the editor, select a map and open it.
2. Place a player unit, save the mission.
3. On the top menu: <b>Scenario > Open Scenario Folder</b>
4. [Download this mission's .zip archive.](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Framework/releases/download/1.5.4/AI-vs-AI-Battle-Scenario-Framework-1.5.4.zip)
5. Extract its contents to your mission's folder.
6. Go back to Arma, save and reopen the mission (**Scenario > Open...**), press PLAY SCENARIO.
7. If done correctly, you should see a hint confirming that the installation was successful.
8. Follow the **Mission Setup** instructions below.

# Mission Setup
<details>
<summary>Mission Area Setup</summary>

## Mission Area Setup
<ol>
<li>You must place a <b>Game Logic</b> entity (Found in Systems > Logic Entities) where you want the mission to take place.</li>
<li>You must name that entity <b>patrolCenter</b>.</li>
<li>
Enter these into said entity's init box:
<pre>
this setVariable ["patrolRadius", <b>1000</b>];
this setVariable ["intelGridResolution", <b>6</b>];
this setVariable ["flaresLevel", <b>0</b>];
this setVariable ["groupSwitching", <b>false</b>];
this setVariable ["maxInfantryResponseDistance", <b>500</b>];
this setVariable ["maxVehicleResponseDistance", <b>1500</b>];
this setVariable ["maxAirResponseDistance", <b>10000</b>];
this setVariable ["dynamic", <b>false</b>];
</pre>
<b>patrolRadius</b> is the radius of the mission area. Units will roam around it looking for enemies. You may adjust the number.

<b>flaresLevel</b> is the level of battlefield illumination by flares at night. Valid values: 0, 1, 2, 3. 0 to disable.

<b>groupSwitching</b> allows the player to join another nearby group or take over as the group's leader.

<b>intelGridResolution</b> is the resolution of colored squares on the map showing you the approximate location of enemies in the mission area. You may adjust this number or set it to <b>0</b> to disable it. Setting the value to something very high will give you very precise positions but may negatively impact performance.

<b>maxInfantryResponseDistance</b>, <b>maxVehicleResponseDistance</b>, <b>maxAirResponseDistance</b> are maximum distances at which infantry, vehicles and aircraft respond to intel about enemy locations. You may adjust these numbers.

You may change the <b>dynamic</b> value to <b>true</b> in `this setVariable ["dynamic", false];` to enable mission location selection at mission start. Read more about it below in the <b>Dynamic Mission Area</b> section.
</li>
<li>It is recommended to place a <b>Military Symbols</b> module in the editor (found in: <b>Systems > Modules > Other</b>). It allows you to see the position of friendly groups on the map.</li>
</ol>
<br>
</details>

<details>
<summary>Placer Setup</summary>

## Placer Setup
<b>Placers</b> are used to randomize the location of certain items within a defined area.

Things that can be synced to a placer to have its position randomized:
<ul>
<li>Groups (note - sync only one unit from the group, not the whole group - syncing multiple units from the same group causes redundant calculations and slows down mission initialization)</li>
<li>Objects</li>
<li><b>Respawn Position</b> Module</li>
<li><b>Spawn AI</b> Module</li>
<li><b>Spawn AI: Spawnpoint</b> Module</li>
</ul>

Additionally, these placers can place AI spawners and can have sub-placers. This is described further below in separate sections.

Configuring placers:
<ol>
<li>Place a <b>Game Logic</b> entity somewhere.
<li>Sync it to the <b>Patrol Center</b> entity.</li>
<li>
In its init box enter this:<br>
<pre>
this setVariable ["logicType", "placer"];
</pre>
</li>
<li>
Define the area where the placer can place things by either of these two methods:
<ol>
<li>
Create a <b>trigger</b> (or several) with a non-zero area, give it a name and put it in the init field:
<pre>
this setVariable ["areaTriggers", [<b>triggerName1</b>, <b>triggerName2</b>]];
</pre>

Several different placers can share the same trigger for their area too.<br>
Note that if you're using <b>Dynamic Mission Area</b>, you also have to sync these triggers to the <b>patrolCenter</b> entity.
<br><br>
</li>
<li>
Add this to the init field:
<pre>
this setVariable ["minSpawnRadius", <b>0</b>];
this setVariable ["maxSpawnRadius", <b>600</b>];
</pre>

You may adjust the **minSpawnRadius** and **maxSpawnRadius**. These values determine the min/max distance from the placer where units can be spawned.
</li>
</ol>
</li>
</ol>

You may repeat these steps to make as many placers as you want.

<br>
</details>

<details>
<summary>Configuring Spawners</summary>

## Configuring Spawners

**Spawners** allow you to spawn new groups within a **placer's** area. It partially mimics the functionality of Arma's **Spawn AI** module, but in a more streamlined way and comes with additional features.
<br><br>

<ol>
<li>
Create a <b>Logic Entity</b>. Give it a name, for example <b>spawner_1</b>.
</li>
<li>
Assign this <b>spawner</b> to one of the <b>placers</b> by adding this to the <b>placer's</b> <b>init</b> field:
<pre>
this setVariable ["spawners", [<b>spawner_1</b>]];
</pre>
</li>
<li>
Configure the <b>spawner</b> by setting variables for it in its <b>init</b> field. Example configuration:

    this setVariable ["logicType", "spawner"];
    this setVariable ["maxUnitsPerGroup", 8];
    this setVariable ["spawnRate", 5];
    this setVariable ["maxUnits", 20];

    private _pool1 = createHashMapFromArray [
        ["groups", [
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfAssault",
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad",
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad_Weapons"
        ]],
        ["weight", 10],
        ["vehicleCrewGrouping", false]
    ];
    
    private _pool2 = createHashMapFromArray [
        ["groups", [
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconSquad",
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconTeam",
            configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_SniperTeam"
        ]],
        ["weight", 2],
        ["vehicleCrewGrouping", false]
    ];
    
    this setVariable ["pools", [_pool1, _pool2]];
    
    this setVariable [
        "callback",
        {
            params ["_group", "_spawner", "_placer"];
            {addSwitchableUnit _x;} forEach units _group;
            [_placer] call Rimsiakas_fnc_placer;
        }
    ];
<ul>
<br>
Explanation:
<br><br>
<li>
<pre>
this setVariable ["maxUnitsPerGroup", 8];
</pre>
If you set this variable, groups with the amount of soldiers exceeding this number are trimmed down to the desired size.
<br><br>
</li>
<li>
<pre>
this setVariable ["spawnRate", 10];
this setVariable ["maxUnits", 20];
</pre>
If you set these variables, it makes the <b>spawner</b> spawn new groups continuously every <b>spawnRate</b> seconds until the number of units spawned by this <b>spawner</b> reaches <b>maxUnits</b>. It then pauses and waits until some of the spawned units die before reactivating.
<br><br>
</li>
<li>
<pre>
private _pool1 = [
    ...
];

private _pool2 = [
...
];

this setVariable ["pools", [_pool1, _pool2]];
</pre>
You must define at least one <b>pool</b> per spawner.


One of the pools will be randomly selected according to assigned weights. (See [selectRandomWeighted](https://community.bistudio.com/wiki/selectRandomWeighted) for how it works).
Then one of the groups from that pool will be randomly selected to spawn.
So in this example the spawner is configured to spawn one of three infantry groups ~<b>66</b>% of the time and one of three mounted groups ~<b>33</b>% of the time, every <b>10</b> seconds until <b>20</b> spawned units limit is reached.

You may also create custom groups out of individual units:
<pre>
private _pool1 = [
    ["B_Truck_01_ammo_F", "B_Truck_01_Repair_F"]
];
</pre>

The <b>vehicleCrewGrouping</b> value determines how to count spawned vehicles towards the <b>maxUnits</b> limit - the entire vehicle's crew as one or each crewman individually.
</li>
<li>
<pre>
this setVariable [
    "callback",
    {
        params ["_group", "_spawner", "_placer"];
        {addSwitchableUnit _x;} forEach units _group;
        [_placer] call Rimsiakas_fnc_placer;
    }
];
</pre>
This allows you to run some code after the group is spawned. The spawned group, the spawner and the placer that the spawner is associated with, are passed as arguments to the function you provide here.
</li>
</ul>
</li>
</ol>
<br><br>
</details>

<details>
<summary>Configuring Placers To Place Other Placers</summary>

## Configuring Placers To Place Other Placers
You can also make **placers** place other **placers**. This could be used, for example, to make all the enemies spawn together in some spot but that spot's location would be randomized across a large area.

Due to technical reasons, you can't just sync the two placers together. It has to be done this way:
<ol>
<li>Create a <b>placer</b> as usual, sync it to the <b>patrolCenter</b>.
<li>Create another <b>placer</b> as usual. Sync units to it (or use the <b>groups</b> variable, see above) but DON'T sync the placer itself to anything. You must give this <b>placer</b> a name. For example <b>randomized_position_placer</b></li>
<li>
Add this to the init box of the <b>placer created in step 1</b>:
<pre>
this setVariable ["childPlacers", [<b>randomized_position_placer</b>]];
</pre>

You can use more than one:<br>
<pre>
this setVariable ["childPlacers", [<b>unitPlacer1</b>, <b>unitPlacer2</b>]];
</pre>
</li>
</ol>

The **placer created in step 1** will randomize the position of the **placer created in step 2**. The latter one will in turn randomize the position of units assigned to it.

You may also add this to the init box of the **placer created in step 2** to attempt to place it at a location that has a road within its radius:
<pre>
this setVariable ["preferRoad", true];
</pre>

<br>
</details>

<details>
<summary>Configuring Placers To Place Camps</summary>

## Configuring Placers To Place Camps
Note: this functionality is just a prototype and may not be very useful at this point. It may be entirely rewritten in the future with no backwards compatibility in mind.

You can spawn camps by adding this to a placer's init box:
<pre>
this setVariable ["camps", [<b>side1</b>, <b>side2</b>]];
</pre>

Valid values for **sides** are **blufor**, **opfor**, **independent**. You may use as many as you want, duplicates are allowed.

The camps will be populated with units from the chosen side.

<br>
</details>

<details>
<summary>AI Behavior Configuration</summary>

## Ai Behavior Configuration
You can adjust the behavior of AI by setting these variables on the <b>patrolCenter</b> entity:

<pre>
this setVariable ["aiConfigPatrolFormation", formation];
this setVariable ["aiConfigAttackFormation", formation];
</pre>

**aiConfigPatrolFormation** sets the formation for groups when they are patrolling the mission area looking for enemies, or moving towards their assigned target.

The group will switch to the **aiConfigAttackFormation** once they get within engagement distance to their target.

Valid values for **formation** are defined [here](https://community.bistudio.com/wiki/setWaypointFormation).

<br>
<pre>
this setVariable ["aiConfigSpeedMode", speedMode];
</pre>

Sets the group movement speed mode. Valid values for **speedMode** are:
<ul>
<li>

**"NORMAL"** - default Arma waypoint speed - units always on the run.
</li>
<li>

**"SMART"** - custom scripted movement mode where units will run across open terrain and walk slowly when in sufficient cover.
</li>
<li>

**"SLOW"** - walk slowly.
</ul>

<br>
<pre>
this setVariable ["aiConfigAttackSpeedOverride", true];
</pre>

Override for the speed mode setting above. Switches the group speed mode to **NORMAL** while the group has a target assigned.

<br>
<pre>
this setVariable ["aiConfigAllowLastManToJoinNewGroup", true];
</pre>

Allows the last surviving units from a wiped out group to join a nearby friendly group.

<br>
<pre>
this setVariable ["aiConfigForceFormation", true];
</pre>

Stop the units from breaking formation to engage their targets.

<br>
<pre>
this setVariable ["aiConfigUnlimitedIdleGroupResponseDistance", true];
</pre>

Overrides the **maxInfantryResponseDistance**, **maxVehicleResponseDistance** and **maxAirResponseDistance** settings for groups that don't have a target assigned, allowing them to pick known targets from any distance.

The response distance settings will still apply when the group checks for better nearby targets to switch to.

<br>
<pre>
this setVariable ["aiConfigMaxAttackRatio", 3];
</pre>

The maximum number of groups that can attack the same enemy group. This allows groups to keep looking for new targets if the ones that are already known, are already being engaged by friendlies.

If not set, defaults to **3**.

<br>
</details>

<details>
<summary>High Command</summary>

## High Command
High Command allows you to manually assign waypoints to chosen AI groups instead of having them roam the mission area automatically.

To enable it:
<ol>
<li>
Place a <b>High Command - Commander</b> module (found in: <b>Systems > Modules > Other</b>) in the editor.
</li>
<li>
Sync a playable unit to the <b>High Command - Commander</b> module.
</li>
<li>
Place a <b>High Command - Subordinate</b> module and sync it to the <b>High Command - Commander</b> module. You don't need to sync any units to the subordinate module.
</li>
<li>
Add this to the init box of some <b>placers</b>. It will allow you to command the units from that placer:
<pre>
this setVariable ["highCommandSubordinates", true];
</pre>
</li>
</ol>

To enter high command mode, press **Left Ctrl+Space**.

<br>
</details>

<details>
<summary>Dynamic Mission Area</summary>

## Dynamic Mission Area
You can put this in the init box of the <b>patrolCenter</b> entity to enable mission location selection on mission start:
<pre>this setVariable ["dynamic", true];</pre>

Some things to keep in mind:
<ul>
<li>
Relative positions of synced placers are preserved. If you want a certain placer not to be moved when changing the mission location, you can add this to its init box:
<pre>this setVariable ["dynamic", false];</pre>
</li>
<li>
Sync your <b>triggers</b> to the <b>patrolCenter</b> entity to have them moved when changing the mission location. It is advised to add this to the <b>condition</b> box of the triggers:
<pre>this && Rimsiakas_missionInitialized</pre>
This makes the trigger inactive until placement of units on the battlefield is finished.
</li>
<li>
When you scale or rotate the mission area, the triggers the areas of triggers and placers that are synced to the <b>Patrol Center</b> entity are also scaled.<br/>
If you want the placer spawn radiuses not to change when doing this, add this variable to its init field:
<pre>this setVariable ["scalable", false];</pre>
Because triggers do not have an init field, you will have to use an init field of some other entity (e.g. <b>Game Logic</b>) to set this value:
<pre>triggerName setVariable ["scalable", false];</pre>
</li>
</ul>

<br>
</details>

<details>
<summary>Multiplayer Considerations</summary>

## Multiplayer Considerations
Here are some things to keep in mind when using this template to create multiplayer missions:
- When placing units on the map, make sure to place them some distance apart and facing away from hostile units. Otherwise when the mission starts the group may spawn in combat mode.
- When using Dynamic Mission Area in multiplayer, the configuration dialog may show up before the map loading screen goes away. In that case you will have to wait for the loading screen to go away if you wish to use the location preview button.
- **Respawn Position** modules can be synced to placers to have their locations randomized.
- Other than that, nothing too special is required for this to work on multiplayer:<br>
  Set some settings in <b>Attributes > Multiplayer...</b> in the editor, set some units as playable and you're good to go.


<br>
</details>

<details>
<summary>Adding Extra Logic With Triggers Or Init Fields</summary>

## Adding Extra Logic With Triggers Or Init Fields
<ul>
<li>
<details>
<summary>Waiting until the mission has fully initialized</summary>

Init fields and statements in triggers are evaluated as soon as the mission loads. However, the mission setup scripts may still be moving things around. This may cause triggers to activate prematurely and have other undesired effects.

When the scripts have finished setting up the mission, a <b>Rimsiakas_missionInitialized</b> variable is created. You can check for its existence to make sure your triggers or code in init fields is evaluated only after the mission has fully initialized.

Example trigger condition:
<pre>
this && Rimsiakas_missionInitialized
</pre>

Example init field:
<pre>
_var = [] spawn {
    waitUntil {!isNil "Rimsiakas_missionInitialized"};
    // your code here
};
</pre>
<br>
</details>
</li>
<li>
<details>
<summary>Moving the mission area</summary>

You can move the mission area and all the placers and triggers synced to it with this command:
<pre>
[_newPosition, _rotationAngle] call Rimsiakas_fnc_moveMissionArea;
</pre>
After that you have to reinitialize the intel grid, if you are using it:
<pre>
remoteExec ["Rimsiakas_fnc_createIntelGrid"];
</pre>
<br>
</details>
</li>
<li>
<details>
<summary>Manually activating a placer</summary>

Placers can be activated manually like this:
<pre>
_var = [] spawn {
    [placerName] call Rimsiakas_fnc_placer;

    {_x enableAI "all";} forEach allUnits;
};
</pre>

When placing units, the AI for those units is disabled, that's why there's a line there to reenable AI.

Note that these commands are wrapped in a `[] spawn {}` statement. This makes the placer run in the [scheduler](https://community.bistudio.com/wiki/Scheduler). This is needed because the logic for placers that have subplacers requires [script suspension](https://community.bistudio.com/wiki/Scheduler#Suspension).
<br>
<br>
</details>
</li>
<li>
<details>
<summary>Making a group attack a specific unit</summary>
<pre>
[_group, _target, _targetPriority] call Rimsiakas_fnc_attackEnemy;
</pre>
<b>_target</b> must be a human unit.<br>
<b>_targetPriority</b> - a number (default 1). It is one of the criteria in determining if a group can abandon its target for a new one. Set it to 100 to make sure the group stays on this target.
<br>
<br>
</details>
</li>
<li>
<details>
<summary>Making a group search for enemies in the mission area</summary>
<pre>
[_group] call Rimsiakas_fnc_searchForEnemies;
</pre>
This will also make the group abandon its current target.
<br>
<br>
</details>
</li>
<li>
<details>
<summary>Making a group ignore all the intel about enemy locations</summary>
<pre>
_group setVariable ["ignoreIntel", true];
</pre>
</details>
</li>
</ul>


<br>
</details>

<details>
<summary>Extending With Custom Scripts</summary>

## Extending With Custom Scripts
You should use the **mission** directory to add your own scripts.

The framework currently uses these default files:
<ul>
<li>Description.ext</li>
<li>initPlayerLocal.sqf</li>
<li>initPlayerServer.sqf</li>
<li>initServer.sqf</li>
<li>onPlayerRespawn.sqf</li>
</ul>

To add to these scripts without modifying the framework, you can add "extension" files in the **mission** directory. For example:
- **mission/initPlayerLocal_pre.sqf** - contents of your file be inserted at the start of **initPlayerLocal.sqf**.
- **mission/initPlayerLocal_post.sqf** - contents of your file be inserted at the start of **initPlayerLocal.sqf**.
- **mission/initPlayerLocal.sqf** - **initPlayerLocal.sqf** will be replaced by the contents of your file.

Additionally, if you want to insert your own code into the **CfgFunctions** section of **Description.ext**, you can create a **mission\Description_functions.hpp** file.  


<br>
</details>

# Example missions
Extract these to Documents/Arma 3/missions/ and open with the Eden editor.

<ul>
<li>
<details>
<summary>Take part in a NATO assault against an area controlled by AAF and CSAT [SP/MP/COOP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Framework/releases/download/1.4.1/PartakeInAnAssaultAgainstEnemySector.Altis.zip)

This is the main example mission, showing off most of the available functionality and includes an explanation on how it was made in the mission diary.

Made on v1.4.1
</details>
</li>
<li>
<details>
<summary>Force Through Gamemode [SP/COOP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Framework/releases/download/1.5.4/ForceThroughMissions.zip)

This is the source for these missions: https://steamcommunity.com/workshop/filedetails/?id=2427506774

Made on v1.5.4

</details>
</li>
<li>
<details>
<summary>Survive an assault on your camp until reinforcements arrive [SP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Framework/releases/download/0.4.4/HoldOutUntilReinforcementsArrive.Altis.zip)

An intense scenario where you must survive an attack from all sides until reinforcements arrive to eliminate the enemy threat.

Made on v0.4.4
</details>
</li>
<li>
<details>
<summary>Basic battle across entire Altis [SP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Framework/releases/download/1.0.1/WarAcrossAltis.Altis.zip)

Basically just a benchmark to show the scalability of these scripts.

Made on v1.0.1
</details>
</li>
</ul>

# Contact me
If you have any questions, suggestions, feedback, etc. you can contact me here:
- [Bohemia Interactive Forums](https://forums.bohemia.net/forums/topic/231958-release-ai-vs-ai-battle-scenario-template-spmpcoop/)
- [Reddit](https://www.reddit.com/r/armadev/comments/l8y1wy/ai_vs_ai_battle_scenario_template/)
- [Steam](https://steamcommunity.com/app/107410/discussions/18/3104638636520370752/)

# Changelog
<details>
<summary>Open changelog</summary>
<ul>
<li>
1.5.5 (YYYY-MM-DD)
<ul>
<li>Reduce errors when trying to find a spawn zone in watery areas.</li>
</ul>
</li>
<li>
1.5.4 (2026-05-29)
<ul>
<li>Fix groups sometimes not switching into attack formation when they should.</li>
<li>Hide the factions config button when there are no spawners.</li>
</ul>
</li>
<li>
1.5.3 (2026-03-25)
<ul>
<li>Transmit env changes to clients immediately, making it respond faster on dedicated server.</li>
<li>Replace faction config presets with presets for the entire mission config.</li>
</ul>
</li>
<li>
1.5.2 (2026-03-19)
<ul>
<li>Option to add extra ammo to spawned units.</li>
<li>Remove CHVD integration.</li>
<li>Placer param to skip generating waypoints.</li>
<li>Generate last played factions preset.</li>
<li>Edit custom group on double click instead of deleting.</li>
</ul>
</li>
<li>
1.5.1 (2026-03-04)
<ul>
<li>Improve custom group GUI with vehicle config tree.</li>
<li>Copy/paste groups in spawner pool.</li>
</ul>
</li>
<li>
1.5.0 (2026-03-01)
<ul>
<li>More powerful group spawning functionality.</li>
<li>Spawner configuration GUI.</li>
<li>Support for extension scripts.</li>
<li>Make proximity penalties less strict half the time.</li>
<li>Penalize attack positions that require going off to the side.</li>
<li>Don't create waypoint at current location unless it's actually a good position.</li>
<li>Fix incorrect behavior when pressing Esc in mission location preview.</li>
<li>Add a compass arrow icons in mission location preview.</li>
<li>Remove the Grimes Simple Revive integration.</li>
<li>Allow joining groups from the allied side.</li>
<li>Move mission area transformation controls to the main config window.</li>
<li>Fix vehicles sometimes being placed at the pre-defined default terrain position.</li>
<li>Disable damage for a few seconds after spawning.</li>
<li>Allow placers in the air.</li>
</ul>
</li>
<li>
1.4.4 (2026-02-16)
<ul>
<li>Allow syncing triggers to placers to define their area.</li>
<li>Update the camp compositions to make stationary soldiers stay standing up.</li>
</ul>
</li>
<li>
1.4.3 (2026-02-11)
<ul>
<li>Fix the unfinished implementation of widening the attack position angles from 1.4.0.</li>
<li>If an attack position with visibility can't be found, do another simpler search for a covered position away from other friendly attack positions.</li>
<li>Flare timing adjustments.</li>
<li>Allow waypoints in shallow water.</li>
<li>Closer flanking distance limits for less open terrains.</li>
<li>Turn group towards last known target position at waiting endpoints.</li>
</ul>
</li>
<li>
1.4.2 (2026-02-05)
<ul>
<li>Move the Force Through group switching functionality into the framework.</li>
<li>Play a sound when shooting flares.</li>
<li>Use the getLighting command to determine when to start shooting flares.</li>
</ul>
</li>
<li>
1.4.1 (2026-02-01)
<ul>
<li>Add 3 presets for varying flare illumination levels.</li>
<li>Adjust flares according to the wind.</li>
<li>Shoot flares more vertically in the forest.</li>
</ul>
</li>
<li>
1.4.0 (2026-01-24)
<ul>
<li>Fix bug where changing the inventory response distance in the mission configuration dialog messes up the intel grid size value.</li>
<li>Update the logic for picking a position to attack from:</li>
<ul>
<li>Groups will now try to avoid positions that other groups have already picked as an attack position. This should help groups spread out more, if there's enough good favorable positions.</li>
<li>Update the angles from which the groups can choose to attack. This should reduce the amount of long annoying detours while allowing better flanking angles.</li>
</ul>
<li>Update the mission configuration dialog design.</li>
<li>New setting to automatically spawn flares at night.</li>
<li>Breaking change: intelGridSize param for patrolCenter was renamed to intelGridResolution.</li>
</ul>
</li>
<li>
1.3.3 (2025-10-26)
<ul>
<li>New setting to allow infinite response distance for groups as long as they have no target assigned (no GUI, set by script only).</li>
<li>Remove the max attack ratio setting from the GUI, but leave the functionality intact.</li>
</ul>
</li>
<li>
1.3.2 (2025-10-25)
<ul>
<li>New setting to prevent AI from leaving the formation to engage targets.</li>
<li>Show what friendly groups are attacking on the map.</li>
<li>Make the battle area border more visible.</li>
</ul>
</li>
<li>
1.3.1 (2025-10-22)
<ul>
<li>Target selection improvements:</li>
<ul>
<li>Find best target on the first run, reducing annoying target switching.</li>
<li>Make groups prioritize targets that have fewer units already attacking them.</li>
<li>Configurable limit on how many groups can be targeting the same group. This helps keep the battle a bit more spread out rather than condensing into a single spot.</li>
<li>Allow unengaged units that are closest to possible targets choose their targets first, resulting in less random looking target selections.</li>
</ul>
<li>Change the patrol endpoint to MOVE instead of SEARCH AND DESTROY, removing the pointless wandering around at the end of the patrol route.</li>
<li>Fix intel grid appearance - remove grey blocks, add border instead.</li>
</ul>
</li>
<li>
1.3.0 (2025-10-05)
<ul>
<li>AI configuration dialog with options for:</li>
<ul>
<li>Group patrol and attack formation.</li>
<li>Movement speed, including a custom "smart" mode where AI runs in open areas and moves slowly in cover.</li>
<li>Allowing last remaining units from a wiped out group join a new group nearby.</li>
</ul>
<li>More forest detection improvements, again.</li>
</ul>
</li>
<li>
1.2.2 (2021-10-03)
<ul>
<li>Make forest detection more sensitive.</li>
<li>Decrease flanking distance when position is among buildings the same way as with forests.</li>
</ul>
</li>
<li>
1.2.1 (2021-07-03)
<ul>
<li>Add fog slider.</li>
<li>Add visible mission area border in preview.</li>
</ul>
</li>
<li>
1.2.0 (2021-06-16)
<ul>
<li>Make Dynamic Mission Area compatible with dedicated servers.</li>
</ul>
</li>
<li>
1.1.3 (2021-06-12)
<ul>
<li>Fix unit placement incompatibility with RHS vehicles.</li>
<li>Allow multiple groups to disperse instead of sweeping the area of last contact if no new targets are known.</li>
</ul>
</li>
<li>
1.1.2 (2021-04-28)
<ul>
<li>Make groups take cover when staying at waypoints to look for enemies.</li>
<li>Decrease engagement and flanking distance in forests.</li>
<li>Fix actual vantage point waypoints not being added.</li>
<li>Allow switching to a different target when the current target group is fleeing.</li>
</ul>
</li>
<li>
1.1.1 (2021-03-25)
<ul>
<li>Fix group icons and view distance settings disappearing after a few times dying.</li>
<li>Stop player-deployed UAVs from reacting to intel on their own.</li>
<li>Add 'relocateToNearestLandIfOnWater' variable for placers to relocate the placer to the nearest coast automatically.</li>
</ul>
</li>
<li>
1.1.0 (2021-03-17)
<ul>
<li>Dynamic Mission Area - Add advanced mission area configuration dialog, allowing rotation and scaling of the mission area.</li>
</ul>
</li>
<li>
1.0.4 (2021-03-11)
<ul>
<li>Add rotation param to moveMissionArea function.</li>
<li>Add an extra position search fallback for objects placement.</li>
<li>Increase the random roam area.</li>
<li>Place combat movement waypoints placement more precisely near cover.</li>
<li>Make groups hold position only at waypoints with enough cover.</li>
</ul>
</li>
<li>
1.0.3 (2021-03-09)
<ul>
<li>Decrease group's tendency to clump together.</li>
<li>Don't show Grimes Simple Revive validation messages if it's not enabled.</li>
<li>Fix intel grid not matching the mission exactly.</li>
<li>Fix group icons sometimes disappearing from the map after teamswitch or respawn</li>
<li>Allow syncing objects to placers</li>
</ul>
</li>
<li>
1.0.2 (2021-02-08)
<ul>
<li>Allow syncing Spawn AI modules to placers.</li>
</ul>
</li>
<li>
1.0.1 (2021-02-04)
<ul>
<li>Take height advantage into consideration when choosing a position to attack from.</li>
</ul>
</li>
<li>
1.0.0 (2021-01-31)
<ul>
<li>Stop mounted units charging straight onto their targets by using DESTROY instead of SAD waypoints for vehicles.</li>
</ul>
</li>
<li>
0.7.3 (2021-01-30)
<ul>
<li>Prevent empty vehicles from being assigned as targets</li>
</ul>
</li>
<li>
0.7.2 (2021-01-25)
<ul>
<li>Refactoring to expose some logic for easier manipulation with in-game scripts</li>
<li>Allow usage of respawn position modules with placers</li>
</ul>
</li>
<li>
0.7.1 (2021-01-17)
<ul>
<li>Fix ground units trying to attack UAVs, causing waypoints being created infinitely</li>
<li>Stop APCs from trying to engage tanks</li>
</ul>
</li>
<li>
0.7.0 (2021-01-16)
<ul>
<li>Infantry combat movement overhaul - squads will try to find an advantageous position with good visibility to fire from rather than advance onto the targets directly</li>
<li>Adjusted the evaluation if the group has seen its target recently to check for any target group member rather than the specific target</li>
</ul>
</li>
<li>
0.6.5 (2021-01-08)
<ul>
<li>Fix parent and child placer configurations getting mixed up, causing all units from parent placer being placed close together</li>
<li>Optimizations for intel sharing</li>
<li>Workaround for an Arma bug which could cause groups spawned with camps being assigned waypoints from other groups</li>
<li>Make groups stay at their search and destroy waypoints until they've dealt with or lost contact with their target</li>
<li>Remove the in-game setup instructions and show link to this documentation instead</li>
</ul>
</li>
<li>
0.6.4 (2021-01-04)
<ul>
<li>Add ability to configure date/time and weather in mission location selection</li>
</ul>
</li>
<li>
0.6.3 (2021-01-03)
<ul>
<li>Fix groups not redirecting to nearer targets</li>
<li>React to intel about new position of current target</li>
</ul>
</li>
<li>
0.6.2 (2021-01-02)
<ul>
<li>Fix not all types of triggers and vehicles being moved when using dynamic mission location</li>
<li>Speed up AI reenabling</li>
</ul>
</li>
<li>
0.6.1 (2020-12-31)
<ul>
<li>Removed automatically enabling team switch for group units as it can be controlled in the editor by setting the unit as playable</li>
<li>Fixed AI not being re-enabled after teamswitching</li>
<li>Fixed "View Distance Settings" action not being added after teamswitch or respawn</li>
</ul>
</li>
<li>
0.6.0 (2020-12-31)
<ul>
<li>Added an option to selection the mission location on mission start</li>
</ul>
</li>
<li>
0.5.0 (2020-12-26)
<ul>
<li>Multiplayer support</li>
</ul>
</li>
<li>
0.4.10 (2020-12-23)
<ul>
<li>Added an option to prefer placing subplacers on roads</li>
<li>Stop non-air units chasing after air units</li>
</ul>
</li>
<li>
0.4.9 (2020-12-21)
<ul>
<li>Set SUPPORT waypoint for groups with support vehicles</li>
</ul>
</li>
<li>
0.4.8 (2020-12-20)
<ul>
<li>Fixed allied side group icons disappearing when teamswitching</li>
</ul>
</li>
<li>
0.4.7 (2020-12-19)
<ul>
<li>Camp spawn improvements - random rotation, allow both static and non-static units in camp</li>
</ul>
</li>
<li>
0.4.6 (2020-12-15)
<ul>
<li>Updated the intel share logic to make units redirect to closer targets</li>
</ul>
</li>
<li>
0.4.5 (2020-12-15)
<ul>
<li>Scalability improvements to support very large mission areas</li>
</ul>
</li>
<li>
0.4.4 (2020-12-14)
<ul>
<li>Fix vehicles sometimes spawning somewhere far away</li>
</ul>
</li>
<li>
0.4.3 (2020-12-14)
<ul>
<li>Configured the AI revive script to be disabled by default</li>
</ul>
</li>
<li>
0.4.2 (2020-12-13)
<ul>
<li>Use DESTROY instead of SEARCH AND DESTROY waypoint for tank targets to allow armor to be redirected as soon as they deal with their targets</li>
</ul>
</li>
<li>
0.4.1 (2020-12-12)
<ul>
<li>Fixed mechanized infantry vehicles ofter exploding on spawn</li>
</ul>
</li>
<li>
0.4.0 (2020-12-12)
<ul>
<li>Implement Grimes Simple Revive script</li>
</ul>
</li>
<li>
0.3.0 (2020-12-12)
<ul>
<li>Added sharing of intel about known enemy positions between groups</li>
<li>Orient groups toward waypoint on spawn</li>
</ul>
</li>
<li>
0.2.1 (2020-12-11)
<ul>
<li>Initialization speed improvements</li>
</ul>
</li>
<li>
0.2.0 (2020-12-10)
<ul>
<li>Prefer placing vehicles on roads</li>
<li>Fix some issues with high command mode</li>
</ul>
</li>
<li>
0.1.0 (2020-12-09)
<ul>
<li>First release</li>
</ul>
</li>
</ul>
</details>
