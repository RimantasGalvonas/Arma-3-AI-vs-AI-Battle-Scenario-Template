player createDiaryRecord ["Diary", ["AI Behavior", "Fresh units continuously replace the casualties from the edge of the ever-shifting battle area.<br/><br/>After spawning, the AI groups start moving towards a random location within the battle area to look for enemies.<br/><br/>When a group discovers an enemy, they inform other friendly groups about the enemy location.<br/><br/>If a group is sufficiently close to a known enemy location and is not currently seeking out another target, it will start moving to the known enemy location.<br/><br/>Before attacking the enemy, the AI will try to find a good position to attack from taking availability of cover, proximity to other friendlies and height advantage into account.<br/><br/>Groups may divert from their current target if they receive new intel about an enemy location that is at least 200 meters closer than their current target.<br/><br/>Groups may also switch to different targets depending on how many other groups are also attacking their target, preferring unengaged enemies.<br/><br/>Groups will ignore targets that are already being attacked by 3 other friendly groups and continue looking for different targets."]];
player createDiaryRecord ["Diary", ["Force Through", "The goal of this game mode is to push the frontline (red line on the map) towards the enemy starting position.<br/>During the battle, the front line is recalculated every 60 seconds as the average position of groups within the battle area. So you must hold back the enemy and push forward.<br/>Note that it is normal for the mission area to move around a lot at the start of the mission before the battle naturally settles into a frontline.<br/><br/><br/>On single player mode, you may switch to any other friendly unit using Team Switch (U key or the button on the death screen)<br/><br/>On multiplayer you get an option to join a nearby group so you don't have to go lone-wolf.<br/>You also have an option to then take over as that group's leader, however this can only be done if the leader is an AI unit. If you wish to switch leadership roles with another player, have him rejoin his own group to drop the leadership role."]];


"supplies_marker_1" setMarkerAlpha 0;
"supplies_marker_2" setMarkerAlpha 0;
"team2_start_marker" setMarkerAlpha 0;
"team1_start_marker" setMarkerAlpha 0;

player addRating -10000; // Otherwise reveals independents on the map before you teamswitch

if (!isMultiplayer) then {
    private _initialPlayable = synchronizedObjects initialPlayableUnitsManager;

    {
        deleteVehicle _x; // Doesn't delete the player
    } forEach (_initialPlayable);

    addMissionEventHandler [
        "TeamSwitch",
        {
            params ["_previousUnit", "_newUnit"];

            if (_previousUnit in (_thisArgs select 0)) then {
                deleteVehicle _previousUnit;
            };
        },
        [_initialPlayable]
    ];
};

ForceThrough_ReversePresetGenerationProcess = [] spawn ForceThrough_fnc_generateReversedDefaultPreset;