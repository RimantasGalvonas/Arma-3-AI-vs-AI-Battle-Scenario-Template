params ["_unit"];

_unit createDiaryRecord [
    "Diary",
    [
        "Singleplayer/Multiplayer",
        "When running this mission in single player mode, you may switch to any other friendly unit using Team Switch (U key or the button on the death screen).<br/><br/>" +
        "In multiplayer mode, you always spawn at the back of the battle area. There will be a supply box next to you which gives you access to the Arsenal. Make sure you stock up on ammo before going out!"
]];

_unit createDiaryRecord [
    "Diary",
    [
        "AI Behavior",
        "Fresh units continuously replace the casualties from the edge of the ever-shifting battle area.<br/><br/>" +
        "After spawning, the AI groups start moving towards a random location within the battle area to look for enemies.<br/><br/>" +
        "When a group discovers an enemy, they inform other friendly groups about the enemy location.<br/><br/>" +
        "If a group is sufficiently close to a known enemy location and is not currently seeking out another target, it will start moving to the known enemy location.<br/><br/>" +
        "Before attacking the enemy, the AI will try to find a good position to attack from taking availability of cover, proximity to other friendlies and height advantage into account.<br/><br/>" +
        "Groups may divert from their current target if they receive new intel about an enemy location that is at least 200 meters closer than their current target.<br/><br/>" +
        "Groups may also switch to different targets depending on how many other groups are also attacking their target, preferring unengaged enemies.<br/><br/>" +
        "Groups will ignore targets that are already being attacked by 3 other friendly groups and continue looking for different targets."
]];

_unit createDiaryRecord [
    "Diary",
    [
        "Mission Configuration Tips",
        "The mission host is presented with a configuration window to select the mission area, define some AI behavior and set up AI spawners.<br/><br/>" +
        "Use the <font face=""EtelkaMonospacePro"" size=""12"">Toggle entities</font> button and look for <font face=""EtelkaMonospacePro"" size=""12"">win_trigger</font> and <font face=""EtelkaMonospacePro"" size=""12"">lose_trigger</font> markers to see which direction the battle will go.<br/><br/>" +
        "The size of the chosen mission area can make a huge difference in the pace of the battle.<br/>" +
        "A large (~2000m width) mission area spreads the groups further apart and produces a slower, more tactical gameplay, while a smaller (~800m width) area makes for a more crowded battlefield and a more quick-paced, intense gameplay.<br/><br/>" +
        "This mission works best as an infantry-only mission, however feel free to configure it to spawn vehicles (in <font face=""EtelkaMonospacePro"" size=""12"">Faction config</font>), if the terrain is suitable for it.<br/><br/>" +
        "If you're going to be setting up airfield units, add them as custom groups with a single aircraft each - default groups with multiple aircraft may get stuck.<br/><br/>" +
        "A preset with the last used configuration is automatically generated when you start the mission."
]];

_unit createDiaryRecord [
    "Diary",
    [
        "Force Through",
        "Welcome to <font face=""PuristaBold"">Force Through</font>, a customizable AI vs AI scenario putting you in a relentless battle with one, simple objective - take the mission area from the enemy.<br/>" +
        "Be aggressive, push the enemy out, hold out against counterattacks, take initiative when needed and always try to push forward.<br/><br/><br/>" +
        "Once the mission starts, a black square (<font face=""EtelkaMonospacePro"" size=""12"">active battle zone</font>) with a red line in the middle (<font face=""EtelkaMonospacePro"" size=""12"">frontline</font>) will be placed on the map.<br/>" +
        "<img image=""mission\ForceThrough\diary_map.jpg"" width=""150"" height=""150""/><br/>" +
        "The mission ends when the <font face=""EtelkaMonospacePro"" size=""12"">frontline</font> is pushed across the map to the goal marked by the enemy's color.<br/>" +
        "Reinforcements spawn at the edge of the <font face=""EtelkaMonospacePro"" size=""12"">active battle zone</font>.<br/>" +
        "Both sides have unlimited reinforcements that continuously arrive as units are killed off, maintaining a constant amount of units in the field throughout the battle.<br/>" +
        "The <font face=""EtelkaMonospacePro"" size=""12"">active battle zone</font> and the <font face=""EtelkaMonospacePro"" size=""12"">frontline</font> are updated every 60 seconds according to the position of units in the mission area.<br/><br/><br/>" +
        "In this mission you never have to go alone - use the <font face=""EtelkaMonospacePro"" size=""12"">Join a nearby group</font> in the actions menu to join other units.<br/>" +
        "You may also take over as the group leader. When leading a group, feel free to take initiative and ignore the generated waypoints."
]];