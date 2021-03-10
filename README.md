# Arma 3 AI vs AI Battle Scenario Template
This is a customizeable mission template to be used in the Eden editor. It allows you to quickly create a variety of battle scenarios involving many AI units just by placing and configuring a few objects in the editor.

#### Features
- Randomize the position of units across a certain area and make the units roam the mission area looking for enemies.
- Groups inform each other of known enemy locations and respond if they are able.
- Waypoints for infantry units are placed in a way that prefers moving between and attacking from areas with cover.
- Works on all levels of command: you can play as a simple soldier, a squad leader or a battlefield commander.
- Colored grid on the map showing the approximate location of enemies.
- Dynamic mission location - select the mission location on start.
- Works from small scale engagements to battles spanning across the entire map.
- Suitable both for singleplayer and multiplayer scenarios.

# Installation
1. Open up Arma, open up the editor, select a map and open it.
2. Place a player unit, save the mission.
3. On the top menu: <b>Scenario > Open Scenario Folder</b>
4. [Download this mission's .zip archive.](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template/releases/download/1.0.4/AI-vs-AI-Battle-Scenario-Template-1.0.4.zip)
5. Extract its contents to your mission's folder.
6. Go back to Arma, save and reopen the mission (**Scenario > Open...**), press PLAY SCENARIO.
7. If done correctly, you should see a hint confirming that the installation was successful.
8. Follow the **Mission Setup** instructions below.

# Mission Setup
Mandatory:
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
this setVariable ["intelGridSize", <b>100</b>];
this setVariable ["maxInfantryResponseDistance", <b>500</b>];
this setVariable ["maxVehicleResponseDistance", <b>1500</b>];
this setVariable ["maxAirResponseDistance", <b>10000</b>];
this setVariable ["dynamic", <b>false</b>];
</pre>
<b>1000</b> is the radius of the mission area. Units will roam around it looking for enemies. You may adjust the number.

<b>100</b> is the size of a colored square on the map showing you the approximate location of enemies in the mission area. You may adjust this number or set it to <b>0</b> to disable it. Setting the value to something very low will give you very precise positions but may negatively impact performance.

<b>500</b>, <b>1500</b>, <b>10000</b> are maximum distances at which infantry, vehicles and aircraft respond to intel about enemy locations. You may adjust these numbers.

You may change the <b>false</b> to <b>true</b> in `this setVariable ["dynamic", false];` to enable mission location selection at mission start. Read more about it below in the <b>Dynamic Mission Area</b> section.
</li>
<li>It is recommended to place a <b>Military Symbols</b> module in the editor (found in: <b>Systems > Modules > Other</b>). It allows you to see the position of friendly groups on the map.</li>
</ol>
<br>
</details>

<details>
<summary>Unit Placer Setup</summary>

## Unit Placer Setup
<b>Placers</b> are used to place AI units randomly within a certain area.

You must create some <b>placers</b> and sync them to the <b>Patrol Center</b> entity.
<ol>
<li>Place a <b>Game Logic</b> entity somewhere.
<li>
In its init box enter this:<br>
<pre>
this setVariable ["logicType", "placer"];
this setVariable ["minSpawnRadius", <b>0</b>];
this setVariable ["maxSpawnRadius", <b>600</b>];
</pre>

You may adjust the **numbers** for minSpawnRadius and maxSpawnRadius. These values determine the min/max distance from the placer where units can be spawned.
</li>

<li>Sync the <b>placer</b> to the <b>Patrol Center</b>.</li>
</ol>

You may repeat these steps to make as many placers as you want. At least two are recommended - one for each side.

<br>
</details>

<details>
<summary>Configuring Placers To Place Units</summary>

## Configuring Placers To Place Units
This randomizes the location of units within the radius defined in the placer and continuously creates waypoints to make the units patrol the mission area.

There are two ways of doing this:
<ol>
<li>
<details>
<summary><b>Syncing units (Recommended)</b></summary>
<br>
The simplest way to make a placer spawn units is to place units or vehicles in the editor and sync them to the placer.
<br><br>
Sync only one unit from the group, not the entire group. Doing otherwise would still work but it forces redundant calculations and makes initialization much slower.
<br><br>

Other things that can be synced to placers:
- **Respawn Position** Module
- **Spawn AI** Module
- **Spawn AI: Spawnpoint** Module
- Objects
<br><br>
</details>
</li>
<li>
<details>
<summary><b>Group variable</b></summary>

This method is more complex to setup but it has its uses. This makes the placer spawn new units rather than relocate those that were already created in the editor, meaning you could, for example, activate this placer at some later point in the mission to spawn reinforcements (see the <b>Adding extra logic with triggers or init fields</b> section below).
<br><br>

Add this to the placer's init box:
<pre>
this setVariable ["groups", [
    (<b>GROUP_CONFIG</b>),
    (<b>GROUP_CONFIG</b>),
    (<b>GROUP_CONFIG</b>)
]];
</pre>

Then do one or both of the following:
<ol>
<li>
<b>Use predefined group configs</b>

Replace <b>GROUP_CONFIG</b> with a group config path which can be found in the Eden editor <b>Tools -> Config Viewer</b>. Find <b>cfgGroups</b> on the left. Select the one you want and copy it from <b>Config Path</b> in the bottom of the screen. It should look something like this:<br>
<b>configFile >>"CfgGroups" >> "Indep" >> "IND_E_F" >> "Infantry" >> "I_E_InfTeam"</b><br>
You may add as many as you want. Add duplicates if you want more of the same group.
</li>
<li>
<b>Create custom groups</b>

You may also create custom groups out of individual units by replacing **(GROUP_CONFIG)** with for example:
<pre>
["<b>B_Truck_01_ammo_F</b>", "<b>B_Truck_01_Repair_F</b>"]
</pre>
These <b>names in bold</b> can be found by hovering over a unit placed in the Eden editor or in **configFile >> "CfgVehicles"**
</li>
</ol>
</details>
</li>
</ol>
<br>
</details>

Optional:

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
You can spawn camps by adding this to a placer's init box:
<pre>
this setVariable ["camps", [<b>side1</b>, <b>side2</b>]];
</pre>

Valid values for **sides** are **blufor**, **opfor**, **independent**. You may use as many as you want, duplicates are allowed.

The camps will be populated with units from the chosen side.

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
<summary>AI Revive Script Configuration</summary>

## AI Revive Script Configuration
This mission template has the [Grimes Simple Revive](https://github.com/kcgrimes/grimes-simple-revive) script integrated.

To enable it, change the **G_Revive_System** and **G_Briefing** values to **true** in the **G_Revive_init.sqf** file.

There are more configurations in there and they are well documented by the comments in the file. Adjust them to your liking.

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
<summary>Adding extra logic with triggers or init fields</summary>

## Adding extra logic with triggers or init fields
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
</details>

# Example missions
Extract these to Documents/Arma 3/missions/ and open with the Eden editor.

These missions may not use the latest version of the scripts so I do not recommend basing your own missions directly on these.
<ul>
<li>
<details>
<summary>Take part in a NATO assault against an area controlled by AAF and CSAT [SP/MP/COOP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template/releases/download/1.0.1/PartakeInAnAssaultAgainstEnemySector.Altis.zip)

This is the main example mission, showing off most of the available functionality and includes an explanation on how it was made in the mission diary.

Made on v1.0.1
</details>
</li>
<li>
<details>
<summary>Force Through Gamemode [SP/COOP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template/releases/download/1.0.3/BattleThroughMountainsTowardsKavala.Altis.zip)

This is the source for this mission: https://steamcommunity.com/sharedfiles/filedetails/?id=2418209864

This scenario demonstrates the possibility to add additional logic to the scenarios right in the editor without having to modify the scripts themselves. Look for the **missionLocationChangerLogic** object and expressions in the **Spawn AI** modules.

Made on v1.0.3

</details>
</li>
<li>
<details>
<summary>Survive an assault on your camp until reinforcements arrive [SP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template/releases/download/0.4.4/HoldOutUntilReinforcementsArrive.Altis.zip)

An intense scenario where you must survive an attack from all sides until reinforcements arrive to eliminate the enemy threat.

Made on v0.4.4
</details>
</li>
<li>
<details>
<summary>Basic battle across entire Altis [SP]</summary>
<br>

[Download](https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template/releases/download/1.0.1/WarAcrossAltis.Altis.zip)

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

# Credits
So far this mission uses these scripts from other developers:

- [CH View Distance Script by Champ-1](https://www.armaholic.com/page.php?id=27390)
- [Grimes Simple Revive](https://github.com/kcgrimes/grimes-simple-revive)

Thanks!

If you publish a scenario based on this template, please mention me in the credits as well.

# Changelog
<details>
<summary>Open changelog</summary>
<ul>
<li>
1.0.4 (2021-03-11)
<ul>
<li>Add rotation param to moveMissionArea function.</li>
<li>Add an extra position search fallback for objects placement.</li>
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