/*
Author: KC Grimes
Script: Grimes Simple Revive
Version: V0.92
*/
////Editable parameters, sorted by category and relevance - Please adjust values to suit your application.
//Generic
G_Briefing = true; //true = information, how to, and credits will be displayed on ingame briefing screen. Can be used in conjunction with your own briefing. false = disabled. 

//Revive
G_Revive_System = true; //Whether the revive system will be used or not. true = enabled, false = disabled.
G_Revive_AI_Incapacitated = [WEST, EAST, RESISTANCE, CIVILIAN]; //Array of sides of AI that will utilize revive system
G_Revive_Unit_Exclusion = []; //Array of variable names of units to exclude from the revive system
G_Revive_bleedoutTime = 300; //Amount of time (in seconds) unit is available to be revived, before being forced to respawn. If -1, no time limit.
G_Allow_GiveUp = true; //Allow player to force death while incapacitated. true = enabled, false = disabled.
G_Revive_DownsPerLife = 0; //Number of times unit can go Incapacitated in single life. 0 = Unlimited, integer > 0 = limit of downs per life.
G_Revive_addonRadio_muteTransmit = false; //Mute radio transmissions in addons ACRE2 or TFAR while incapacitated. true = enabled, false = disabled. 
G_Revive_addonRadio_muteReceive = false; //Mute radio reception in addons ACRE2 or TFAR while incapacitated. true = enabled, false = disabled. 
G_Revive_Can_Revive = []; //Classnames of units that can revive. Wrap in quotes, separate by commas. If empty, all can revive.
G_Revive_actionTime = 10; //Time (in seconds) required for reviver to complete revive action
G_Revive_Requirement = 0; //1 or greater = number of FAKs (single use) or Medikit (unlimited use) needed to revive (and treat still). 0 = Those items only needed to treat, not revive (stock).
G_Revive_Black_Screen = false; //true = While Incapacitated/waiting for revive, screen stays black. false = Screen goes black at death then fades back in, with surroundings visible.
G_Revive_Action_Color = "#FFCC00"; //HTML color code that will be the color of the Revive, Drag, Carry, and Load/Unload action text. Default is Orange. 
G_Revive_Load_Types = ["Car","Tank","Helicopter","Plane","Ship"]; //Array of strings of kinds of vehicles that incapacitated units can be loaded into
G_Eject_Occupants = false; //If killed while in a vehicle, the revivable unit is ejected from the vehicle. True = enabled, false = disabled.
G_Explosion_Eject_Occupants = true; //Once the wreck of an exploded vehicle comes to a stop (air or land), the occupants will be ejected and revivable. True to enable, false to disable (units will bypass revive and be forced to respawn).
G_Revive_Reward = 0; //0 = No lives rewarded for revive. 1 and up = number of lives rewarded for reviving. (CAN be a decimal)
G_TK_Penalty = 0; //Amount of lives a Team Killer loses per team kill. Note, must be negative to be negative result (Ex. Value of -2 means 2 lives lost per TK) (CAN be a decimal)
G_Revive_Messages = 1; //Chat messages upon incapacitation and revive. 0 = None. 1 = Friendly only. 2 = All.
G_End_When_Side_Down = true; //true = When all units friendly to a side are incapacitated and/or unable to respawn the server will end the mission, false = server will not handle ending mission for side

//Respawn/Initial Spawn
G_Respawn_Button = true; //true = Respawn Button enabled, false = Respawn button disabled
G_Respawn_Time = 10; //Amount of time (in seconds) dead unit must wait before being able to respawn (overrides description.ext setting)
G_Num_Respawns = 3; //Number of lives/respawns available to players (must be integer). -1 = unlimited, 0 and up are actual values.
G_Spectator = true; //Upon expending all lives, the player will be put into a spectator camera. If false, mission ends only for that specific player.
G_Squad_Leader_Spawn = true; //Allows spawning on squad leader. Spawn in squad leader's stance. true = enabled, false = disabled.
G_Squad_Leader_Marker = true; //Displays marker on map indicating squad leader's position. true = enabled, false = disabled.
	G_Squad_Leader_Mkr_Type = "respawn_inf"; //Shape of marker
	G_Squad_Leader_Mkr_Color = "ColorBlack"; //Color of marker
	G_Squad_Leader_Mkr_Text = "Squad Leader"; //Text beside marker
	G_Squad_Leader_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
G_AI_Fixed_Spawn = true; //Upon respawn, the AI will spawn at the marker defined below for their respective side, as opposed to respawning at random if multiple markers exist
	G_AI_Fixed_Spawn_WEST = "respawn_west_0";
	G_AI_Fixed_Spawn_EAST = "respawn_east_0";
	G_AI_Fixed_Spawn_IND = "respawn_guerrila_0";
	G_AI_Fixed_Spawn_CIV = "";

//Mobile Respawn Vehicle
//Note - To enable, simply add the editor-placed vehicle's name into the appropriate array depending on the intended side. It will not be wrapped in quotes. So, it will be vehname and not "vehname". If multiple vehicles, separate by commas.
G_Mobile_Respawn_WEST = [MobileRespawnWEST]; 
G_Mobile_Respawn_EAST = [MobileRespawnEAST];
G_Mobile_Respawn_IND = [MobileRespawnIND];
G_Mobile_Respawn_CIV = [];
G_Mobile_Respawn_Locked = true; //Lock enemy MRVs so MRVs can only be accessed by their own team. true = enabled, false = disabled.
G_Mobile_Respawn_Movable = false; //true = Deployed mobile respawn can be moved while remaining deployed, false = Deployed mobile respawn is immobile. 
G_Mobile_Respawn_Wreck = 10; //Time (in seconds) after mobile respawn is destroyed before the wreck is deleted
G_Mobile_Respawn_RespTimer = 20; //Time (in seconds) for mobile respawn to respawn at starting position/direction
G_Mobile_Respawn_Marker = true; //Displays marker on map indicating MRV's position. true = enabled, false = disabled.
	G_Mobile_Respawn_Mkr_Type = "respawn_motor"; //Shape of marker
	G_Mobile_Respawn_Mkr_Color = "ColorBlack"; //Color of marker
	G_Mobile_Respawn_Mkr_Text = "MRV"; //Text beside marker
	G_Mobile_Respawn_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
	G_Mobile_Respawn_Mkr_Display = false; //Whether or not marker is always visible (true = marker always visible, false = marker only visible when MRV is deployed

//Unit Tags
G_Unit_Tag = true; //Refers to unit "name tags" that display over unit's head on HUD. Only friendlies visible. true = enabled, false = disabled.
	G_Unit_Tag_Display = 0; //0 = Press defined key to have names visible for defined time, 1 = Cursor over unit to have name displayed, 2 = Names always displayed
		G_Unit_Tag_Display_Key = 219; //Only used if Display 0 is that value above. Key number. Default is the Left Windows Key. See key codes for more options.
		G_Unit_Tag_Display_Time = 2; //Only used if Display 0 is that value above. Time (in seconds) names display when key pressed
	G_Unit_Tag_Distance = 75; //Distance from player that marker will begin to appear
	G_Unit_Tag_ShowDistance = true; //Distance is displayed next to player's name
	G_Unit_Tag_Color = [1,1,1]; //RGB settings for the tag color of non-squad members. Alpha is normally the 4th number, but that is handled in the script via a distance formula.
	G_Unit_Tag_SquadColor = [1,1,0.1]; //RGB settings for the tag color of squad members. Alpha is normally the 4th number, but that is handled in the script via a distance formula.

//Custom Executions
//Note - By default they will execute on AI as well. Read comment to side.
G_Custom_Exec_1 = ""; //File executed when unit is set Incapacitated (NOT "killed"). _incapacitatedUnit = _this select 0, and is local.
G_Custom_Exec_2 = ""; //File executed when unit is killed (not revivable; unit is officially killed). _killedUnit = _this select 0, and is local.
G_Custom_Exec_3 = ""; //File executed when unit respawns after being killed. _respawnedUnit = _this select 0, and is local.
G_Custom_Exec_4 = ""; //File executed when MRV respawns after being destroyed. Newly spawned MRV = _this select 0, and is local. 
G_Custom_Exec_5 = ""; //File executed when unit is revived. _revivedUnit = _this select 0, and is local. _rescuer = _this select 1. 

////DO NOT EDIT
[] execVM "G_Revive\G_Revive_Init_Vars.sqf";