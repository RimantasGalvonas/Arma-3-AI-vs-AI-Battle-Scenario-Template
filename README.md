# Arma 3 Randomized Scenario Template

This is a customizeable single player (for now) mission template to be used in the Eden editor.

#### Features
- It allows you to spawn units and camps in randomized position and makes the units roam the mission area randomly.
- It draws a configurable grid on the map showing the approximate location of enemies.
- Works in all levels of command: you can play as a simple soldier, a squad leader or a battlefield commander.
- Waypoints for infantry units are placed in a way that prefers moving between areas with cover.
- Groups inform each other of known enemy locations and respond if they are able (unless set as subordinates to a high commander).
- Extra care is being taken to make units spawn in positions that do not make them explode on mission start or become stuck. It still sometimes happens but quite rarely.

# Installation

1. Open up Arma, open up the editor, select a map and open it.
2. Save the blank mission.
3. Alt+tab out of Arma and go to Documents/Arma 3/missions/<b>YOUR_NEW_MISSION_FOLDER</b>
4. [Download this mission's .zip archive.](https://github.com/RimantasGalvonas/RandomizedArma3Mission/releases)
5. Extract its contents to your mission's folder.
6. Go back to Arma, press PLAY SCENARIO.
7. If you start seeing instructions on how to setup the mission, you've installed the template correctly.
8. Follow the **Mission Setup** instructions below or in-game.

# Mission Setup

## Mission Area Setup

<ol>
<li>You must place a <b>Game Logic</b> entity (Found in Systems > Logic Entities) where you want the mission to take place.</li>
<li>You must name that entity <b>patrolCenter</b>.</li>
<li>
Enter these into said entity's init box:
<pre>
this setVariable ["patrolRadius", <b>600</b>];
this setVariable ["intelGridSize", <b>100</b>];
</pre>
<b>600</b> is the radius of the mission area. Units will roam around it looking for enemies. You may adjust the number.

<b>100</b> is the size of a colored square on the map showing you the approximate location of enemies in the mission area. You may adjust this number or set it to <b>0</b> to disable it. Setting the value to something very low will give you very precise positions but may negatively impact performance.
</li>
</ol>

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

You may also sync the player group with one of the placers to randomize the starting position.

## Configuring Placers To Place Units

### Method 1: Syncing units

The simplest way to make a placer spawn units is to place a unit or a group in the editor and sync it to the placer (sync only one unit from the group, not all of them). This will randomize that unit's position according to the placer and make them roam the mission area.

### Method 2: Group variable
Another way to make it spawn units is to add this to the placer's init box:
<pre>
this setVariable ["groups", [
    (<b>GROUP_CONFIG</b>),
    (<b>GROUP_CONFIG</b>),
    (<b>GROUP_CONFIG</b>)
]];
</pre>
#### Method 2.1.: Using group config paths
Replace **GROUP_CONFIG** with a group config path which can be found in the Eden editor **Tools -> Config Viewer**. Find **cfgGroups** on the left. Select the one you want and copy it from **Config Path** in the bottom of the screen. It should look something like this:<br>
**configFile >>"CfgGroups" >> "Indep" >> "IND_E_F" >> "Infantry" >> "I_E_InfTeam"**<br>
You may add as many as you want. Add duplicates if you want more of the same group.
#### Method 2.2.: Creating custom groups
You may also create custom groups out of individual units by replacing **(GROUP_CONFIG)** with for example:
<pre>
["<b>B_Truck_01_ammo_F</b>", "<b>B_Truck_01_Repair_F</b>"]
</pre>
These <b>names in bold</b> can be found by hovering over a unit placed in the Eden editor or in **configFile >> "CfgVehicles"**

## Configuring Placers To Place Other Placers

You can also make **placers** place other **placers**. This could be used, for example, to make all the enemies spawn together in some spot but that spot's location would be randomized across a large area.

Due to technical reasons, you can't just sync the two placers together. It has to be done this way:
<ol>
<li>Create a <b>placer</b> as usual, sync it to the <b>patrolCenter</b>.
<li>Create another <b>placer</b> as usual. Sync units to it (or use the **groups** variable, see above) but DON'T sync the placer itself to anything. You must give this <b>placer</b> a name. For example <b>randomized_position_placer</b></li>
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

## Configuring Placers To Place Camps

You can spawn camps by adding this to a placer's init box:
<pre>
this setVariable ["camps", [<b>side1</b>, <b>side2</b>]];
</pre>

Valid values for **sides** are **blufor**, **opfor**, **independent**. You may use as many as you want, duplicates are allowed.

The camps will be populated with units from the chosen side.

## High Command

It is recommended to place a **Military Symbols** module in the editor (found in: **Systems > Modules > Other**). It allows you to see the position of friendly groups on the map.

You may sync the player character with a **High Command - Commander** module (found in the same place as above). This will allow you to manually assign waypoints to AI groups instead of having them roam the mission area randomly.

Add this to the init box of some **placers**. It will allow you to command the units from that placer:
<pre>
this setVariable ["highCommandSubordinates", true];
</pre>
To enter high command mode, press **Left Ctrl+Space**.

# Credits

So far this mission uses these scripts from other developers:

- [CH View Distance Script by Champ-1](https://www.armaholic.com/page.php?id=27390)

Thanks!