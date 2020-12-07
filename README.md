# Arma 3 Randomized Scenario Template

This is a customizeable single player (for now) mission template to be used in the Eden editor.

It allows you to spawn units and camps in randomized position and makes the units roam the mission area randomly. It also allows you to control selected groups with High Command.

# Mission Setup

## Mission Area Setup

You must place a **Game Logic** entity (Found in Systems > Logic Entities) where you want the mission to take place. You must name that entity **patrolCenter**.
Enter these into said entity's init box:
<pre>
this setVariable ["patrolRadius", <b>600</b>];
this setVariable ["intelGridSize", <b>100</b>];
</pre>
**600** is the radius of the mission area. Units will roam around it looking for enemies. You may adjust the number.

**100** is the size of a colored square on the map showing you the approximate location of enemies in the mission area. You may adjust this number or set it to **0** to disable it. Setting the value to something very low will give you very precise positions but may negatively impact performance.

## Unit Placer Setup

You must create some **placers** and sync them to the **Patrol Center** entity. **Placers** are used to place AI units randomly within a certain area.

To create a **placer**, place a **Game Logic** entity somewhere.

In its init box enter this:<br>
<pre>
this setVariable ["logicType", "placer"];
this setVariable ["minSpawnRadius", <b>0</b>];
this setVariable ["maxSpawnRadius", <b>600</b>];
</pre>

You may adjust the **numbers** for minSpawnRadius and maxSpawnRadius. These values determine the min/max distance from the placer where units can be spawned.

Sync the **placer** to the **Patrol Center**.

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

You can also make **placers** place other **placers**. For example to randomize the position of a smaller area where certain units spawn somewhere within a larger area.

Due to technical reasons syncing can't be used and it has to be done this way:

Create a **placer** as usual, sync it to the **patrolCenter**

Create another **placer** as usual. Sync units to it (or use the **groups** variable, see above) but DON'T sync the placer itself to anything. You must give this **placer** a name. For example **randomized_position_spawner**

Add this to the first **placer's** init box:
<pre>
this setVariable ["childPlacers", [<b>randomized_position_spawner</b>]];
</pre>

You can use more than one:<br>
<pre>
this setVariable ["childPlacers", [<b>unitPlacer1</b>, <b>unitPlacer2</b>]];
</pre>

## Configuring Placers To Place Camps

You can spawn camps by adding this to a spawner's init box:
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
